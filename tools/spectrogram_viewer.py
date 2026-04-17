"""
FPGA Spectrogram Viewer + Waveform Simulator
==============================================
Left panel:  Live UART spectrogram from CMOD A7 FPGA.
Right panel: Software waveform simulator with identical FFT pipeline.
Bottom bar:  Real-time comparison metrics (cosine similarity, correlation,
             RMSE) and normalized spectrum overlay.

Both panels show a current-spectrum bar chart (log2 frequency scale)
and a scrolling waterfall spectrogram on the same 0-23.4 kHz axis.

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
ANOMALY_HISTORY = 200          # number of past anomaly score values to plot
CNN_ANOMALY_THRESHOLD = 30     # same as FPGA: MAE above this = anomaly


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

        # Optional callback for serial monitor: fn(bytes, decoded_str, tag)
        self.on_frame = None

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
        self.bytes_received = 0

        # Timing for sweep rate measurement
        self.sweep_timestamps = deque(maxlen=200)

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
            timeout=0.02,
        )
        # Increase OS receive buffer to avoid overflow during slow GUI renders
        try:
            self.ser.set_buffer_size(rx_size=65536)
        except Exception:
            pass  # Not all platforms support this
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
        """Main read loop - byte-level state machine."""
        buf = bytearray()

        while not self._stop.is_set():
            try:
                chunk = self.ser.read(4096)
            except serial.SerialException as e:
                self._log(f"ERROR: Serial read failed: {e}")
                break
            if not chunk:
                continue
            buf.extend(chunk)
            with self.lock:
                self.bytes_received += len(chunk)

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
                    # Not a sync byte - discard and report
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
            chk_ok = (chk == expected)
            if not chk_ok:
                self.checksum_errors += 1
                self._log(
                    f"RMS_CHECKSUM_ERROR: seq={seq} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[result={result} rms={rms} flags=0x{flags:02X} metric={metric}]"
                )
            else:
                self.rms = rms
                self.result = result
                self.flags = flags
                self.seq = seq
                self.metric = metric

        if self.on_frame:
            hex_str = " ".join(f"{b:02X}" for b in frame)
            dec = (f"RMS seq={seq} result={result} rms={rms} "
                   f"flags=0x{flags:02X} metric={metric} chk={'OK' if chk_ok else 'FAIL'}")
            self.on_frame(frame, hex_str, dec, "rms_frame" if chk_ok else "bad_chk")

    # ------------------------------------------------------------------
    def _parse_spec(self, frame: bytearray):
        # frame: DD 77 bin_idx bin_lo bin_hi chk
        bin_idx, bin_lo, bin_hi, chk = frame[2], frame[3], frame[4], frame[5]
        expected = 0xDD ^ 0x77 ^ bin_idx ^ bin_lo ^ bin_hi

        with self.lock:
            self.spec_frames += 1
            chk_ok = (chk == expected)

            if not chk_ok:
                self.checksum_errors += 1
                self._log(
                    f"SPEC_CHECKSUM_ERROR: bin={bin_idx} got=0x{chk:02X} expected=0x{expected:02X} "
                    f"[lo=0x{bin_lo:02X} hi=0x{bin_hi:02X}]"
                )
            elif bin_idx > 63:
                self.bin_range_errors += 1
                self._log(f"BIN_RANGE_ERROR: bin_idx={bin_idx} out of 0-63")
            else:
                mag = bin_lo | (bin_hi << 8)
                self.spectrum[bin_idx] = mag

                self._bins_received.add(bin_idx)
                if len(self._bins_received) == NUM_BINS:
                    self._bins_received.clear()
                    self.spec_sweeps += 1
                    self.sweep_timestamps.append(time.monotonic())
                    self.waterfall = np.roll(self.waterfall, 1, axis=0)
                    self.waterfall[0, :] = self.spectrum.astype(np.float64)

        if self.on_frame:
            hex_str = " ".join(f"{b:02X}" for b in frame)
            mag_val = bin_lo | (bin_hi << 8)
            dec = f"SPEC bin={bin_idx} mag={mag_val} chk={'OK' if chk_ok else 'FAIL'}"
            self.on_frame(frame, hex_str, dec, "spec_frame" if chk_ok else "bad_chk")


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
    REFRESH_MS = 50   # GUI update interval (lowered for blit performance)

    def __init__(self):
        self.reader = None
        self.connected = False
        self.sim = WaveformSimulator()

        # Comparison state
        self._last_live_spectrum = np.zeros(NUM_BINS, dtype=np.float64)
        self._cosine_history = deque([0.0] * SIMILARITY_HISTORY, maxlen=SIMILARITY_HISTORY)
        self._corr_history = deque([0.0] * SIMILARITY_HISTORY, maxlen=SIMILARITY_HISTORY)

        # Anomaly score history
        self._anomaly_history = deque([0] * ANOMALY_HISTORY, maxlen=ANOMALY_HISTORY)

        # Sweep rate tracking
        self._sweep_rate = 0.0

        # Blit rendering cache (invalidated on resize / scale change)
        self._bg_live = None
        self._bg_sim = None
        self._bg_cmp = None
        self._ylim_peak_live = 1000.0
        self._ylim_peak_sim = 1000.0
        self._clim_peak_live = 1000.0
        self._clim_peak_sim = 1000.0
        self._render_ms = 0.0  # last frame render time

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
            f"{title_prefix} - Spectrum (0-23.4 kHz)",
            color="white", fontsize=9,
        )
        ax_bar.set_xlabel("Frequency (Hz) - log2 scale", color="white", fontsize=7)
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
        ax_wf.set_title(f"{title_prefix} - Waterfall", color="white", fontsize=9)
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
        conn_frame.grid(row=0, column=0, sticky="ew", padx=6, pady=(6, 2))

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

        # ---- Main split: Live (left) | Simulator (right) ----
        main_pw = ttk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        main_pw.grid(row=1, column=0, sticky="nsew", padx=6, pady=4)

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

        # ---- CNN Anomaly Status Bar ----
        cnn_frame = ttk.Frame(left_frame)
        cnn_frame.pack(fill=tk.X, padx=4, pady=(2, 0))

        self.lbl_cnn_status = ttk.Label(
            cnn_frame, text="CNN: --",
            font=("Consolas", 11, "bold"),
        )
        self.lbl_cnn_status.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_anomaly_score = ttk.Label(
            cnn_frame, text="MAE: --",
            font=("Consolas", 10),
        )
        self.lbl_anomaly_score.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_flags = ttk.Label(
            cnn_frame, text="Flags: --",
            font=("Consolas", 9),
        )
        self.lbl_flags.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_anomaly_interp = ttk.Label(
            cnn_frame, text="",
            font=("Consolas", 9),
        )
        self.lbl_anomaly_interp.pack(side=tk.LEFT)

        # Live matplotlib figure
        self.fig_live = Figure(figsize=(6, 4.5), dpi=96)
        objs = self._make_spectrum_axes(self.fig_live, "#00d4aa", "#006655", "Live")
        self.bar_freqs, self.bars_live, self.ax_bar_live, self.ax_wf_live, self.wf_img_live = objs

        self.canvas_live = FigureCanvasTkAgg(self.fig_live, master=left_frame)
        self.canvas_live.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)
        for bar in self.bars_live:
            bar.set_animated(True)
        self.wf_img_live.set_animated(True)

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
        for bar in self.bars_sim:
            bar.set_animated(True)
        self.wf_img_sim.set_animated(True)

        # ========== BOTTOM TABBED PANEL ==========
        # Using grid layout on root so bottom tabs get guaranteed space.
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(1, weight=3)   # charts get most vertical space
        self.root.rowconfigure(2, weight=1)   # bottom tabs always visible

        bottom_nb = ttk.Notebook(self.root)
        bottom_nb.grid(row=2, column=0, sticky="nsew", padx=6, pady=(0, 6))
        self.bottom_nb = bottom_nb  # keep ref for tab-aware rendering

        # --- Tab 1: Comparison ---
        cmp_frame = ttk.Frame(bottom_nb)
        bottom_nb.add(cmp_frame, text="Comparison")

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

        # Right subplot: anomaly score + similarity history over time
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
        self.line_anomaly_hist, = self.ax_hist.plot(
            [], [], color="#ff4444", linewidth=1.5, label="Anomaly MAE", alpha=0.9)
        self.ax_hist.legend(loc="lower right", fontsize=6,
                            facecolor="#2b2b2b", edgecolor="#555",
                            labelcolor="white")
        self.ax_hist.axhline(y=0.9, color="#555555", linestyle="--", linewidth=0.5)
        self.ax_hist.axhline(y=0.5, color="#333333", linestyle="--", linewidth=0.5)
        # Anomaly threshold line (CNN_ANOMALY_THRESHOLD/255 normalized)
        self.ax_hist.axhline(
            y=CNN_ANOMALY_THRESHOLD / 255.0, color="#ff4444",
            linestyle="--", linewidth=0.8, alpha=0.5,
        )

        self.fig_cmp.tight_layout(pad=1.5)

        self.canvas_cmp = FigureCanvasTkAgg(self.fig_cmp, master=cmp_frame)
        self.canvas_cmp.get_tk_widget().pack(fill=tk.BOTH, expand=True, padx=4, pady=4)
        self.line_live_norm.set_animated(True)
        self.line_sim_norm.set_animated(True)
        self.line_cos_hist.set_animated(True)
        self.line_corr_hist.set_animated(True)
        self.line_anomaly_hist.set_animated(True)

        # --- Tab 2: Event log ---
        log_frame = ttk.Frame(bottom_nb)
        bottom_nb.add(log_frame, text="Event Log")

        self.log_text = scrolledtext.ScrolledText(
            log_frame, height=10, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT,
            insertbackground="#cccccc", selectbackground="#404040",
            selectforeground="#cccccc",
        )
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=4, pady=4)
        self.log_text.vbar.configure(
            bg="#3a3a3a", troughcolor="#1e1e1e",
            activebackground="#555555", relief=tk.FLAT,
            highlightthickness=0, bd=0,
        )
        self.log_text.tag_configure("error", foreground="#ff5555")
        self.log_text.tag_configure("info", foreground="#88cc88")

        # --- Tab 3: Serial monitor ---
        serial_frame = ttk.Frame(bottom_nb)
        bottom_nb.add(serial_frame, text="Serial Monitor")

        serial_ctrl = ttk.Frame(serial_frame)
        serial_ctrl.pack(fill=tk.X, padx=4, pady=(4, 0))

        self.serial_hex_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(serial_ctrl, text="Hex", variable=self.serial_hex_var).pack(side=tk.LEFT, padx=(0, 6))

        self.serial_decode_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(serial_ctrl, text="Decode Frames", variable=self.serial_decode_var).pack(side=tk.LEFT, padx=(0, 6))

        self.serial_pause_var = tk.BooleanVar(value=False)
        ttk.Checkbutton(serial_ctrl, text="Pause", variable=self.serial_pause_var).pack(side=tk.LEFT, padx=(0, 6))

        ttk.Button(serial_ctrl, text="Clear", width=6,
                   command=self._serial_clear).pack(side=tk.LEFT, padx=(0, 6))

        self.lbl_serial_stats = ttk.Label(serial_ctrl, text="Bytes: 0", foreground="gray")
        self.lbl_serial_stats.pack(side=tk.RIGHT, padx=(0, 4))

        self.serial_text = scrolledtext.ScrolledText(
            serial_frame, height=8, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT,
            insertbackground="#cccccc", selectbackground="#404040",
            selectforeground="#cccccc",
        )
        self.serial_text.pack(fill=tk.BOTH, expand=True, padx=4, pady=4)
        self.serial_text.vbar.configure(
            bg="#3a3a3a", troughcolor="#1e1e1e",
            activebackground="#555555", relief=tk.FLAT,
            highlightthickness=0, bd=0,
        )
        self.serial_text.tag_configure("rms_frame", foreground="#44bbff")
        self.serial_text.tag_configure("spec_frame", foreground="#88cc88")
        self.serial_text.tag_configure("bad_chk", foreground="#ff5555")
        self.serial_text.tag_configure("hex_raw", foreground="#888888")

        # Serial monitor state
        self._serial_byte_count = 0
        self._serial_lines = deque(maxlen=500)

        # --- Tab 4: Diagnostics ---
        diag_frame = ttk.Frame(bottom_nb)
        bottom_nb.add(diag_frame, text="Diagnostics")

        self.diag_text = scrolledtext.ScrolledText(
            diag_frame, height=12, state=tk.DISABLED,
            bg="#1e1e1e", fg="#cccccc", font=("Consolas", 9),
            wrap=tk.WORD, relief=tk.FLAT,
            insertbackground="#cccccc", selectbackground="#404040",
            selectforeground="#cccccc",
        )
        self.diag_text.pack(fill=tk.BOTH, expand=True, padx=4, pady=4)
        self.diag_text.vbar.configure(
            bg="#3a3a3a", troughcolor="#1e1e1e",
            activebackground="#555555", relief=tk.FLAT,
            highlightthickness=0, bd=0,
        )
        self.diag_text.tag_configure("header", foreground="#44bbff", font=("Consolas", 10, "bold"))
        self.diag_text.tag_configure("warn", foreground="#ccaa00")
        self.diag_text.tag_configure("ok", foreground="#00cc66")
        self.diag_text.tag_configure("bad", foreground="#ff5555")

    # ------------------------------------------------------------------
    # Simulator controls
    # ------------------------------------------------------------------
    def _on_sim_param_change(self, *_args):
        self.sim.waveform = self.wave_var.get()
        self.sim.enabled = self.sim_enable_var.get()
        self._bg_sim = None  # invalidate blit cache

    def _on_freq_slider(self, val):
        freq = float(val)
        self.sim.frequency = freq
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")
        self._bg_sim = None  # invalidate blit cache

    def _on_freq_entry(self, _event=None):
        try:
            freq = float(self.freq_entry.get())
            freq = max(20.0, min(22000.0, freq))
        except ValueError:
            return
        self.sim.frequency = freq
        self.freq_var.set(freq)
        self._bg_sim = None  # invalidate blit cache

    def _on_amp_slider(self, val):
        amp = float(val)
        self.sim.amplitude = amp
        self.amp_entry.delete(0, tk.END)
        self.amp_entry.insert(0, f"{amp:.2f}")
        self._bg_sim = None  # invalidate blit cache

    def _on_amp_entry(self, _event=None):
        try:
            amp = float(self.amp_entry.get())
            amp = max(0.0, min(1.0, amp))
        except ValueError:
            return
        self.sim.amplitude = amp
        self.amp_var.set(amp)
        self._bg_sim = None  # invalidate blit cache

    def _apply_preset(self, freq):
        self.sim.frequency = freq
        self.freq_var.set(freq)
        self.freq_entry.delete(0, tk.END)
        self.freq_entry.insert(0, f"{freq:.0f}")
        self._bg_sim = None  # invalidate blit cache

    # ------------------------------------------------------------------
    # Serial monitor helpers
    # ------------------------------------------------------------------
    def _serial_clear(self):
        self.serial_text.config(state=tk.NORMAL)
        self.serial_text.delete("1.0", tk.END)
        self.serial_text.config(state=tk.DISABLED)
        self._serial_byte_count = 0
        self._serial_lines.clear()

    def _serial_append(self, text, tag=None):
        """Append a line to the serial monitor (thread-safe via deque)."""
        self._serial_lines.append((text, tag))

    def _serial_flush(self):
        """Flush pending serial lines to the text widget (call from GUI thread)."""
        if self.serial_pause_var.get():
            return
        lines = []
        while self._serial_lines:
            try:
                lines.append(self._serial_lines.popleft())
            except IndexError:
                break
        if not lines:
            return
        self.serial_text.config(state=tk.NORMAL)
        for text, tag in lines:
            if tag:
                self.serial_text.insert(tk.END, text + "\n", tag)
            else:
                self.serial_text.insert(tk.END, text + "\n")
        # Trim to last 500 lines
        line_count = int(self.serial_text.index("end-1c").split(".")[0])
        if line_count > 500:
            self.serial_text.delete("1.0", f"{line_count - 500}.0")
        self.serial_text.see(tk.END)
        self.serial_text.config(state=tk.DISABLED)
        self.lbl_serial_stats.config(text=f"Bytes: {self._serial_byte_count}")

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

        # Hook serial monitor callback
        def _on_serial_frame(raw_bytes, hex_str, decoded, tag):
            self._serial_byte_count += len(raw_bytes)
            if self.serial_decode_var.get():
                self._serial_append(f"{hex_str}  | {decoded}", tag)
            elif self.serial_hex_var.get():
                self._serial_append(hex_str, "hex_raw")
        self.reader.on_frame = _on_serial_frame

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
    # Blit rendering helpers
    # ------------------------------------------------------------------
    def _blit_canvas(self, canvas, fig, bg_attr, animated_artists):
        """Fast canvas update using blitting. Falls back to full draw on cache miss."""
        bg = getattr(self, bg_attr)
        # Invalidate if canvas was resized
        size_key = bg_attr + '_size'
        current_size = canvas.get_width_height()
        if bg is not None and getattr(self, size_key, None) != current_size:
            bg = None
            setattr(self, bg_attr, None)
        if bg is None:
            canvas.draw()
            setattr(self, bg_attr, canvas.copy_from_bbox(fig.bbox))
            setattr(self, size_key, current_size)
            bg = getattr(self, bg_attr)
        canvas.restore_region(bg)
        for artist in animated_artists:
            artist.axes.draw_artist(artist)
        canvas.blit(fig.bbox)

    # ------------------------------------------------------------------
    # Update loop
    # ------------------------------------------------------------------
    def _schedule_update(self):
        self._update()
        self.root.after(self.REFRESH_MS, self._schedule_update)

    def _update(self):
        t0 = time.perf_counter()
        live_has_data = False

        # Flush serial monitor lines to GUI
        self._serial_flush()

        # ---- Live UART panel ----
        r = self.reader
        if r is not None and self.connected:
            with r.lock:
                spectrum = r.spectrum.copy()
                waterfall = r.waterfall.copy()
                rms = r.rms
                seq = r.seq
                result = r.result
                flags = r.flags
                metric = r.metric
                rms_frames = r.rms_frames
                spec_frames = r.spec_frames
                spec_sweeps = r.spec_sweeps
                chk_errors = r.checksum_errors
                sync_errors = r.sync_errors
                bin_errors = r.bin_range_errors
                bytes_recv = r.bytes_received
                sweep_ts = list(r.sweep_timestamps)

            total_errors = chk_errors + sync_errors + bin_errors

            # Compute sweep rate from actual reader timestamps (last 5 seconds)
            now = time.monotonic()
            recent = [t for t in sweep_ts if now - t < 5.0]
            if len(recent) >= 2:
                self._sweep_rate = (len(recent) - 1) / (recent[-1] - recent[0])
            elif len(recent) == 1:
                self._sweep_rate = 1.0  # at least one in 5s
            else:
                self._sweep_rate = 0.0

            self.lbl_rms.config(text=f"RMS: {rms}")
            self.lbl_seq.config(text=f"Seq: {seq}")
            result_text = "NORMAL" if result == 0 else "ABNORMAL"
            self.lbl_result.config(
                text=f"Result: {result_text}",
                foreground="green" if result == 0 else "red",
            )
            err_detail = f"ChkErr:{chk_errors} Sync:{sync_errors} Bin:{bin_errors}" if total_errors else "0"
            self.lbl_stats.config(
                text=f"Sweeps: {spec_sweeps} ({self._sweep_rate:.1f}/s) | Err: {err_detail}",
            )

            # ---- CNN Anomaly Status ----
            # Flag bits: bit0=FPGA active, bit1=CNN anomaly detected, bit2=CNN has run
            fpga_active = bool(flags & 0x01)
            cnn_anomaly = bool(flags & 0x02)
            cnn_ran = bool(flags & 0x04)

            if not fpga_active:
                cnn_status_text = "CNN: FPGA Inactive"
                cnn_color = "gray"
            elif not cnn_ran:
                # Decode debug byte from metric field
                dbg = metric
                wrapper_state = dbg & 0x07
                scorer_tready = bool(dbg & 0x08)
                frame_seen    = bool(dbg & 0x10)
                feeder_done   = bool(dbg & 0x20)
                tvalid_out    = bool(dbg & 0x40)
                tready_in     = bool(dbg & 0x80)
                state_names = {0: "IDLE", 1: "START", 2: "FEED",
                               3: "PROCESS", 4: "RESULT"}
                st_name = state_names.get(wrapper_state, f"?{wrapper_state}")
                cnn_status_text = (
                    f"CNN DBG: FSM={st_name} | "
                    f"frame={'Y' if frame_seen else 'N'} "
                    f"feed_done={'Y' if feeder_done else 'N'} "
                    f"out_tvalid={'Y' if tvalid_out else 'N'} "
                    f"in_tready={'Y' if tready_in else 'N'} "
                    f"scr_tready={'Y' if scorer_tready else 'N'}"
                )
                cnn_color = "#ccaa00"
            elif cnn_anomaly:
                cnn_status_text = "CNN: ABNORMAL"
                cnn_color = "#ff3333"
            else:
                cnn_status_text = "CNN: NORMAL"
                cnn_color = "#00cc66"

            self.lbl_cnn_status.config(text=cnn_status_text, foreground=cnn_color)

            # Anomaly score with color gradient
            if not cnn_ran:
                score_color = "gray"
            elif metric < 10:
                score_color = "#00cc66"       # green — excellent
            elif metric < 20:
                score_color = "#88cc00"       # yellow-green
            elif metric < CNN_ANOMALY_THRESHOLD:
                score_color = "#ccaa00"       # yellow — borderline
            elif metric < 60:
                score_color = "#ff8800"       # orange — anomaly
            else:
                score_color = "#ff3333"       # red — strong anomaly

            self.lbl_anomaly_score.config(
                text=f"MAE: {metric}/255" if cnn_ran else f"DBG: 0x{metric:02X}",
                foreground=score_color,
            )

            # Flags decode
            flag_parts = []
            flag_parts.append("FPGA:" + ("ON" if fpga_active else "off"))
            flag_parts.append("CNN:" + ("ran" if cnn_ran else "pending"))
            flag_parts.append("Anomaly:" + ("YES" if cnn_anomaly else "no"))
            self.lbl_flags.config(
                text=f"Flags: {' | '.join(flag_parts)}  [raw=0x{flags:02X}]",
            )

            # Interpretation text
            if not cnn_ran:
                dbg = metric
                wrapper_state = dbg & 0x07
                frame_seen = bool(dbg & 0x10)
                if wrapper_state == 0 and not frame_seen:
                    interp = "Stuck in IDLE — frame_ready never reached CNN wrapper"
                elif wrapper_state == 0 and frame_seen:
                    interp = "In IDLE with frame_ready seen — should have started, check reset"
                elif wrapper_state == 2:
                    interp = "Stuck in FEED — feeder waiting for CNN TREADY (backpressure deadlock?)"
                elif wrapper_state == 3:
                    interp = "Stuck in PROCESS — scorer waiting for CNN output (CNN internal stall?)"
                else:
                    interp = f"FSM state {wrapper_state} — debug byte 0x{dbg:02X}"
            elif metric < 10:
                interp = "Excellent — very low reconstruction error"
            elif metric < 20:
                interp = "Good — normal reconstruction"
            elif metric < CNN_ANOMALY_THRESHOLD:
                interp = "Elevated — approaching threshold"
            elif metric < 60:
                interp = "ANOMALY detected"
            else:
                interp = "STRONG anomaly — high reconstruction error"

            self.lbl_anomaly_interp.config(text=interp, foreground=score_color)

            # Track anomaly history
            self._anomaly_history.append(metric)

            peak = max(spectrum.max(), 1)
            for bar, val in zip(self.bars_live, spectrum):
                bar.set_height(val)
            new_ylim = max(peak * 1.2, 100)
            if new_ylim > self._ylim_peak_live * 1.5 or new_ylim < self._ylim_peak_live * 0.3:
                self._ylim_peak_live = new_ylim
                self.ax_bar_live.set_ylim(0, new_ylim)
                self._bg_live = None

            wf_peak = max(waterfall.max(), 1)
            self.wf_img_live.set_data(waterfall)
            new_clim = max(wf_peak * 0.8, 100)
            if new_clim > self._clim_peak_live * 1.5 or new_clim < self._clim_peak_live * 0.3:
                self._clim_peak_live = new_clim
                self.wf_img_live.set_clim(0, new_clim)
                self._bg_live = None

            live_artists = list(self.bars_live) + [self.wf_img_live]
            self._blit_canvas(self.canvas_live, self.fig_live, '_bg_live', live_artists)
            self._drain_reader_log()

            self._last_live_spectrum = spectrum.astype(np.float64)
            live_has_data = spectrum.max() > 0

        # ---- Simulator panel (always step + blit) ----
        self.sim.step()
        sim_spec = self.sim.spectrum
        sim_wf = self.sim.waterfall

        sim_peak = max(sim_spec.max(), 1)
        for bar, val in zip(self.bars_sim, sim_spec):
            bar.set_height(val)
        new_ylim_sim = max(sim_peak * 1.2, 100)
        if new_ylim_sim > self._ylim_peak_sim * 1.5 or new_ylim_sim < self._ylim_peak_sim * 0.3:
            self._ylim_peak_sim = new_ylim_sim
            self.ax_bar_sim.set_ylim(0, new_ylim_sim)
            self._bg_sim = None

        sim_wf_peak = max(sim_wf.max(), 1)
        self.wf_img_sim.set_data(sim_wf)
        new_clim_sim = max(sim_wf_peak * 0.8, 100)
        if new_clim_sim > self._clim_peak_sim * 1.5 or new_clim_sim < self._clim_peak_sim * 0.3:
            self._clim_peak_sim = new_clim_sim
            self.wf_img_sim.set_clim(0, new_clim_sim)
            self._bg_sim = None

        sim_artists = list(self.bars_sim) + [self.wf_img_sim]
        self._blit_canvas(self.canvas_sim, self.fig_sim, '_bg_sim', sim_artists)

        # ---- Comparison panel (data always, canvas only when tab visible) ----
        self._update_comparison(live_has_data, sim_spec)
        try:
            tab_idx = self.bottom_nb.index(self.bottom_nb.select())
        except Exception:
            tab_idx = 0
        if tab_idx == 0:  # Comparison tab is selected
            cmp_artists = [self.line_live_norm, self.line_sim_norm,
                           self.line_cos_hist, self.line_corr_hist,
                           self.line_anomaly_hist]
            if self.fill_diff is not None:
                cmp_artists.append(self.fill_diff)
            self._blit_canvas(self.canvas_cmp, self.fig_cmp, '_bg_cmp', cmp_artists)

        # ---- Diagnostics panel (update every ~1s to avoid overhead) ----
        now_diag = time.monotonic()
        if not hasattr(self, '_last_diag_time'):
            self._last_diag_time = 0.0
            self._last_diag_bytes = 0
        if now_diag - self._last_diag_time >= 1.0:
            self._update_diagnostics()
            self._last_diag_time = now_diag

        self._render_ms = (time.perf_counter() - t0) * 1000

    # ------------------------------------------------------------------
    def _update_comparison(self, live_has_data, sim_spec):
        """Compute and display comparison between live and simulator spectra."""
        live_norm = _normalize(self._last_live_spectrum)
        sim_norm = _normalize(sim_spec)

        x = np.arange(NUM_BINS)

        # Update overlay lines
        self.line_live_norm.set_data(x, live_norm)
        self.line_sim_norm.set_data(x, sim_norm)

        # Update shaded difference region by replacing polygon vertices
        # instead of remove/recreate (much faster — avoids new artist allocation)
        verts = np.zeros((2 * NUM_BINS + 1, 2))
        verts[:NUM_BINS, 0] = x
        verts[:NUM_BINS, 1] = live_norm
        verts[NUM_BINS:2*NUM_BINS, 0] = x[::-1]
        verts[NUM_BINS:2*NUM_BINS, 1] = sim_norm[::-1]
        verts[-1] = verts[0]  # close polygon

        if self.fill_diff is None:
            self.fill_diff = self.ax_overlay.fill(
                verts[:, 0], verts[:, 1],
                alpha=0.2, color="#ff4444", label="_diff",
            )[0]
            self.fill_diff.set_animated(True)
            self._bg_cmp = None  # invalidate so new artist gets drawn
        else:
            self.fill_diff.set_xy(verts)

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
        # Overlay anomaly score (normalized to 0-1 range: score/255)
        anomaly_norm = [v / 255.0 for v in self._anomaly_history]
        self.line_anomaly_hist.set_data(hist_x, anomaly_norm)

    # ------------------------------------------------------------------
    def _update_diagnostics(self):
        """Refresh the Diagnostics tab with real-time timing and error info."""
        r = self.reader
        if r is None or not self.connected:
            return

        with r.lock:
            rms_frames = r.rms_frames
            spec_frames = r.spec_frames
            spec_sweeps = r.spec_sweeps
            chk_err = r.checksum_errors
            sync_err = r.sync_errors
            bin_err = r.bin_range_errors
            bytes_recv = r.bytes_received
            sweep_ts = list(r.sweep_timestamps)
            seq = r.seq
            flags = r.flags
            metric = r.metric

        now = time.monotonic()

        # Sweep rate from timestamps
        recent_1s = [t for t in sweep_ts if now - t < 1.0]
        recent_5s = [t for t in sweep_ts if now - t < 5.0]
        rate_1s = len(recent_1s)
        if len(recent_5s) >= 2:
            rate_5s = (len(recent_5s) - 1) / (recent_5s[-1] - recent_5s[0])
        else:
            rate_5s = 0.0

        # Bytes per second
        bytes_rate = 0.0
        if hasattr(self, '_last_diag_bytes'):
            dt = now - (self._last_diag_time if self._last_diag_time > 0 else now)
            if dt > 0:
                bytes_rate = (bytes_recv - self._last_diag_bytes) / max(dt, 0.1)
        self._last_diag_bytes = bytes_recv

        # Inter-sweep timing (jitter analysis)
        if len(sweep_ts) >= 2:
            deltas = [sweep_ts[i] - sweep_ts[i-1] for i in range(1, len(sweep_ts))]
            recent_deltas = deltas[-50:]  # last 50 intervals
            avg_delta = sum(recent_deltas) / len(recent_deltas) if recent_deltas else 0
            min_delta = min(recent_deltas) if recent_deltas else 0
            max_delta = max(recent_deltas) if recent_deltas else 0
        else:
            avg_delta = min_delta = max_delta = 0

        # CNN state
        fpga_active = bool(flags & 0x01)
        cnn_ran = bool(flags & 0x04)
        cnn_anomaly = bool(flags & 0x02)

        # Build diagnostics text
        lines = []
        lines.append(("=== FPGA Data Rate ===\n", "header"))
        lines.append((f"  Bytes received:    {bytes_recv:,}\n", None))
        lines.append((f"  Byte rate:         {bytes_rate:,.0f} B/s "
                      f"(expected ~7,840 B/s at 20 sweeps/s)\n",
                      "ok" if bytes_rate > 5000 else "warn" if bytes_rate > 0 else None))
        lines.append((f"  RMS frames:        {rms_frames:,}\n", None))
        lines.append((f"  Spec frames:       {spec_frames:,}  "
                      f"(= {spec_frames/64:.0f} theoretical sweeps)\n", None))
        lines.append((f"  Complete sweeps:   {spec_sweeps:,}\n", None))
        lines.append((f"  FPGA seq byte:     {seq}  (wraps at 255)\n", None))

        lines.append(("\n=== Sweep Timing ===\n", "header"))
        lines.append((f"  Rate (1s window):  {rate_1s} sweeps\n",
                      "ok" if rate_1s >= 15 else "warn" if rate_1s >= 5 else "bad"))
        lines.append((f"  Rate (5s avg):     {rate_5s:.1f} sweeps/s\n",
                      "ok" if rate_5s >= 15 else "warn" if rate_5s >= 5 else "bad"))
        if avg_delta > 0:
            lines.append((f"  Avg interval:      {avg_delta*1000:.1f} ms  "
                          f"(expected ~50 ms)\n",
                          "ok" if 30 < avg_delta*1000 < 80 else "warn"))
            lines.append((f"  Min interval:      {min_delta*1000:.1f} ms\n",
                          "ok" if min_delta*1000 > 10 else "warn"))
            lines.append((f"  Max interval:      {max_delta*1000:.1f} ms\n",
                          "bad" if max_delta*1000 > 200 else "warn" if max_delta*1000 > 100 else "ok"))
            if max_delta > 0.2:
                lines.append((f"  WARNING: Max gap {max_delta*1000:.0f}ms >> 50ms expected. "
                              f"Possible CNN inference stall or GUI render blocking.\n", "bad"))
        else:
            lines.append(("  (waiting for sweep data...)\n", None))

        lines.append(("\n=== Errors ===\n", "header"))
        lines.append((f"  Checksum errors:   {chk_err}\n",
                      "bad" if chk_err > 10 else "warn" if chk_err > 0 else "ok"))
        lines.append((f"  Sync errors:       {sync_err}\n",
                      "bad" if sync_err > 10 else "warn" if sync_err > 0 else "ok"))
        lines.append((f"  Bin range errors:  {bin_err}\n",
                      "bad" if bin_err > 0 else "ok"))
        total_err = chk_err + sync_err + bin_err
        if rms_frames > 0:
            err_pct = total_err / (rms_frames + spec_frames) * 100 if (rms_frames + spec_frames) > 0 else 0
            lines.append((f"  Error rate:        {err_pct:.2f}%\n",
                          "bad" if err_pct > 1 else "warn" if err_pct > 0.1 else "ok"))

        lines.append(("\n=== CNN Status ===\n", "header"))
        lines.append((f"  FPGA active:       {'Yes' if fpga_active else 'No'}\n",
                      "ok" if fpga_active else "bad"))
        lines.append((f"  CNN has run:       {'Yes' if cnn_ran else 'No'}\n",
                      "ok" if cnn_ran else "warn"))
        if cnn_ran:
            lines.append((f"  Anomaly detected:  {'YES' if cnn_anomaly else 'No'}\n",
                          "bad" if cnn_anomaly else "ok"))
            lines.append((f"  MAE score:         {metric}/255  "
                          f"(threshold: {CNN_ANOMALY_THRESHOLD})\n",
                          "bad" if metric >= CNN_ANOMALY_THRESHOLD else "ok"))
        else:
            lines.append((f"  Debug byte:        0x{metric:02X}\n", "warn"))

        lines.append(("\n=== GUI Render Performance ===\n", "header"))
        render_ms = self._render_ms
        effective_fps = 1000.0 / max(render_ms + self.REFRESH_MS, 1)
        lines.append((f"  Last frame render: {render_ms:.1f} ms\n",
                      "ok" if render_ms < 30 else "warn" if render_ms < 80 else "bad"))
        lines.append((f"  Refresh interval:  {self.REFRESH_MS} ms\n", None))
        lines.append((f"  Effective FPS:     ~{effective_fps:.1f}\n",
                      "ok" if effective_fps >= 15 else "warn" if effective_fps >= 8 else "bad"))
        lines.append((f"  Render mode:       blit (cached backgrounds)\n", None))

        # Write to diagnostics text widget
        self.diag_text.config(state=tk.NORMAL)
        self.diag_text.delete("1.0", tk.END)
        for text, tag in lines:
            if tag:
                self.diag_text.insert(tk.END, text, tag)
            else:
                self.diag_text.insert(tk.END, text)
        self.diag_text.config(state=tk.DISABLED)

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
