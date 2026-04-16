"""
FPGA Spectrogram Viewer + Waveform Simulator
==============================================
Left panel:  Live UART spectrogram from CMOD A7 FPGA.
Right panel: Software waveform simulator with identical FFT pipeline.
Bottom bar:  Real-time comparison metrics (cosine similarity, correlation,
             RMSE) and normalized spectrum overlay.

Both panels show a current-spectrum bar chart (log₂ frequency scale)
and a scrolling waterfall spectrogram on the same 0–23.4 kHz axis.

Protocol (from recorder_top.v):
  RMS frame (8 bytes):  AA 55 result rms flags seq metric checksum
  Spec slice (6 bytes): DD 77 bin_idx bin_lo bin_hi checksum

Usage:
  python spectrogram_viewer.py
  Select port and baud rate from the GUI, then click Connect.
"""

import threading
import time
from collections import deque

import serial
import serial.tools.list_ports

import tkinter as tk
from tkinter import ttk, scrolledtext

import numpy as np

# Try to import matplotlib for the embedded plot
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
BAUD_RATE = 1_000_000
NUM_BINS = 64
WATERFALL_ROWS = 128           # number of time-rows kept in waterfall
SPEC_SYNC = (0xDD, 0x77)
RMS_SYNC  = (0xAA, 0x55)

# Frequency axis: 64 bins spanning 0 to ~23.4 kHz (46.875 kHz / 2)
# Only first 256 of 512 FFT bins used (real FFT), downsampled by 4 -> 64 bins
SAMPLE_RATE = 46875.0
NYQUIST = SAMPLE_RATE / 2.0
FFT_N = 512
BIN_SPACING = SAMPLE_RATE / FFT_N      # ~91.6 Hz per raw FFT bin
# Output bin k maps to FFT bin k*4, so center freq = k * 4 * BIN_SPACING
FREQ_AXIS = np.array([k * 4 * BIN_SPACING for k in range(NUM_BINS)])  # Hz

MAX_LOG_LINES = 500
SIMILARITY_HISTORY = 200       # number of past similarity values to plot


# ---------------------------------------------------------------------------
# Comparison helpers
# ---------------------------------------------------------------------------
def _normalize(arr):
    """Normalize array to [0, 1] by its max. Returns zeros if all zero."""
    peak = arr.max()
    if peak < 1e-12:
        return np.zeros_like(arr, dtype=np.float64)
    return arr.astype(np.float64) / peak


def cosine_similarity(a, b):
    """Cosine similarity between two vectors (0 = orthogonal, 1 = identical shape)."""
    dot = np.dot(a, b)
    na = np.linalg.norm(a)
    nb = np.linalg.norm(b)
    if na < 1e-12 or nb < 1e-12:
        return 0.0
    return float(dot / (na * nb))


def pearson_correlation(a, b):
    """Pearson correlation coefficient (-1 to 1)."""
    if a.std() < 1e-12 or b.std() < 1e-12:
        return 0.0
    return float(np.corrcoef(a, b)[0, 1])


def normalized_rmse(a, b):
    """RMSE between two [0,1]-normalized vectors. Lower = more similar."""
    return float(np.sqrt(np.mean((a - b) ** 2)))


# ---------------------------------------------------------------------------
# Serial reader thread
# ---------------------------------------------------------------------------
class UARTReader:
    """Parses FPGA UART frames in a background thread."""

    def __init__(self, port: str, baud: int = BAUD_RATE):
        self.port = port
        self.baud = baud
        self.ser = None
        self._stop = threading.Event()

        # Latest state (written by reader, read by GUI)
        self.lock = threading.Lock()
        self.spectrum = np.zeros(NUM_BINS, dtype=np.uint16)
        self.waterfall = np.zeros((WATERFALL_ROWS, NUM_BINS), dtype=np.float64)
        self.rms = 0
        self.result = 0
        self.flags = 0
        self.seq = 0
        self.metric = 0

        # Counters
        self.rms_frames = 0
        self.spec_frames = 0
        self.spec_sweeps = 0
        self.checksum_errors = 0
        self.sync_errors = 0
        self.bin_range_errors = 0

        # Error/event log (deque, thread-safe for append)
        self.log = deque(maxlen=MAX_LOG_LINES)

        # Track whether a full 64-bin sweep has been received
        self._bins_received = set()

    # ------------------------------------------------------------------
    def open(self):
        self.ser = serial.Serial(
            port=self.port,
            baudrate=self.baud,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=0.1,
        )
        self._log(f"Opened {self.port} @ {self.baud} baud")

    def close(self):
        self._stop.set()
        if self.ser and self.ser.is_open:
            self.ser.close()
            self._log("Serial port closed")

    def start(self):
        self._stop.clear()
        t = threading.Thread(target=self._run, daemon=True)
        t.start()

    def stop(self):
        self._stop.set()

    # ------------------------------------------------------------------
    def _log(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.log.append(f"[{ts}] {msg}")

    # ------------------------------------------------------------------
    def _run(self):
        """Main read loop — byte-level state machine."""
        buf = bytearray()

        while not self._stop.is_set():
            try:
                chunk = self.ser.read(256)
            except serial.SerialException as e:
                self._log(f"ERROR: Serial read failed: {e}")
                break
            if not chunk:
                continue
            buf.extend(chunk)

            # Process all complete frames in buffer
            while len(buf) >= 2:
                # Look for a sync pair
                if buf[0] == 0xAA and buf[1] == 0x55:
                    if len(buf) < 8:
                        break  # wait for full frame
                    self._parse_rms(buf[:8])
                    del buf[:8]

                elif buf[0] == 0xDD and buf[1] == 0x77:
                    if len(buf) < 6:
                        break  # wait for full frame
                    self._parse_spec(buf[:6])
                    del buf[:6]

                else:
                    # Not a sync byte — discard and report
                    bad = buf[0]
                    del buf[:1]
                    with self.lock:
                        self.sync_errors += 1
                    self._log(f"SYNC_ERROR: unexpected byte 0x{bad:02X}, discarded")

        self._log("Reader thread exiting")

    # ------------------------------------------------------------------
    def _parse_rms(self, frame: bytearray):
        # frame: AA 55 result rms flags seq metric chk
        result, rms, flags, seq, metric, chk = frame[2], frame[3], frame[4], frame[5], frame[6], frame[7]
        expected = 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric

        with self.lock:
            self.rms_frames += 1
            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"RMS_CHECKSUM_ERROR: seq={seq} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[result={result} rms={rms} flags=0x{flags:02X} metric={metric}]"
                )
                return
            self.rms = rms
            self.result = result
            self.flags = flags
            self.seq = seq
            self.metric = metric

    # ------------------------------------------------------------------
    def _parse_spec(self, frame: bytearray):
        # frame: DD 77 bin_idx bin_lo bin_hi chk
        bin_idx, bin_lo, bin_hi, chk = frame[2], frame[3], frame[4], frame[5]
        expected = 0xDD ^ 0x77 ^ bin_idx ^ bin_lo ^ bin_hi

        with self.lock:
            self.spec_frames += 1

            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"SPEC_CHECKSUM_ERROR: bin={bin_idx} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[lo=0x{bin_lo:02X} hi=0x{bin_hi:02X}]"
                )
                return

            if bin_idx > 63:
                self.bin_range_errors += 1
                self._log(f"BIN_RANGE_ERROR: bin_idx={bin_idx} out of 0-63")
                return

            mag = bin_lo | (bin_hi << 8)
            self.spectrum[bin_idx] = mag

            self._bins_received.add(bin_idx)
            if len(self._bins_received) == NUM_BINS:
                # Full sweep completed — push to waterfall
                self._bins_received.clear()
                self.spec_sweeps += 1
                # Shift waterfall down, add new row at top
                self.waterfall = np.roll(self.waterfall, 1, axis=0)
                self.waterfall[0, :] = self.spectrum.astype(np.float64)


# ---------------------------------------------------------------------------
# Waveform simulator
# ---------------------------------------------------------------------------
NOTE_PRESETS = [
    ("A4  440",   440.0),
    ("C4  262",   261.63),
    ("E4  330",   329.63),
    ("G4  392",   392.00),
    ("A5  880",   880.0),
    ("C5  523",   523.25),
    ("1 kHz",     1000.0),
    ("5 kHz",     5000.0),
    ("10 kHz",    10000.0),
    ("15 kHz",    15000.0),
    ("20 kHz",    20000.0),
]

WAVEFORM_TYPES = ("sine", "square", "sawtooth", "triangle")


class WaveformSimulator:
    """Generate test waveforms and compute 64-bin spectrum matching the FPGA pipeline.

    Pipeline: time-domain samples at 46 875 Hz -> Hann window (512 pts)
              -> 512-pt FFT -> magnitude of first 256 bins
              -> every-4th downsample -> 64 output bins (0-23.4 kHz).
    """

    def __init__(self):
        self.enabled = True
        self.waveform = "sine"
        self.frequency = 1000.0   # Hz
        self.amplitude = 0.8      # 0 .. 1
        self.spectrum = np.zeros(NUM_BINS, dtype=np.float64)
        self.waterfall = np.zeros((WATERFALL_ROWS, NUM_BINS), dtype=np.float64)
        self._phase_offset = 0.0
        self._hann = np.hanning(FFT_N)

    def step(self):
        """Compute one 512-sample FFT frame and push to waterfall."""
        if not self.enabled:
            self.spectrum[:] = 0.0
            self.waterfall = np.roll(self.waterfall, 1, axis=0)
            self.waterfall[0, :] = 0.0
            return

        t = (np.arange(FFT_N) + self._phase_offset) / SAMPLE_RATE
        self._phase_offset += FFT_N

        f = self.frequency
        wtype = self.waveform

        if wtype == "sine":
            sig = np.sin(2.0 * np.pi * f * t)
        elif wtype == "square":
            sig = np.sign(np.sin(2.0 * np.pi * f * t))
        elif wtype == "sawtooth":
            sig = 2.0 * ((f * t) % 1.0) - 1.0
        elif wtype == "triangle":
            sig = 2.0 * np.abs(2.0 * ((f * t) % 1.0) - 1.0) - 1.0
        else:
            sig = np.zeros(FFT_N)

        # Scale to 16-bit range (matching FPGA I2S path: raw_s16 = sample[23:8])
        sig *= self.amplitude * 32767.0

        # Hann window -> FFT -> magnitude of first 256 bins -> every-4th downsample
        fft_mag = np.abs(np.fft.fft(sig * self._hann))
        self.spectrum = fft_mag[::4][:NUM_BINS]

        self.waterfall = np.roll(self.waterfall, 1, axis=0)
        self.waterfall[0, :] = self.spectrum


# ---------------------------------------------------------------------------
# GUI Application
# ---------------------------------------------------------------------------
class SpectrogramApp:
    REFRESH_MS = 100  # GUI update interval

    def __init__(self):
        self.reader = None
        self.connected = False
        self.sim = WaveformSimulator()

        # Comparison state
        self._last_live_spectrum = np.zeros(NUM_BINS, dtype=np.float64)
        self._cosine_history = deque([0.0] * SIMILARITY_HISTORY, maxlen=SIMILARITY_HISTORY)
        self._corr_history = deque([0.0] * SIMILARITY_HISTORY, maxlen=SIMILARITY_HISTORY)

        self.root = tk.Tk()
        self.root.title("FPGA Spectrogram Viewer + Simulator")
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)
        self.root.minsize(1600, 900)
        self.root.configure(bg="#2b2b2b")

        # ---- Dark theme for ttk widgets ----
        BG       = "#2b2b2b"
        BG_DARK  = "#1e1e1e"
        FG       = "#cccccc"
        FG_DIM   = "#888888"
        ACCENT   = "#3a3a3a"
        BORDER   = "#555555"
        SEL_BG   = "#404040"
        ENTRY_BG = "#333333"

        style = ttk.Style(self.root)
        style.theme_use("clam")

        style.configure(".",
                         background=BG, foreground=FG,
                         fieldbackground=ENTRY_BG, bordercolor=BORDER,
                         darkcolor=BG_DARK, lightcolor=ACCENT,
                         troughcolor=BG_DARK, selectbackground=SEL_BG,
                         selectforeground=FG, font=("Segoe UI", 9))
        style.configure("TLabel", background=BG, foreground=FG)
        style.configure("TFrame", background=BG)
        style.configure("TLabelframe", background=BG, foreground=FG,
                         bordercolor=BORDER)
        style.configure("TLabelframe.Label", background=BG, foreground=FG)
        style.configure("TButton", background=ACCENT, foreground=FG,
                         bordercolor=BORDER, padding=(6, 2))
        style.map("TButton",
                   background=[("active", "#505050"), ("pressed", "#606060")])
        style.configure("TEntry", fieldbackground=ENTRY_BG, foreground=FG,
                         insertcolor=FG, bordercolor=BORDER)
        style.configure("TCombobox", fieldbackground=ENTRY_BG, foreground=FG,
                         selectbackground=SEL_BG, bordercolor=BORDER)
        style.map("TCombobox",
                   fieldbackground=[("readonly", ENTRY_BG)],
                   selectbackground=[("readonly", SEL_BG)])
        style.configure("TCheckbutton", background=BG, foreground=FG)
        style.map("TCheckbutton", background=[("active", ACCENT)])
        style.configure("TScale", background=BG, troughcolor=BG_DARK,
                         bordercolor=BORDER)
        style.configure("TPanedwindow", background=BG)
        style.configure("Sash", sashthickness=6, background=BORDER)

        # Make tk Combobox popdown dark
        self.root.option_add("*TCombobox*Listbox.background", ENTRY_BG)
        self.root.option_add("*TCombobox*Listbox.foreground", FG)
        self.root.option_add("*TCombobox*Listbox.selectBackground", SEL_BG)
        self.root.option_add("*TCombobox*Listbox.selectForeground", FG)

        self._build_ui()
        self._schedule_update()

    # ------------------------------------------------------------------
    @staticmethod
    def _make_spectrum_axes(fig, bar_color, edge_color, title_prefix):
        """Create matched bar-chart + waterfall subplots on *fig*.

        Returns (bar_freqs, bars, ax_bar, ax_wf, wf_img).
        """
        fig.set_facecolor("#2b2b2b")

        ax_bar = fig.add_subplot(2, 1, 1)
        ax_bar.set_facecolor("#1e1e1e")
        ax_bar.set_title(
            f"{title_prefix} — Spectrum (0–23.4 kHz)",
            color="white", fontsize=9,
        )
        ax_bar.set_xlabel("Frequency (Hz) — log₂ scale", color="white", fontsize=7)
        ax_bar.set_ylabel("Magnitude", color="white", fontsize=7)
        ax_bar.set_xscale("log", base=2)
        ax_bar.tick_params(colors="white", labelsize=6)

        bar_freqs = FREQ_AXIS.copy()
        bar_freqs[0] = max(bar_freqs[0], bar_freqs[1] / 2)
        bar_widths = np.diff(np.append(bar_freqs, NYQUIST)) * 0.8
        bars = ax_bar.bar(
            bar_freqs, np.zeros(NUM_BINS), width=bar_widths,
            color=bar_color, edgecolor=edge_color, align="edge",
        )
        ax_bar.set_xlim(bar_freqs[0] * 0.8, NYQUIST * 1.05)
        ax_bar.set_ylim(0, 1000)

        ax_wf = fig.add_subplot(2, 1, 2)
        ax_wf.set_facecolor("#1e1e1e")
        ax_wf.set_title(f"{title_prefix} — Waterfall", color="white", fontsize=9)
        ax_wf.set_xlabel("Frequency (kHz)", color="white", fontsize=7)
        ax_wf.set_ylabel("Time (sweeps ago)", color="white", fontsize=7)
        ax_wf.tick_params(colors="white", labelsize=6)

        tick_pos = [0, 8, 16, 24, 32, 40, 48, 56, 63]
        tick_lbl = [f"{FREQ_AXIS[i]/1000:.1f}" for i in tick_pos]
        ax_wf.set_xticks(tick_pos)
        ax_wf.set_xticklabels(tick_lbl)

        wf_img = ax_wf.imshow(
            np.zeros((WATERFALL_ROWS, NUM_BINS)),
            aspect="auto", origin="upper", cmap="inferno",
            interpolation="nearest", vmin=0, vmax=1000,
        )
        fig.colorbar(wf_img, ax=ax_wf, label="Magnitude", pad=0.02)
        fig.tight_layout(pad=1.5)

        return bar_freqs, bars, ax_bar, ax_wf, wf_img

    # ------------------------------------------------------------------
    def _build_ui(self):
        # ---- Connection toolbar (full width) ----
        conn_frame = ttk.LabelFrame(self.root, text="Connection")
        conn_frame.pack(fill=tk.X, padx=6, pady=(6, 0))

        ttk.Label(conn_frame, text="Port:").pack(side=tk.LEFT, padx=(6, 2))
        self.port_var = tk.StringVar()
        self.port_combo = ttk.Combobox(
            conn_frame, textvariable=self.port_var, width=40, state="readonly"
        )
        self.port_combo.pack(side=tk.LEFT, padx=(0, 4))
        self._refresh_ports()

        self.btn_refresh = ttk.Button(conn_frame, text="Refresh", width=7, command=self._refresh_ports)
        self.btn_refresh.pack(side=tk.LEFT, padx=(0, 10))

        ttk.Label(conn_frame, text="Baud:").pack(side=tk.LEFT, padx=(0, 2))
        self.baud_var = tk.StringVar(value="1000000")
        self.baud_entry = ttk.Entry(conn_frame, textvariable=self.baud_var, width=10)
        self.baud_entry.pack(side=tk.LEFT, padx=(0, 10))

        self.btn_connect = ttk.Button(conn_frame, text="Connect", command=self._toggle_connection)
        self.btn_connect.pack(side=tk.LEFT, padx=(0, 10))

        self.lbl_conn_status = ttk.Label(conn_frame, text="Disconnected", foreground="gray")
        self.lbl_conn_status.pack(side=tk.LEFT, padx=(0, 6))

        conn_frame.pack_configure(pady=(6, 2))

        # ---- Main split: Live (left) | Simulator (right) ----
        main_pw = ttk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        main_pw.pack(fill=tk.BOTH, expand=True, padx=6, pady=4)

        # ========== LEFT PANEL: Live UART viewer ==========
        left_frame = ttk.LabelFrame(main_pw, text="Live UART")
        main_pw.add(left_frame, weight=1)

        # Status bar
        status_frame = ttk.Frame(left_frame)
        status_frame.pack(fill=tk.X, padx=4, pady=(2, 0))

        self.lbl_rms = ttk.Label(status_frame, text="RMS: --")
        self.lbl_rms.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_seq = ttk.Label(status_frame, text="Seq: --")
        self.lbl_seq.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_result = ttk.Label(status_frame, text="Result: --")
        self.lbl_result.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_stats = ttk.Label(status_frame, text="Sweeps: 0 | Err: 0")
        self.lbl_stats.pack(side=tk.RIGHT)

        # Live matplotlib figure
        self.fig_live = Figure(figsize=(6, 4.5), dpi=96)
        objs = self._make_spectrum_axes(self.fig_live, "#00d4aa", "#006655", "Live")
        self.bar_freqs, self.bars_live, self.ax_bar_live, self.ax_wf_live, self.wf_img_live = objs

        self.canvas_live = FigureCanvasTkAgg(self.fig_live, master=left_frame)
        self.canvas_live.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)

        # ========== RIGHT PANEL: Waveform Simulator ==========
        right_frame = ttk.LabelFrame(main_pw, text="Waveform Simulator")
        main_pw.add(right_frame, weight=1)

        # -- Row 1: waveform type + enable --
        ctrl1 = ttk.Frame(right_frame)
        ctrl1.pack(fill=tk.X, padx=4, pady=(4, 0))

        ttk.Label(ctrl1, text="Wave:").pack(side=tk.LEFT, padx=(0, 2))
        self.wave_var = tk.StringVar(value="sine")
        wave_cb = ttk.Combobox(
            ctrl1, textvariable=self.wave_var,
            values=list(WAVEFORM_TYPES), state="readonly", width=10,
        )
        wave_cb.pack(side=tk.LEFT, padx=(0, 10))
        wave_cb.bind("<<ComboboxSelected>>", self._on_sim_param_change)

        self.sim_enable_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(
            ctrl1, text="Enable", variable=self.sim_enable_var,
            command=self._on_sim_param_change,
        ).pack(side=tk.LEFT, padx=(0, 10))

        # -- Row 2: frequency --
        ctrl2 = ttk.Frame(right_frame)
        ctrl2.pack(fill=tk.X, padx=4, pady=(2, 0))

        ttk.Label(ctrl2, text="Freq:").pack(side=tk.LEFT, padx=(0, 2))
        self.freq_var = tk.DoubleVar(value=1000.0)
        self.freq_scale = ttk.Scale(
            ctrl2, from_=20, to=22000, orient=tk.HORIZONTAL,
            variable=self.freq_var, command=self._on_freq_slider,
        )
        self.freq_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 4))
        self.freq_entry = ttk.Entry(ctrl2, width=7)
        self.freq_entry.insert(0, "1000")
        self.freq_entry.pack(side=tk.LEFT, padx=(0, 2))
        self.freq_entry.bind("<Return>", self._on_freq_entry)
        ttk.Label(ctrl2, text="Hz").pack(side=tk.LEFT)

        # -- Row 3: amplitude --
        ctrl3 = ttk.Frame(right_frame)
        ctrl3.pack(fill=tk.X, padx=4, pady=(2, 0))

        ttk.Label(ctrl3, text="Amp:").pack(side=tk.LEFT, padx=(0, 2))
        self.amp_var = tk.DoubleVar(value=0.8)
        self.amp_scale = ttk.Scale(
            ctrl3, from_=0.0, to=1.0, orient=tk.HORIZONTAL,
            variable=self.amp_var, command=self._on_amp_slider,
        )
        self.amp_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 4))
        self.amp_entry = ttk.Entry(ctrl3, width=5)
        self.amp_entry.insert(0, "0.80")
        self.amp_entry.pack(side=tk.LEFT)
        self.amp_entry.bind("<Return>", self._on_amp_entry)

        # -- Row 4: note / frequency presets --
        preset_frame = ttk.LabelFrame(right_frame, text="Presets")
        preset_frame.pack(fill=tk.X, padx=4, pady=(4, 0))

        for i, (label, freq) in enumerate(NOTE_PRESETS):
            btn = ttk.Button(
                preset_frame, text=label, width=9,
                command=lambda f=freq: self._apply_preset(f),
            )
            btn.grid(row=i // 6, column=i % 6, padx=2, pady=2, sticky="ew")
        for col in range(6):
            preset_frame.columnconfigure(col, weight=1)

        # Simulator matplotlib figure (same axes as live)
        self.fig_sim = Figure(figsize=(6, 4.5), dpi=96)
        sim_objs = self._make_spectrum_axes(self.fig_sim, "#e09040", "#805020", "Simulator")
        _, self.bars_sim, self.ax_bar_sim, self.ax_wf_sim, self.wf_img_sim = sim_objs

        self.canvas_sim = FigureCanvasTkAgg(self.fig_sim, master=right_frame)
        self.canvas_sim.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)

        # ========== COMPARISON PANEL (full width) ==========
        cmp_frame = ttk.LabelFrame(self.root, text="Live vs Simulator Comparison (normalized)")
        cmp_frame.pack(fill=tk.X, padx=6, pady=(0, 2))

        # -- Metrics labels --
        metric_frame = ttk.Frame(cmp_frame)
        metric_frame.pack(fill=tk.X, padx=4, pady=(2, 0))

        self.lbl_cosine = ttk.Label(metric_frame, text="Cosine Sim: --",
                                    font=("Consolas", 10, "bold"))
        self.lbl_cosine.pack(side=tk.LEFT, padx=(0, 20))

        self.lbl_corr = ttk.Label(metric_frame, text="Correlation: --",
                                  font=("Consolas", 10, "bold"))
        self.lbl_corr.pack(side=tk.LEFT, padx=(0, 20))

        self.lbl_rmse = ttk.Label(metric_frame, text="RMSE: --",
                                  font=("Consolas", 10, "bold"))
        self.lbl_rmse.pack(side=tk.LEFT, padx=(0, 20))

        self.lbl_peak_bin = ttk.Label(metric_frame, text="Peak Bin: --",
                                      font=("Consolas", 10))
        self.lbl_peak_bin.pack(side=tk.LEFT, padx=(0, 20))

        self.lbl_cmp_status = ttk.Label(metric_frame, text="(no live data)",
                                        foreground="gray", font=("Consolas", 9))
        self.lbl_cmp_status.pack(side=tk.RIGHT)

        # -- Comparison figure: overlay + similarity history --
        self.fig_cmp = Figure(figsize=(14, 2.2), dpi=96)
        self.fig_cmp.set_facecolor("#2b2b2b")

        # Left subplot: normalized spectrum overlay
        self.ax_overlay = self.fig_cmp.add_subplot(1, 2, 1)
        self.ax_overlay.set_facecolor("#1e1e1e")
        self.ax_overlay.set_title("Spectrum Overlay (normalized to [0,1])",
                                  color="white", fontsize=8)
        self.ax_overlay.set_xlabel("Bin index", color="white", fontsize=7)
        self.ax_overlay.set_ylabel("Normalized mag", color="white", fontsize=7)
        self.ax_overlay.tick_params(colors="white", labelsize=6)
        self.ax_overlay.set_xlim(0, NUM_BINS - 1)
        self.ax_overlay.set_ylim(0, 1.05)

        self.line_live_norm, = self.ax_overlay.plot(
            [], [], color="#00d4aa", linewidth=1.5, label="Live", alpha=0.9)
        self.line_sim_norm, = self.ax_overlay.plot(
            [], [], color="#e09040", linewidth=1.5, label="Sim", alpha=0.9)
        self.fill_diff = None  # will be updated dynamically
        self.ax_overlay.legend(loc="upper right", fontsize=6,
                               facecolor="#2b2b2b", edgecolor="#555",
                               labelcolor="white")

        # Right subplot: similarity history over time
        self.ax_hist = self.fig_cmp.add_subplot(1, 2, 2)
        self.ax_hist.set_facecolor("#1e1e1e")
        self.ax_hist.set_title("Similarity over time", color="white", fontsize=8)
        self.ax_hist.set_xlabel("Update cycles ago", color="white", fontsize=7)
        self.ax_hist.set_ylabel("Score", color="white", fontsize=7)
        self.ax_hist.tick_params(colors="white", labelsize=6)
        self.ax_hist.set_xlim(0, SIMILARITY_HISTORY - 1)
        self.ax_hist.set_ylim(-0.1, 1.1)

        self.line_cos_hist, = self.ax_hist.plot(
            [], [], color="#44bbff", linewidth=1.2, label="Cosine")
        self.line_corr_hist, = self.ax_hist.plot(
            [], [], color="#ff66aa", linewidth=1.2, label="Pearson")
        self.ax_hist.legend(loc="lower right", fontsize=6,
                            facecolor="#2b2b2b", edgecolor="#555",
                            labelcolor="white")
        self.ax_hist.axhline(y=0.9, color="#555555", linestyle="--", linewidth=0.5)
        self.ax_hist.axhline(y=0.5, color="#333333", linestyle="--", linewidth=0.5)

        self.fig_cmp.tight_layout(pad=1.5)

        self.canvas_cmp = FigureCanvasTkAgg(self.fig_cmp, master=cmp_frame)
        self.canvas_cmp.get_tk_widget().pack(fill=tk.X, padx=4, pady=4)

        # ========== BOTTOM: Event Log (full width) ==========
        log_frame = ttk.LabelFrame(self.root, text="Event Log")
        log_frame.pack(fill=tk.X, padx=6, pady=(0, 6))

        self.log_text = scrolledtext.ScrolledText(
            log_frame, height=5, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT,
            insertbackground="#cccccc", selectbackground="#404040",
            selectforeground="#cccccc",
        )
        self.log_text.pack(fill=tk.X, padx=4, pady=4)
        # Dark scrollbar
        self.log_text.vbar.configure(
            bg="#3a3a3a", troughcolor="#1e1e1e",
            activebackground="#555555", relief=tk.FLAT,
            highlightthickness=0, bd=0,
        )
        self.log_text.tag_configure("error", foreground="#ff5555")
        self.log_text.tag_configure("info", foreground="#88cc88")

    # ------------------------------------------------------------------
    # Simulator controls
    # ------------------------------------------------------------------
    def _on_sim_param_change(self, *_args):
        self.sim.waveform = self.wave_var.get()
        self.sim.enabled = self.sim_enable_var.get()

    def _on_freq_slider(self, val):
        freq = float(val)
        self.sim.frequency = freq
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")

    def _on_freq_entry(self, _event=None):
        try:
            freq = float(self.freq_entry.get())
            freq = max(20.0, min(22000.0, freq))
        except ValueError:
            return
        self.sim.frequency = freq
        self.freq_var.set(freq)

    def _on_amp_slider(self, val):
        amp = float(val)
        self.sim.amplitude = amp
        self.amp_entry.delete(0, tk.END)
        self.amp_entry.insert(0, f"{amp:.2f}")

    def _on_amp_entry(self, _event=None):
        try:
            amp = float(self.amp_entry.get())
            amp = max(0.0, min(1.0, amp))
        except ValueError:
            return
        self.sim.amplitude = amp
        self.amp_var.set(amp)

    def _apply_preset(self, freq):
        self.sim.frequency = freq
        self.freq_var.set(freq)
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")

    # ------------------------------------------------------------------
    # Connection management
    # ------------------------------------------------------------------
    def _refresh_ports(self):
        """Rescan serial ports and update the dropdown."""
        ports = serial.tools.list_ports.comports()
        port_list = [f"{p.device} - {p.description}" for p in sorted(ports, key=lambda x: x.device)]
        devices = [p.device for p in sorted(ports, key=lambda x: x.device)]
        self.port_combo["values"] = port_list
        self._port_devices = devices
        if port_list and not self.port_var.get():
            self.port_combo.current(0)

    def _get_selected_port(self) -> str | None:
        idx = self.port_combo.current()
        if idx < 0 or idx >= len(self._port_devices):
            return None
        return self._port_devices[idx]

    def _toggle_connection(self):
        if self.connected:
            self._disconnect()
        else:
            self._connect()

    def _connect(self):
        port = self._get_selected_port()
        if not port:
            self._append_log("ERROR: No port selected")
            return

        try:
            baud = int(self.baud_var.get())
        except ValueError:
            self._append_log("ERROR: Invalid baud rate")
            return

        self.reader = UARTReader(port, baud)
        try:
            self.reader.open()
        except serial.SerialException as e:
            self._append_log(f"ERROR: Cannot open {port}: {e}")
            self.reader = None
            return

        self.reader.start()
        self.connected = True
        self.btn_connect.config(text="Disconnect")
        self.lbl_conn_status.config(text=f"Connected to {port}", foreground="green")
        self.port_combo.config(state="disabled")
        self.baud_entry.config(state="disabled")
        self.btn_refresh.config(state="disabled")
        self._append_log(f"Connected to {port} @ {baud} baud")

    def _disconnect(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
            # Drain remaining log entries from reader before detaching
            self._drain_reader_log()
            self.reader = None

        self.connected = False
        self.btn_connect.config(text="Connect")
        self.lbl_conn_status.config(text="Disconnected", foreground="gray")
        self.port_combo.config(state="readonly")
        self.baud_entry.config(state="normal")
        self.btn_refresh.config(state="normal")
        self._append_log("Disconnected")

    # ------------------------------------------------------------------
    # Update loop
    # ------------------------------------------------------------------
    def _schedule_update(self):
        self._update()
        self.root.after(self.REFRESH_MS, self._schedule_update)

    def _update(self):
        live_has_data = False

        # ---- Live UART panel ----
        r = self.reader
        if r is not None and self.connected:
            with r.lock:
                spectrum = r.spectrum.copy()
                waterfall = r.waterfall.copy()
                rms = r.rms
                seq = r.seq
                result = r.result
                rms_frames = r.rms_frames
                spec_frames = r.spec_frames
                spec_sweeps = r.spec_sweeps
                total_errors = r.checksum_errors + r.sync_errors + r.bin_range_errors

            self.lbl_rms.config(text=f"RMS: {rms}")
            self.lbl_seq.config(text=f"Seq: {seq}")
            result_text = "NORMAL" if result == 0 else "ABNORMAL"
            self.lbl_result.config(
                text=f"Result: {result_text}",
                foreground="green" if result == 0 else "red",
            )
            self.lbl_stats.config(
                text=f"Sweeps: {spec_sweeps} | Err: {total_errors}",
            )

            peak = max(spectrum.max(), 1)
            for bar, val in zip(self.bars_live, spectrum):
                bar.set_height(val)
            self.ax_bar_live.set_ylim(0, max(peak * 1.2, 100))

            wf_peak = max(waterfall.max(), 1)
            self.wf_img_live.set_data(waterfall)
            self.wf_img_live.set_clim(0, max(wf_peak * 0.8, 100))

            self.canvas_live.draw_idle()
            self._drain_reader_log()

            self._last_live_spectrum = spectrum.astype(np.float64)
            live_has_data = spectrum.max() > 0

        # ---- Simulator panel ----
        self.sim.step()
        sim_spec = self.sim.spectrum
        sim_wf = self.sim.waterfall

        sim_peak = max(sim_spec.max(), 1)
        for bar, val in zip(self.bars_sim, sim_spec):
            bar.set_height(val)
        self.ax_bar_sim.set_ylim(0, max(sim_peak * 1.2, 100))

        sim_wf_peak = max(sim_wf.max(), 1)
        self.wf_img_sim.set_data(sim_wf)
        self.wf_img_sim.set_clim(0, max(sim_wf_peak * 0.8, 100))

        self.canvas_sim.draw_idle()

        # ---- Comparison panel ----
        self._update_comparison(live_has_data, sim_spec)

    # ------------------------------------------------------------------
    def _update_comparison(self, live_has_data, sim_spec):
        """Compute and display comparison between live and simulator spectra."""
        live_norm = _normalize(self._last_live_spectrum)
        sim_norm = _normalize(sim_spec)

        x = np.arange(NUM_BINS)

        # Update overlay lines
        self.line_live_norm.set_data(x, live_norm)
        self.line_sim_norm.set_data(x, sim_norm)

        # Update shaded difference region
        if self.fill_diff is not None:
            self.fill_diff.remove()
        self.fill_diff = self.ax_overlay.fill_between(
            x, live_norm, sim_norm,
            alpha=0.2, color="#ff4444", label="_diff",
        )

        # Compute metrics
        cos_val = cosine_similarity(live_norm, sim_norm)
        corr_val = pearson_correlation(live_norm, sim_norm)
        rmse_val = normalized_rmse(live_norm, sim_norm)

        # Color-code cosine similarity: green >= 0.8, yellow >= 0.5, red < 0.5
        if cos_val >= 0.8:
            cos_color = "#00cc66"
        elif cos_val >= 0.5:
            cos_color = "#ccaa00"
        else:
            cos_color = "#cc3333"

        self.lbl_cosine.config(text=f"Cosine Sim: {cos_val:.4f}", foreground=cos_color)
        self.lbl_corr.config(text=f"Correlation: {corr_val:.4f}")
        self.lbl_rmse.config(text=f"RMSE: {rmse_val:.4f}")

        # Peak bin info
        live_peak_bin = int(np.argmax(self._last_live_spectrum))
        sim_peak_bin = int(np.argmax(sim_spec))
        live_peak_freq = FREQ_AXIS[live_peak_bin]
        sim_peak_freq = FREQ_AXIS[sim_peak_bin]
        self.lbl_peak_bin.config(
            text=f"Peak: Live bin {live_peak_bin} ({live_peak_freq:.0f} Hz) | "
                 f"Sim bin {sim_peak_bin} ({sim_peak_freq:.0f} Hz)"
        )

        if live_has_data:
            self.lbl_cmp_status.config(text="comparing", foreground="green")
        else:
            self.lbl_cmp_status.config(text="(no live data)", foreground="gray")

        # Push to history
        self._cosine_history.append(cos_val)
        self._corr_history.append(corr_val)

        hist_x = np.arange(SIMILARITY_HISTORY)
        self.line_cos_hist.set_data(hist_x, list(self._cosine_history))
        self.line_corr_hist.set_data(hist_x, list(self._corr_history))

        self.canvas_cmp.draw_idle()

    # ------------------------------------------------------------------
    def _drain_reader_log(self):
        """Move pending log entries from the reader to the GUI log widget."""
        if self.reader is None:
            return
        new_lines = []
        while self.reader.log:
            try:
                new_lines.append(self.reader.log.popleft())
            except IndexError:
                break
        for line in new_lines:
            self._append_log(line, from_reader=True)

    def _append_log(self, msg: str, from_reader: bool = False):
        """Add a line to the GUI event log."""
        if not from_reader:
            ts = time.strftime("%H:%M:%S")
            msg = f"[{ts}] {msg}"
        tag = "error" if "ERROR" in msg else "info"
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, msg + "\n", tag)
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)

    # ------------------------------------------------------------------
    def _on_close(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
        self.root.destroy()

    def run(self):
        self.root.mainloop()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    app = SpectrogramApp()
    app.run()


if __name__ == "__main__":
    main()
"""
FPGA Spectrogram Viewer + Waveform Simulator
==============================================
Left panel:  Live UART spectrogram from CMOD A7 FPGA.
Right panel: Software waveform simulator with identical FFT pipeline.

Both panels show a current-spectrum bar chart (log₂ frequency scale)
and a scrolling waterfall spectrogram on the same 0–23.4 kHz axis.

Protocol (from recorder_top.v):
  RMS frame (8 bytes):  AA 55 result rms flags seq metric checksum
  Spec slice (6 bytes): DD 77 bin_idx bin_lo bin_hi checksum

Usage:
  python spectrogram_viewer.py
  Select port and baud rate from the GUI, then click Connect.
"""

import threading
import time
from collections import deque

import serial
import serial.tools.list_ports

import tkinter as tk
from tkinter import ttk, scrolledtext

import numpy as np

# Try to import matplotlib for the embedded plot
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
BAUD_RATE = 1_000_000
NUM_BINS = 64
WATERFALL_ROWS = 128           # number of time-rows kept in waterfall
SPEC_SYNC = (0xDD, 0x77)
RMS_SYNC  = (0xAA, 0x55)

# Frequency axis: 64 bins spanning 0 to ~23.4 kHz (46.875 kHz / 2)
# Only first 256 of 512 FFT bins used (real FFT), downsampled by 4 -> 64 bins
SAMPLE_RATE = 46875.0
NYQUIST = SAMPLE_RATE / 2.0
FFT_N = 512
BIN_SPACING = SAMPLE_RATE / FFT_N      # ~91.6 Hz per raw FFT bin
# Output bin k maps to FFT bin k*4, so center freq = k * 4 * BIN_SPACING
FREQ_AXIS = np.array([k * 4 * BIN_SPACING for k in range(NUM_BINS)])  # Hz

MAX_LOG_LINES = 500


# ---------------------------------------------------------------------------
# Serial reader thread
# ---------------------------------------------------------------------------
class UARTReader:
    """Parses FPGA UART frames in a background thread."""

    def __init__(self, port: str, baud: int = BAUD_RATE):
        self.port = port
        self.baud = baud
        self.ser = None
        self._stop = threading.Event()

        # Latest state (written by reader, read by GUI)
        self.lock = threading.Lock()
        self.spectrum = np.zeros(NUM_BINS, dtype=np.uint16)
        self.waterfall = np.zeros((WATERFALL_ROWS, NUM_BINS), dtype=np.float64)
        self.rms = 0
        self.result = 0
        self.flags = 0
        self.seq = 0
        self.metric = 0

        # Counters
        self.rms_frames = 0
        self.spec_frames = 0
        self.spec_sweeps = 0
        self.checksum_errors = 0
        self.sync_errors = 0
        self.bin_range_errors = 0

        # Error/event log (deque, thread-safe for append)
        self.log = deque(maxlen=MAX_LOG_LINES)

        # Track whether a full 64-bin sweep has been received
        self._bins_received = set()

    # ------------------------------------------------------------------
    def open(self):
        self.ser = serial.Serial(
            port=self.port,
            baudrate=self.baud,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=0.1,
        )
        self._log(f"Opened {self.port} @ {self.baud} baud")

    def close(self):
        self._stop.set()
        if self.ser and self.ser.is_open:
            self.ser.close()
            self._log("Serial port closed")

    def start(self):
        self._stop.clear()
        t = threading.Thread(target=self._run, daemon=True)
        t.start()

    def stop(self):
        self._stop.set()

    # ------------------------------------------------------------------
    def _log(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.log.append(f"[{ts}] {msg}")

    # ------------------------------------------------------------------
    def _run(self):
        """Main read loop \u2014 byte-level state machine."""
        buf = bytearray()

        while not self._stop.is_set():
            try:
                chunk = self.ser.read(256)
            except serial.SerialException as e:
                self._log(f"ERROR: Serial read failed: {e}")
                break
            if not chunk:
                continue
            buf.extend(chunk)

            # Process all complete frames in buffer
            while len(buf) >= 2:
                # Look for a sync pair
                if buf[0] == 0xAA and buf[1] == 0x55:
                    if len(buf) < 8:
                        break  # wait for full frame
                    self._parse_rms(buf[:8])
                    del buf[:8]

                elif buf[0] == 0xDD and buf[1] == 0x77:
                    if len(buf) < 6:
                        break  # wait for full frame
                    self._parse_spec(buf[:6])
                    del buf[:6]

                else:
                    # Not a sync byte \u2014 discard and report
                    bad = buf[0]
                    del buf[:1]
                    with self.lock:
                        self.sync_errors += 1
                    self._log(f"SYNC_ERROR: unexpected byte 0x{bad:02X}, discarded")

        self._log("Reader thread exiting")

    # ------------------------------------------------------------------
    def _parse_rms(self, frame: bytearray):
        # frame: AA 55 result rms flags seq metric chk
        result, rms, flags, seq, metric, chk = frame[2], frame[3], frame[4], frame[5], frame[6], frame[7]
        expected = 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric

        with self.lock:
            self.rms_frames += 1
            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"RMS_CHECKSUM_ERROR: seq={seq} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[result={result} rms={rms} flags=0x{flags:02X} metric={metric}]"
                )
                return
            self.rms = rms
            self.result = result
            self.flags = flags
            self.seq = seq
            self.metric = metric

    # ------------------------------------------------------------------
    def _parse_spec(self, frame: bytearray):
        # frame: DD 77 bin_idx bin_lo bin_hi chk
        bin_idx, bin_lo, bin_hi, chk = frame[2], frame[3], frame[4], frame[5]
        expected = 0xDD ^ 0x77 ^ bin_idx ^ bin_lo ^ bin_hi

        with self.lock:
            self.spec_frames += 1

            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"SPEC_CHECKSUM_ERROR: bin={bin_idx} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[lo=0x{bin_lo:02X} hi=0x{bin_hi:02X}]"
                )
                return

            if bin_idx > 63:
                self.bin_range_errors += 1
                self._log(f"BIN_RANGE_ERROR: bin_idx={bin_idx} out of 0-63")
                return

            mag = bin_lo | (bin_hi << 8)
            self.spectrum[bin_idx] = mag

            self._bins_received.add(bin_idx)
            if len(self._bins_received) == NUM_BINS:
                # Full sweep completed \u2014 push to waterfall
                self._bins_received.clear()
                self.spec_sweeps += 1
                # Shift waterfall down, add new row at top
                self.waterfall = np.roll(self.waterfall, 1, axis=0)
                self.waterfall[0, :] = self.spectrum.astype(np.float64)


# ---------------------------------------------------------------------------
# Waveform simulator
# ---------------------------------------------------------------------------
NOTE_PRESETS = [
    ("A4  440",   440.0),
    ("C4  262",   261.63),
    ("E4  330",   329.63),
    ("G4  392",   392.00),
    ("A5  880",   880.0),
    ("C5  523",   523.25),
    ("1 kHz",     1000.0),
    ("5 kHz",     5000.0),
    ("10 kHz",    10000.0),
    ("15 kHz",    15000.0),
    ("20 kHz",    20000.0),
]

WAVEFORM_TYPES = ("sine", "square", "sawtooth", "triangle")


class WaveformSimulator:
    """Generate test waveforms and compute 64-bin spectrum matching the FPGA pipeline.

    Pipeline: time-domain samples at 46 875 Hz -> Hann window (512 pts)
              -> 512-pt FFT -> magnitude of first 256 bins
              -> every-4th downsample -> 64 output bins (0-23.4 kHz).
    """

    def __init__(self):
        self.enabled = True
        self.waveform = "sine"
        self.frequency = 1000.0   # Hz
        self.amplitude = 0.8      # 0 .. 1
        self.spectrum = np.zeros(NUM_BINS, dtype=np.float64)
        self.waterfall = np.zeros((WATERFALL_ROWS, NUM_BINS), dtype=np.float64)
        self._phase_offset = 0.0
        self._hann = np.hanning(FFT_N)

    def step(self):
        """Compute one 512-sample FFT frame and push to waterfall."""
        if not self.enabled:
            self.spectrum[:] = 0.0
            self.waterfall = np.roll(self.waterfall, 1, axis=0)
            self.waterfall[0, :] = 0.0
            return

        t = (np.arange(FFT_N) + self._phase_offset) / SAMPLE_RATE
        self._phase_offset += FFT_N

        f = self.frequency
        wtype = self.waveform

        if wtype == "sine":
            sig = np.sin(2.0 * np.pi * f * t)
        elif wtype == "square":
            sig = np.sign(np.sin(2.0 * np.pi * f * t))
        elif wtype == "sawtooth":
            sig = 2.0 * ((f * t) % 1.0) - 1.0
        elif wtype == "triangle":
            sig = 2.0 * np.abs(2.0 * ((f * t) % 1.0) - 1.0) - 1.0
        else:
            sig = np.zeros(FFT_N)

        # Scale to 16-bit range (matching FPGA I2S path: raw_s16 = sample[23:8])
        sig *= self.amplitude * 32767.0

        # Hann window -> FFT -> magnitude of first 256 bins -> every-4th downsample
        fft_mag = np.abs(np.fft.fft(sig * self._hann))
        self.spectrum = fft_mag[::4][:NUM_BINS]

        self.waterfall = np.roll(self.waterfall, 1, axis=0)
        self.waterfall[0, :] = self.spectrum


# ---------------------------------------------------------------------------
# GUI Application
# ---------------------------------------------------------------------------
class SpectrogramApp:
    REFRESH_MS = 100  # GUI update interval

    def __init__(self):
        self.reader = None
        self.connected = False
        self.sim = WaveformSimulator()

        self.root = tk.Tk()
        self.root.title("FPGA Spectrogram Viewer + Simulator")
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)
        self.root.minsize(1600, 800)

        self._build_ui()
        self._schedule_update()

    # ------------------------------------------------------------------
    @staticmethod
    def _make_spectrum_axes(fig, bar_color, edge_color, title_prefix):
        """Create matched bar-chart + waterfall subplots on *fig*.

        Returns (bar_freqs, bars, ax_bar, ax_wf, wf_img).
        """
        fig.set_facecolor("#2b2b2b")

        ax_bar = fig.add_subplot(2, 1, 1)
        ax_bar.set_facecolor("#1e1e1e")
        ax_bar.set_title(
            f"{title_prefix} \u2014 Spectrum (0\u201323.4 kHz)",
            color="white", fontsize=9,
        )
        ax_bar.set_xlabel("Frequency (Hz) \u2014 log\u2082 scale", color="white", fontsize=7)
        ax_bar.set_ylabel("Magnitude", color="white", fontsize=7)
        ax_bar.set_xscale("log", base=2)
        ax_bar.tick_params(colors="white", labelsize=6)

        bar_freqs = FREQ_AXIS.copy()
        bar_freqs[0] = max(bar_freqs[0], bar_freqs[1] / 2)
        bar_widths = np.diff(np.append(bar_freqs, NYQUIST)) * 0.8
        bars = ax_bar.bar(
            bar_freqs, np.zeros(NUM_BINS), width=bar_widths,
            color=bar_color, edgecolor=edge_color, align="edge",
        )
        ax_bar.set_xlim(bar_freqs[0] * 0.8, NYQUIST * 1.05)
        ax_bar.set_ylim(0, 1000)

        ax_wf = fig.add_subplot(2, 1, 2)
        ax_wf.set_facecolor("#1e1e1e")
        ax_wf.set_title(f"{title_prefix} \u2014 Waterfall", color="white", fontsize=9)
        ax_wf.set_xlabel("Frequency (kHz)", color="white", fontsize=7)
        ax_wf.set_ylabel("Time (sweeps ago)", color="white", fontsize=7)
        ax_wf.tick_params(colors="white", labelsize=6)

        tick_pos = [0, 8, 16, 24, 32, 40, 48, 56, 63]
        tick_lbl = [f"{FREQ_AXIS[i]/1000:.1f}" for i in tick_pos]
        ax_wf.set_xticks(tick_pos)
        ax_wf.set_xticklabels(tick_lbl)

        wf_img = ax_wf.imshow(
            np.zeros((WATERFALL_ROWS, NUM_BINS)),
            aspect="auto", origin="upper", cmap="inferno",
            interpolation="nearest", vmin=0, vmax=1000,
        )
        fig.colorbar(wf_img, ax=ax_wf, label="Magnitude", pad=0.02)
        fig.tight_layout(pad=1.5)

        return bar_freqs, bars, ax_bar, ax_wf, wf_img

    # ------------------------------------------------------------------
    def _build_ui(self):
        # ---- Connection toolbar (full width) ----
        conn_frame = ttk.LabelFrame(self.root, text="Connection")
        conn_frame.pack(fill=tk.X, padx=6, pady=(6, 0))

        ttk.Label(conn_frame, text="Port:").pack(side=tk.LEFT, padx=(6, 2))
        self.port_var = tk.StringVar()
        self.port_combo = ttk.Combobox(
            conn_frame, textvariable=self.port_var, width=40, state="readonly"
        )
        self.port_combo.pack(side=tk.LEFT, padx=(0, 4))
        self._refresh_ports()

        self.btn_refresh = ttk.Button(conn_frame, text="\u21bb", width=3, command=self._refresh_ports)
        self.btn_refresh.pack(side=tk.LEFT, padx=(0, 10))

        ttk.Label(conn_frame, text="Baud:").pack(side=tk.LEFT, padx=(0, 2))
        self.baud_var = tk.StringVar(value="1000000")
        self.baud_entry = ttk.Entry(conn_frame, textvariable=self.baud_var, width=10)
        self.baud_entry.pack(side=tk.LEFT, padx=(0, 10))

        self.btn_connect = ttk.Button(conn_frame, text="Connect", command=self._toggle_connection)
        self.btn_connect.pack(side=tk.LEFT, padx=(0, 10))

        self.lbl_conn_status = ttk.Label(conn_frame, text="Disconnected", foreground="gray")
        self.lbl_conn_status.pack(side=tk.LEFT, padx=(0, 6))

        conn_frame.pack_configure(pady=(6, 2))

        # ---- Main split: Live (left) | Simulator (right) ----
        main_pw = ttk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        main_pw.pack(fill=tk.BOTH, expand=True, padx=6, pady=4)

        # ========== LEFT PANEL: Live UART viewer ==========
        left_frame = ttk.LabelFrame(main_pw, text="Live UART")
        main_pw.add(left_frame, weight=1)

        # Status bar
        status_frame = ttk.Frame(left_frame)
        status_frame.pack(fill=tk.X, padx=4, pady=(2, 0))

        self.lbl_rms = ttk.Label(status_frame, text="RMS: --")
        self.lbl_rms.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_seq = ttk.Label(status_frame, text="Seq: --")
        self.lbl_seq.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_result = ttk.Label(status_frame, text="Result: --")
        self.lbl_result.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_stats = ttk.Label(status_frame, text="Sweeps: 0 | Err: 0")
        self.lbl_stats.pack(side=tk.RIGHT)

        # Live matplotlib figure
        self.fig_live = Figure(figsize=(6, 4.5), dpi=96)
        objs = self._make_spectrum_axes(self.fig_live, "#00d4aa", "#006655", "Live")
        self.bar_freqs, self.bars_live, self.ax_bar_live, self.ax_wf_live, self.wf_img_live = objs

        self.canvas_live = FigureCanvasTkAgg(self.fig_live, master=left_frame)
        self.canvas_live.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)

        # ========== RIGHT PANEL: Waveform Simulator ==========
        right_frame = ttk.LabelFrame(main_pw, text="Waveform Simulator")
        main_pw.add(right_frame, weight=1)

        # -- Row 1: waveform type + enable --
        ctrl1 = ttk.Frame(right_frame)
        ctrl1.pack(fill=tk.X, padx=4, pady=(4, 0))

        ttk.Label(ctrl1, text="Wave:").pack(side=tk.LEFT, padx=(0, 2))
        self.wave_var = tk.StringVar(value="sine")
        wave_cb = ttk.Combobox(
            ctrl1, textvariable=self.wave_var,
            values=list(WAVEFORM_TYPES), state="readonly", width=10,
        )
        wave_cb.pack(side=tk.LEFT, padx=(0, 10))
        wave_cb.bind("<<ComboboxSelected>>", self._on_sim_param_change)

        self.sim_enable_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(
            ctrl1, text="Enable", variable=self.sim_enable_var,
            command=self._on_sim_param_change,
        ).pack(side=tk.LEFT, padx=(0, 10))

        # -- Row 2: frequency --
        ctrl2 = ttk.Frame(right_frame)
        ctrl2.pack(fill=tk.X, padx=4, pady=(2, 0))

        ttk.Label(ctrl2, text="Freq:").pack(side=tk.LEFT, padx=(0, 2))
        self.freq_var = tk.DoubleVar(value=1000.0)
        self.freq_scale = ttk.Scale(
            ctrl2, from_=20, to=22000, orient=tk.HORIZONTAL,
            variable=self.freq_var, command=self._on_freq_slider,
        )
        self.freq_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 4))
        self.freq_entry = ttk.Entry(ctrl2, width=7)
        self.freq_entry.insert(0, "1000")
        self.freq_entry.pack(side=tk.LEFT, padx=(0, 2))
        self.freq_entry.bind("<Return>", self._on_freq_entry)
        ttk.Label(ctrl2, text="Hz").pack(side=tk.LEFT)

        # -- Row 3: amplitude --
        ctrl3 = ttk.Frame(right_frame)
        ctrl3.pack(fill=tk.X, padx=4, pady=(2, 0))

        ttk.Label(ctrl3, text="Amp:").pack(side=tk.LEFT, padx=(0, 2))
        self.amp_var = tk.DoubleVar(value=0.8)
        self.amp_scale = ttk.Scale(
            ctrl3, from_=0.0, to=1.0, orient=tk.HORIZONTAL,
            variable=self.amp_var, command=self._on_amp_slider,
        )
        self.amp_scale.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 4))
        self.amp_entry = ttk.Entry(ctrl3, width=5)
        self.amp_entry.insert(0, "0.80")
        self.amp_entry.pack(side=tk.LEFT)
        self.amp_entry.bind("<Return>", self._on_amp_entry)

        # -- Row 4: note / frequency presets --
        preset_frame = ttk.LabelFrame(right_frame, text="Presets")
        preset_frame.pack(fill=tk.X, padx=4, pady=(4, 0))

        for i, (label, freq) in enumerate(NOTE_PRESETS):
            btn = ttk.Button(
                preset_frame, text=label, width=9,
                command=lambda f=freq: self._apply_preset(f),
            )
            btn.grid(row=i // 6, column=i % 6, padx=2, pady=2, sticky="ew")
        for col in range(6):
            preset_frame.columnconfigure(col, weight=1)

        # Simulator matplotlib figure (same axes as live)
        self.fig_sim = Figure(figsize=(6, 4.5), dpi=96)
        sim_objs = self._make_spectrum_axes(self.fig_sim, "#e09040", "#805020", "Simulator")
        _, self.bars_sim, self.ax_bar_sim, self.ax_wf_sim, self.wf_img_sim = sim_objs

        self.canvas_sim = FigureCanvasTkAgg(self.fig_sim, master=right_frame)
        self.canvas_sim.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)

        # ========== BOTTOM: Event Log (full width) ==========
        log_frame = ttk.LabelFrame(self.root, text="Event Log")
        log_frame.pack(fill=tk.X, padx=6, pady=(0, 6))

        self.log_text = scrolledtext.ScrolledText(
            log_frame, height=6, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT,
        )
        self.log_text.pack(fill=tk.X, padx=4, pady=4)
        self.log_text.tag_configure("error", foreground="#ff5555")
        self.log_text.tag_configure("info", foreground="#88cc88")

    # ------------------------------------------------------------------
    # Simulator controls
    # ------------------------------------------------------------------
    def _on_sim_param_change(self, *_args):
        self.sim.waveform = self.wave_var.get()
        self.sim.enabled = self.sim_enable_var.get()

    def _on_freq_slider(self, val):
        freq = float(val)
        self.sim.frequency = freq
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")

    def _on_freq_entry(self, _event=None):
        try:
            freq = float(self.freq_entry.get())
            freq = max(20.0, min(22000.0, freq))
        except ValueError:
            return
        self.sim.frequency = freq
        self.freq_var.set(freq)

    def _on_amp_slider(self, val):
        amp = float(val)
        self.sim.amplitude = amp
        self.amp_entry.delete(0, tk.END)
        self.amp_entry.insert(0, f"{amp:.2f}")

    def _on_amp_entry(self, _event=None):
        try:
            amp = float(self.amp_entry.get())
            amp = max(0.0, min(1.0, amp))
        except ValueError:
            return
        self.sim.amplitude = amp
        self.amp_var.set(amp)

    def _apply_preset(self, freq):
        self.sim.frequency = freq
        self.freq_var.set(freq)
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")

    # ------------------------------------------------------------------
    # Connection management
    # ------------------------------------------------------------------
    def _refresh_ports(self):
        """Rescan serial ports and update the dropdown."""
        ports = serial.tools.list_ports.comports()
        port_list = [f"{p.device} - {p.description}" for p in sorted(ports, key=lambda x: x.device)]
        devices = [p.device for p in sorted(ports, key=lambda x: x.device)]
        self.port_combo["values"] = port_list
        self._port_devices = devices
        if port_list and not self.port_var.get():
            self.port_combo.current(0)

    def _get_selected_port(self) -> str | None:
        idx = self.port_combo.current()
        if idx < 0 or idx >= len(self._port_devices):
            return None
        return self._port_devices[idx]

    def _toggle_connection(self):
        if self.connected:
            self._disconnect()
        else:
            self._connect()

    def _connect(self):
        port = self._get_selected_port()
        if not port:
            self._append_log("ERROR: No port selected")
            return

        try:
            baud = int(self.baud_var.get())
        except ValueError:
            self._append_log("ERROR: Invalid baud rate")
            return

        self.reader = UARTReader(port, baud)
        try:
            self.reader.open()
        except serial.SerialException as e:
            self._append_log(f"ERROR: Cannot open {port}: {e}")
            self.reader = None
            return

        self.reader.start()
        self.connected = True
        self.btn_connect.config(text="Disconnect")
        self.lbl_conn_status.config(text=f"Connected to {port}", foreground="green")
        self.port_combo.config(state="disabled")
        self.baud_entry.config(state="disabled")
        self.btn_refresh.config(state="disabled")
        self._append_log(f"Connected to {port} @ {baud} baud")

    def _disconnect(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
            # Drain remaining log entries from reader before detaching
            self._drain_reader_log()
            self.reader = None

        self.connected = False
        self.btn_connect.config(text="Connect")
        self.lbl_conn_status.config(text="Disconnected", foreground="gray")
        self.port_combo.config(state="readonly")
        self.baud_entry.config(state="normal")
        self.btn_refresh.config(state="normal")
        self._append_log("Disconnected")

    # ------------------------------------------------------------------
    # Update loop
    # ------------------------------------------------------------------
    def _schedule_update(self):
        self._update()
        self.root.after(self.REFRESH_MS, self._schedule_update)

    def _update(self):
        # ---- Live UART panel ----
        r = self.reader
        if r is not None and self.connected:
            with r.lock:
                spectrum = r.spectrum.copy()
                waterfall = r.waterfall.copy()
                rms = r.rms
                seq = r.seq
                result = r.result
                rms_frames = r.rms_frames
                spec_frames = r.spec_frames
                spec_sweeps = r.spec_sweeps
                total_errors = r.checksum_errors + r.sync_errors + r.bin_range_errors

            self.lbl_rms.config(text=f"RMS: {rms}")
            self.lbl_seq.config(text=f"Seq: {seq}")
            result_text = "NORMAL" if result == 0 else "ABNORMAL"
            self.lbl_result.config(
                text=f"Result: {result_text}",
                foreground="green" if result == 0 else "red",
            )
            self.lbl_stats.config(
                text=f"Sweeps: {spec_sweeps} | Err: {total_errors}",
            )

            peak = max(spectrum.max(), 1)
            for bar, val in zip(self.bars_live, spectrum):
                bar.set_height(val)
            self.ax_bar_live.set_ylim(0, max(peak * 1.2, 100))

            wf_peak = max(waterfall.max(), 1)
            self.wf_img_live.set_data(waterfall)
            self.wf_img_live.set_clim(0, max(wf_peak * 0.8, 100))

            self.canvas_live.draw_idle()
            self._drain_reader_log()

        # ---- Simulator panel ----
        self.sim.step()
        sim_spec = self.sim.spectrum
        sim_wf = self.sim.waterfall

        sim_peak = max(sim_spec.max(), 1)
        for bar, val in zip(self.bars_sim, sim_spec):
            bar.set_height(val)
        self.ax_bar_sim.set_ylim(0, max(sim_peak * 1.2, 100))

        sim_wf_peak = max(sim_wf.max(), 1)
        self.wf_img_sim.set_data(sim_wf)
        self.wf_img_sim.set_clim(0, max(sim_wf_peak * 0.8, 100))

        self.canvas_sim.draw_idle()

    def _drain_reader_log(self):
        """Move pending log entries from the reader to the GUI log widget."""
        if self.reader is None:
            return
        new_lines = []
        while self.reader.log:
            try:
                new_lines.append(self.reader.log.popleft())
            except IndexError:
                break
        for line in new_lines:
            self._append_log(line, from_reader=True)

    def _append_log(self, msg: str, from_reader: bool = False):
        """Add a line to the GUI event log."""
        if not from_reader:
            ts = time.strftime("%H:%M:%S")
            msg = f"[{ts}] {msg}"
        tag = "error" if "ERROR" in msg else "info"
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, msg + "\n", tag)
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)

    # ------------------------------------------------------------------
    def _on_close(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
        self.root.destroy()

    def run(self):
        self.root.mainloop()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    app = SpectrogramApp()
    app.run()


if __name__ == "__main__":
    main()
"""
FPGA Spectrogram Viewer — Real-time UART spectrogram display
=============================================================
Connects to the CMOD A7 FPGA over USB-UART and displays the 64-bin
spectrogram in real time. Also shows RMS telemetry and a scrolling error log.

Protocol (from recorder_top.v):
  RMS frame (8 bytes):  AA 55 result rms flags seq metric checksum
  Spec slice (6 bytes): DD 77 bin_idx bin_lo bin_hi checksum

Usage:
  python spectrogram_viewer.py
  Select port and baud rate from the GUI, then click Connect.
"""

import threading
import time
from collections import deque

import serial
import serial.tools.list_ports

import tkinter as tk
from tkinter import ttk, scrolledtext

import numpy as np

# Try to import matplotlib for the embedded plot
import matplotlib
matplotlib.use("TkAgg")
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
BAUD_RATE = 1_000_000
NUM_BINS = 64
WATERFALL_ROWS = 128           # number of time-rows kept in waterfall
SPEC_SYNC = (0xDD, 0x77)
RMS_SYNC  = (0xAA, 0x55)

# Frequency axis: 64 bins spanning 0 to ~23.4 kHz (46.875 kHz / 2)
# Only first 256 of 512 FFT bins used (real FFT), downsampled by 4 -> 64 bins
SAMPLE_RATE = 46875.0
NYQUIST = SAMPLE_RATE / 2.0
FFT_N = 512
BIN_SPACING = SAMPLE_RATE / FFT_N      # ~91.6 Hz per raw FFT bin
# Output bin k maps to FFT bin k*4, so center freq = k * 4 * BIN_SPACING
FREQ_AXIS = np.array([k * 4 * BIN_SPACING for k in range(NUM_BINS)])  # Hz

MAX_LOG_LINES = 500


# ---------------------------------------------------------------------------
# Serial reader thread
# ---------------------------------------------------------------------------
class UARTReader:
    """Parses FPGA UART frames in a background thread."""

    def __init__(self, port: str, baud: int = BAUD_RATE):
        self.port = port
        self.baud = baud
        self.ser = None
        self._stop = threading.Event()

        # Latest state (written by reader, read by GUI)
        self.lock = threading.Lock()
        self.spectrum = np.zeros(NUM_BINS, dtype=np.uint16)
        self.waterfall = np.zeros((WATERFALL_ROWS, NUM_BINS), dtype=np.float64)
        self.rms = 0
        self.result = 0
        self.flags = 0
        self.seq = 0
        self.metric = 0

        # Counters
        self.rms_frames = 0
        self.spec_frames = 0
        self.spec_sweeps = 0
        self.checksum_errors = 0
        self.sync_errors = 0
        self.bin_range_errors = 0

        # Error/event log (deque, thread-safe for append)
        self.log = deque(maxlen=MAX_LOG_LINES)

        # Track whether a full 64-bin sweep has been received
        self._bins_received = set()

    # ------------------------------------------------------------------
    def open(self):
        self.ser = serial.Serial(
            port=self.port,
            baudrate=self.baud,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=0.1,
        )
        self._log(f"Opened {self.port} @ {self.baud} baud")

    def close(self):
        self._stop.set()
        if self.ser and self.ser.is_open:
            self.ser.close()
            self._log("Serial port closed")

    def start(self):
        self._stop.clear()
        t = threading.Thread(target=self._run, daemon=True)
        t.start()

    def stop(self):
        self._stop.set()

    # ------------------------------------------------------------------
    def _log(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.log.append(f"[{ts}] {msg}")

    # ------------------------------------------------------------------
    def _run(self):
        """Main read loop — byte-level state machine."""
        buf = bytearray()

        while not self._stop.is_set():
            try:
                chunk = self.ser.read(256)
            except serial.SerialException as e:
                self._log(f"ERROR: Serial read failed: {e}")
                break
            if not chunk:
                continue
            buf.extend(chunk)

            # Process all complete frames in buffer
            while len(buf) >= 2:
                # Look for a sync pair
                if buf[0] == 0xAA and buf[1] == 0x55:
                    if len(buf) < 8:
                        break  # wait for full frame
                    self._parse_rms(buf[:8])
                    del buf[:8]

                elif buf[0] == 0xDD and buf[1] == 0x77:
                    if len(buf) < 6:
                        break  # wait for full frame
                    self._parse_spec(buf[:6])
                    del buf[:6]

                else:
                    # Not a sync byte — discard and report
                    bad = buf[0]
                    del buf[:1]
                    with self.lock:
                        self.sync_errors += 1
                    self._log(f"SYNC_ERROR: unexpected byte 0x{bad:02X}, discarded")

        self._log("Reader thread exiting")

    # ------------------------------------------------------------------
    def _parse_rms(self, frame: bytearray):
        # frame: AA 55 result rms flags seq metric chk
        result, rms, flags, seq, metric, chk = frame[2], frame[3], frame[4], frame[5], frame[6], frame[7]
        expected = 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric

        with self.lock:
            self.rms_frames += 1
            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"RMS_CHECKSUM_ERROR: seq={seq} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[result={result} rms={rms} flags=0x{flags:02X} metric={metric}]"
                )
                return
            self.rms = rms
            self.result = result
            self.flags = flags
            self.seq = seq
            self.metric = metric

    # ------------------------------------------------------------------
    def _parse_spec(self, frame: bytearray):
        # frame: DD 77 bin_idx bin_lo bin_hi chk
        bin_idx, bin_lo, bin_hi, chk = frame[2], frame[3], frame[4], frame[5]
        expected = 0xDD ^ 0x77 ^ bin_idx ^ bin_lo ^ bin_hi

        with self.lock:
            self.spec_frames += 1

            if chk != expected:
                self.checksum_errors += 1
                self._log(
                    f"SPEC_CHECKSUM_ERROR: bin={bin_idx} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[lo=0x{bin_lo:02X} hi=0x{bin_hi:02X}]"
                )
                return

            if bin_idx > 63:
                self.bin_range_errors += 1
                self._log(f"BIN_RANGE_ERROR: bin_idx={bin_idx} out of 0-63")
                return

            mag = bin_lo | (bin_hi << 8)
            self.spectrum[bin_idx] = mag

            self._bins_received.add(bin_idx)
            if len(self._bins_received) == NUM_BINS:
                # Full sweep completed — push to waterfall
                self._bins_received.clear()
                self.spec_sweeps += 1
                # Shift waterfall down, add new row at top
                self.waterfall = np.roll(self.waterfall, 1, axis=0)
                self.waterfall[0, :] = self.spectrum.astype(np.float64)


# ---------------------------------------------------------------------------
# GUI Application
# ---------------------------------------------------------------------------
class SpectrogramApp:
    REFRESH_MS = 100  # GUI update interval

    def __init__(self):
        self.reader = None
        self.connected = False
        self.root = tk.Tk()
        self.root.title("FPGA Spectrogram Viewer")
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)
        self.root.minsize(1000, 700)

        self._build_ui()
        self._schedule_update()

    # ------------------------------------------------------------------
    def _build_ui(self):
        # ---- Connection toolbar ----
        conn_frame = ttk.LabelFrame(self.root, text="Connection")
        conn_frame.pack(fill=tk.X, padx=6, pady=(6, 0))

        ttk.Label(conn_frame, text="Port:").pack(side=tk.LEFT, padx=(6, 2))
        self.port_var = tk.StringVar()
        self.port_combo = ttk.Combobox(
            conn_frame, textvariable=self.port_var, width=40, state="readonly"
        )
        self.port_combo.pack(side=tk.LEFT, padx=(0, 4))
        self._refresh_ports()

        self.btn_refresh = ttk.Button(conn_frame, text="\u21bb", width=3, command=self._refresh_ports)
        self.btn_refresh.pack(side=tk.LEFT, padx=(0, 10))

        ttk.Label(conn_frame, text="Baud:").pack(side=tk.LEFT, padx=(0, 2))
        self.baud_var = tk.StringVar(value="1000000")
        self.baud_entry = ttk.Entry(conn_frame, textvariable=self.baud_var, width=10)
        self.baud_entry.pack(side=tk.LEFT, padx=(0, 10))

        self.btn_connect = ttk.Button(conn_frame, text="Connect", command=self._toggle_connection)
        self.btn_connect.pack(side=tk.LEFT, padx=(0, 10))

        self.lbl_conn_status = ttk.Label(conn_frame, text="Disconnected", foreground="gray")
        self.lbl_conn_status.pack(side=tk.LEFT, padx=(0, 6))

        # Padding at right end
        conn_frame.pack_configure(pady=(6, 2))

        # ---- Status bar ----
        status_frame = ttk.Frame(self.root)
        status_frame.pack(fill=tk.X, padx=6, pady=(2, 0))

        self.lbl_rms = ttk.Label(status_frame, text="RMS: --")
        self.lbl_rms.pack(side=tk.LEFT, padx=(0, 16))

        self.lbl_seq = ttk.Label(status_frame, text="Seq: --")
        self.lbl_seq.pack(side=tk.LEFT, padx=(0, 16))

        self.lbl_result = ttk.Label(status_frame, text="Result: --")
        self.lbl_result.pack(side=tk.LEFT, padx=(0, 16))

        self.lbl_stats = ttk.Label(status_frame, text="RMS: 0 | Spec: 0 | Sweeps: 0 | Errors: 0")
        self.lbl_stats.pack(side=tk.RIGHT)

        # Matplotlib figure with two subplots: bar chart + waterfall
        self.fig = Figure(figsize=(10, 5), dpi=96)
        self.fig.set_facecolor("#2b2b2b")

        # Top: current spectrum bar chart (log2 frequency scale)
        self.ax_bar = self.fig.add_subplot(2, 1, 1)
        self.ax_bar.set_facecolor("#1e1e1e")
        self.ax_bar.set_title("Current Spectrum (64 bins, 0\u201323.4 kHz)", color="white", fontsize=10)
        self.ax_bar.set_xlabel("Frequency (Hz) — log\u2082 scale", color="white", fontsize=8)
        self.ax_bar.set_ylabel("Magnitude", color="white", fontsize=8)
        self.ax_bar.set_xscale("log", base=2)
        self.ax_bar.tick_params(colors="white", labelsize=7)
        # Avoid log(0) by starting from bin 1
        bar_freqs = FREQ_AXIS.copy()
        bar_freqs[0] = max(bar_freqs[0], bar_freqs[1] / 2)  # shift DC bin for log display
        self.bar_freqs = bar_freqs
        bar_widths = np.diff(np.append(bar_freqs, NYQUIST)) * 0.8
        self.bars = self.ax_bar.bar(
            bar_freqs, np.zeros(NUM_BINS), width=bar_widths,
            color="#00d4aa", edgecolor="#006655", align="edge"
        )
        self.ax_bar.set_xlim(bar_freqs[0] * 0.8, NYQUIST * 1.05)
        self.ax_bar.set_ylim(0, 1000)

        # Bottom: waterfall spectrogram (frequency on x, linear bin index)
        self.ax_wf = self.fig.add_subplot(2, 1, 2)
        self.ax_wf.set_facecolor("#1e1e1e")
        self.ax_wf.set_title("Waterfall Spectrogram", color="white", fontsize=10)
        self.ax_wf.set_xlabel("Frequency (kHz)", color="white", fontsize=8)
        self.ax_wf.set_ylabel("Time (sweeps ago)", color="white", fontsize=8)
        self.ax_wf.tick_params(colors="white", labelsize=7)
        # Set tick labels to kHz values at select bins
        tick_positions = [0, 8, 16, 24, 32, 40, 48, 56, 63]
        tick_labels = [f"{FREQ_AXIS[i]/1000:.1f}" for i in tick_positions]
        self.ax_wf.set_xticks(tick_positions)
        self.ax_wf.set_xticklabels(tick_labels)
        self.wf_img = self.ax_wf.imshow(
            np.zeros((WATERFALL_ROWS, NUM_BINS)),
            aspect="auto",
            origin="upper",
            cmap="inferno",
            interpolation="nearest",
            vmin=0,
            vmax=1000,
        )
        self.fig.colorbar(self.wf_img, ax=self.ax_wf, label="Magnitude", pad=0.02)
        self.fig.tight_layout(pad=2.0)

        canvas = FigureCanvasTkAgg(self.fig, master=self.root)
        canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=6, pady=6)
        self.canvas = canvas

        # Error / event log at the bottom
        log_frame = ttk.LabelFrame(self.root, text="Event Log")
        log_frame.pack(fill=tk.X, padx=6, pady=(0, 6))

        self.log_text = scrolledtext.ScrolledText(
            log_frame, height=8, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT
        )
        self.log_text.pack(fill=tk.X, padx=4, pady=4)

        # Tag for errors (red text)
        self.log_text.tag_configure("error", foreground="#ff5555")
        self.log_text.tag_configure("info", foreground="#88cc88")

    # ------------------------------------------------------------------
    # ------------------------------------------------------------------
    # Connection management
    # ------------------------------------------------------------------
    def _refresh_ports(self):
        """Rescan serial ports and update the dropdown."""
        ports = serial.tools.list_ports.comports()
        port_list = [f"{p.device} - {p.description}" for p in sorted(ports, key=lambda x: x.device)]
        devices = [p.device for p in sorted(ports, key=lambda x: x.device)]
        self.port_combo["values"] = port_list
        self._port_devices = devices
        if port_list and not self.port_var.get():
            self.port_combo.current(0)

    def _get_selected_port(self) -> str | None:
        idx = self.port_combo.current()
        if idx < 0 or idx >= len(self._port_devices):
            return None
        return self._port_devices[idx]

    def _toggle_connection(self):
        if self.connected:
            self._disconnect()
        else:
            self._connect()

    def _connect(self):
        port = self._get_selected_port()
        if not port:
            self._append_log("ERROR: No port selected")
            return

        try:
            baud = int(self.baud_var.get())
        except ValueError:
            self._append_log("ERROR: Invalid baud rate")
            return

        self.reader = UARTReader(port, baud)
        try:
            self.reader.open()
        except serial.SerialException as e:
            self._append_log(f"ERROR: Cannot open {port}: {e}")
            self.reader = None
            return

        self.reader.start()
        self.connected = True
        self.btn_connect.config(text="Disconnect")
        self.lbl_conn_status.config(text=f"Connected to {port}", foreground="green")
        self.port_combo.config(state="disabled")
        self.baud_entry.config(state="disabled")
        self.btn_refresh.config(state="disabled")
        self._append_log(f"Connected to {port} @ {baud} baud")

    def _disconnect(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
            # Drain remaining log entries from reader before detaching
            self._drain_reader_log()
            self.reader = None

        self.connected = False
        self.btn_connect.config(text="Connect")
        self.lbl_conn_status.config(text="Disconnected", foreground="gray")
        self.port_combo.config(state="readonly")
        self.baud_entry.config(state="normal")
        self.btn_refresh.config(state="normal")
        self._append_log("Disconnected")

    # ------------------------------------------------------------------
    # Update loop
    # ------------------------------------------------------------------
    def _schedule_update(self):
        self._update()
        self.root.after(self.REFRESH_MS, self._schedule_update)

    def _update(self):
        r = self.reader
        if r is None or not self.connected:
            return

        with r.lock:
            spectrum = r.spectrum.copy()
            waterfall = r.waterfall.copy()
            rms = r.rms
            seq = r.seq
            result = r.result
            rms_frames = r.rms_frames
            spec_frames = r.spec_frames
            spec_sweeps = r.spec_sweeps
            total_errors = r.checksum_errors + r.sync_errors + r.bin_range_errors

        # Update status labels
        self.lbl_rms.config(text=f"RMS: {rms}")
        self.lbl_seq.config(text=f"Seq: {seq}")
        result_text = "NORMAL" if result == 0 else "ABNORMAL"
        self.lbl_result.config(
            text=f"Result: {result_text}",
            foreground="green" if result == 0 else "red"
        )
        self.lbl_stats.config(
            text=f"RMS: {rms_frames} | Spec: {spec_frames} | Sweeps: {spec_sweeps} | Errors: {total_errors}"
        )

        # Update bar chart
        peak = max(spectrum.max(), 1)
        for bar, val in zip(self.bars, spectrum):
            bar.set_height(val)
        self.ax_bar.set_ylim(0, max(peak * 1.2, 100))

        # Update waterfall
        wf_peak = max(waterfall.max(), 1)
        self.wf_img.set_data(waterfall)
        self.wf_img.set_clim(0, max(wf_peak * 0.8, 100))

        self.canvas.draw_idle()

        # Drain log messages from reader
        self._drain_reader_log()

    def _drain_reader_log(self):
        """Move pending log entries from the reader to the GUI log widget."""
        if self.reader is None:
            return
        new_lines = []
        while self.reader.log:
            try:
                new_lines.append(self.reader.log.popleft())
            except IndexError:
                break
        for line in new_lines:
            self._append_log(line, from_reader=True)

    def _append_log(self, msg: str, from_reader: bool = False):
        """Add a line to the GUI event log."""
        if not from_reader:
            ts = time.strftime("%H:%M:%S")
            msg = f"[{ts}] {msg}"
        tag = "error" if "ERROR" in msg else "info"
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, msg + "\n", tag)
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)

    # ------------------------------------------------------------------
    def _on_close(self):
        if self.reader:
            self.reader.stop()
            self.reader.close()
        self.root.destroy()

    def run(self):
        self.root.mainloop()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    app = SpectrogramApp()
    app.run()


if __name__ == "__main__":
    main()
