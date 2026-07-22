'use client';

import { useEffect, useRef, useState, useCallback } from 'react';
import { createClient } from '@supabase/supabase-js';
import Link from 'next/link';
import { useTheme } from '../ThemeProvider';

// ── Supabase (optional cloud path) ────────────────────────────────────────────
// Opt-in while the Supabase project is switched off — see app/page.js for the
// re-enable steps. Host mode over USB works with or without it.
const SUPA_ENABLED = process.env.NEXT_PUBLIC_SUPABASE_ENABLED === 'true';
const SUPA_URL = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
const SUPA_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY?.trim();
const supabase = SUPA_ENABLED && SUPA_URL && SUPA_KEY
  ? createClient(SUPA_URL, SUPA_KEY)
  : null;
const CHANNEL_NAME   = 'spectrogram-live';
const BROADCAST_HZ   = 15;   // max sweeps pushed to Supabase per second
const DB_INSERT_HZ   = 1;    // max telemetry rows inserted to Supabase DB per second

// ── Constants ─────────────────────────────────────────────────────────────────
const BAUD_RATE      = 1_000_000;
const NUM_BINS       = 64;
const WATERFALL_ROWS = 128;
const SAMPLE_RATE    = 46875.0;
const BIN_SPACING    = SAMPLE_RATE / 512;

const FREQ_LABELS = [0, 8, 16, 24, 32, 40, 48, 56, 63].map(k => ({
  bin: k,
  label: ((k * 4 * BIN_SPACING) / 1000).toFixed(1) + 'k',
}));

// ── UART frame parser ─────────────────────────────────────────────────────────
class UARTParser {
  constructor({ onSweep, onRms }) {
    this.buf            = [];
    this.spectrum       = new Uint16Array(NUM_BINS);
    this.binsReceived   = new Set();
    this.sweepCount     = 0;
    this.checksumErrors = 0;
    this.rms = 0; this.result = 0; this.flags = 0;
    this.seq = 0; this.metric = 0;
    this.onSweep = onSweep;
    this.onRms   = onRms;
  }

  feed(bytes) {
    for (const b of bytes) this.buf.push(b);
    this._process();
  }

  _process() {
    while (this.buf.length >= 2) {
      if (this.buf[0] === 0xAA && this.buf[1] === 0x55) {
        if (this.buf.length < 8) break;
        this._parseRms(this.buf.splice(0, 8));
      } else if (this.buf[0] === 0xDD && this.buf[1] === 0x77) {
        if (this.buf.length < 6) break;
        this._parseSpec(this.buf.splice(0, 6));
      } else {
        this.buf.shift();
      }
    }
  }

  _parseRms(f) {
    const [,, result, rms, flags, seq, metric, chk] = f;
    if (chk !== (0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric)) {
      this.checksumErrors++; return;
    }
    this.rms = rms; this.result = result; this.flags = flags;
    this.seq = seq; this.metric = metric;
    this.onRms?.({ rms, result, flags, seq, metric });
  }

  _parseSpec(f) {
    const [,, binIdx, binLo, binHi, chk] = f;
    if (chk !== (0xDD ^ 0x77 ^ binIdx ^ binLo ^ binHi) || binIdx > 63) {
      this.checksumErrors++; return;
    }
    this.spectrum[binIdx] = binLo | (binHi << 8);
    this.binsReceived.add(binIdx);
    if (this.binsReceived.size === NUM_BINS) {
      this.binsReceived.clear();
      this.sweepCount++;
      this.onSweep?.({
        spectrum: Array.from(this.spectrum),
        rms: this.rms, result: this.result, flags: this.flags,
        seq: this.seq, metric: this.metric, sweep: this.sweepCount,
      });
    }
  }
}

// ── Colormap ──────────────────────────────────────────────────────────────────
function heatColor(t) {
  t = Math.max(0, Math.min(1, t));
  let r, g, b;
  if (t < 0.2)      { const s = t/0.2;         r=0;               g=0;                   b=Math.round(100+s*155); }
  else if (t < 0.4) { const s=(t-0.2)/0.2;     r=0;               g=Math.round(s*220);    b=255; }
  else if (t < 0.6) { const s=(t-0.4)/0.2;     r=0;               g=220+Math.round(s*35); b=Math.round(255*(1-s)); }
  else if (t < 0.8) { const s=(t-0.6)/0.2;     r=Math.round(s*255); g=255;               b=0; }
  else               { const s=(t-0.8)/0.2;     r=255;             g=Math.round(255*(1-s*0.7)); b=0; }
  return [r, g, b];
}

// ── Canvas renderers ──────────────────────────────────────────────────────────
function drawWaterfall(canvas, buf, head, peak) {
  const ctx = canvas.getContext('2d');
  const img = ctx.createImageData(NUM_BINS, WATERFALL_ROWS);
  const pix = img.data;
  const norm = peak > 0 ? peak : 1;
  for (let row = 0; row < WATERFALL_ROWS; row++) {
    const bufRow = (head - 1 - row + WATERFALL_ROWS * 2) % WATERFALL_ROWS;
    for (let bin = 0; bin < NUM_BINS; bin++) {
      const [r, g, b] = heatColor(buf[bufRow * NUM_BINS + bin] / norm);
      const idx = (row * NUM_BINS + bin) * 4;
      pix[idx]=r; pix[idx+1]=g; pix[idx+2]=b; pix[idx+3]=255;
    }
  }
  ctx.putImageData(img, 0, 0);
}

function drawSpectrum(canvas, spectrum, peak) {
  const ctx  = canvas.getContext('2d');
  const W = canvas.width, H = canvas.height;
  const norm = peak > 0 ? peak : 1;
  ctx.clearRect(0, 0, W, H);
  const barW = W / NUM_BINS;
  for (let bin = 0; bin < NUM_BINS; bin++) {
    const t  = spectrum[bin] / norm;
    const [r, g, b] = heatColor(t);
    ctx.fillStyle = `rgb(${r},${g},${b})`;
    ctx.fillRect(bin * barW, H - Math.max(1, t * H), Math.max(barW - 1, 1), Math.max(1, t * H));
  }
}

// ── Shared sweep renderer (called by both host and viewer paths) ───────────────
function applySweep(sweep, refs) {
  const { wfBufRef, headRef, peakRef, wfCanvasRef, barCanvasRef } = refs;
  const { spectrum } = sweep;
  const row = headRef.current;
  const buf = wfBufRef.current;
  let peak  = 0;
  for (let i = 0; i < NUM_BINS; i++) {
    buf[row * NUM_BINS + i] = spectrum[i];
    if (spectrum[i] > peak) peak = spectrum[i];
  }
  headRef.current = (row + 1) % WATERFALL_ROWS;
  peakRef.current = Math.max(peakRef.current * 0.998, peak);
  if (wfCanvasRef.current)
    drawWaterfall(wfCanvasRef.current, buf, headRef.current, peakRef.current);
  if (barCanvasRef.current)
    drawSpectrum(barCanvasRef.current, spectrum, peakRef.current);
}

// ── Page ──────────────────────────────────────────────────────────────────────
export default function SpectrogramPage() {
  const { isDark, toggleTheme } = useTheme();

  // 'idle' | 'hosting' | 'viewing' | 'error' | 'unsupported'
  const [status,         setStatus]         = useState('idle');
  const [errMsg,         setErrMsg]         = useState('');
  const [stats,          setStats]          = useState(null);
  const [sweepCount,     setSweepCount]     = useState(0);
  const [checksumErrors, setChecksumErrors] = useState(0);
  const [viewerCount,    setViewerCount]    = useState(0); // how many are watching

  const wfCanvasRef  = useRef(null);
  const barCanvasRef = useRef(null);
  const wfBufRef     = useRef(new Float32Array(WATERFALL_ROWS * NUM_BINS));
  const headRef      = useRef(0);
  const peakRef      = useRef(1);
  const portRef      = useRef(null);
  const readerRef    = useRef(null);
  const channelRef   = useRef(null);
  const lastBroadcast = useRef(0);
  const lastDbInsert  = useRef(0);

  const canvasRefs = { wfBufRef, headRef, peakRef, wfCanvasRef, barCanvasRef };

  // ── Supabase viewer subscription (always active when supabase is configured) ─
  useEffect(() => {
    if (!supabase) return;

    if (typeof navigator !== 'undefined' && !('serial' in navigator)) {
      setStatus('unsupported');
    }

    // Subscribe to incoming sweeps from whoever is hosting
    const channel = supabase
      .channel(CHANNEL_NAME, { config: { broadcast: { self: false } } })
      .on('broadcast', { event: 'sweep' }, (msg) => {
        // Only render if we are in viewer mode (not hosting ourselves)
        if (portRef.current) return; // host renders locally, skip
        const sweep = msg.payload;
        applySweep(sweep, canvasRefs);
        setStats({ rms: sweep.rms, result: sweep.result, flags: sweep.flags,
                   seq: sweep.seq, metric: sweep.metric });
        setSweepCount(sweep.sweep);
        setStatus('viewing');
      })
      .subscribe();

    channelRef.current = channel;
    return () => { supabase.removeChannel(channel); };
  }, []);

  // ── Connect (host mode) ───────────────────────────────────────────────────
  const connect = useCallback(async () => {
    if (!('serial' in navigator)) { setStatus('unsupported'); return; }
    setErrMsg('');
    try {
      const port = await navigator.serial.requestPort();
      await port.open({ baudRate: BAUD_RATE });
      portRef.current = port;
      setStatus('hosting');

      const minInterval = 1000 / BROADCAST_HZ;

      const parser = new UARTParser({
        onSweep: (sweep) => {
          // Always render locally (no latency)
          applySweep(sweep, canvasRefs);
          setStats({ rms: sweep.rms, result: sweep.result, flags: sweep.flags,
                     seq: sweep.seq, metric: sweep.metric });
          setSweepCount(sweep.sweep);
          setChecksumErrors(parser.checksumErrors);

          // Rate-limited broadcast to Supabase for viewers
          const now = Date.now();
          if (channelRef.current && now - lastBroadcast.current >= minInterval) {
            lastBroadcast.current = now;
            channelRef.current.send({
              type: 'broadcast',
              event: 'sweep',
              payload: sweep,
            });
          }

          // Rate-limited insert into spectrogram table for persistence
          const dbInterval = 1000 / DB_INSERT_HZ;
          if (supabase && now - lastDbInsert.current >= dbInterval) {
            lastDbInsert.current = now;
            supabase.from('spectrogram').insert({
              spectrum:    sweep.spectrum,
              rms:         sweep.rms,
              result:      sweep.result,
              flags:       sweep.flags,
              seq:         sweep.seq,
              metric:      sweep.metric,
              anomaly:     Boolean(sweep.flags & 0x02),
              fpga_active: Boolean(sweep.flags & 0x01),
              cnn_ran:     Boolean(sweep.flags & 0x04),
            });
          }
        },
        onRms: ({ rms, result, flags, seq, metric }) => {
          setStats({ rms, result, flags, seq, metric });
        },
      });

      const reader = port.readable.getReader();
      readerRef.current = reader;
      (async () => {
        try {
          while (true) {
            const { value, done } = await reader.read();
            if (done) break;
            parser.feed(value);
          }
        } catch (err) {
          if (err.name !== 'AbortError') {
            setErrMsg(err.message);
            setStatus('error');
          }
        } finally {
          reader.releaseLock();
          portRef.current = null;
          setStatus(s => s === 'hosting' ? 'idle' : s);
        }
      })();

    } catch (err) {
      if (err.name !== 'NotFoundError') {
        setErrMsg(err.message);
        setStatus('error');
      }
    }
  }, []);

  // ── Disconnect ────────────────────────────────────────────────────────────
  const disconnect = useCallback(async () => {
    try { readerRef.current?.cancel(); } catch {}
    try { await portRef.current?.close(); } catch {}
    portRef.current = null;
    readerRef.current = null;
    setStatus('idle');
  }, []);

  // ── Helpers ───────────────────────────────────────────────────────────────
  const fmtHex = (n, pad = 2) =>
    n == null ? '--' : '0x' + n.toString(16).toUpperCase().padStart(pad, '0');

  const isHosting  = status === 'hosting';
  const isViewing  = status === 'viewing';
  const isLive     = isHosting || isViewing;

  const modeBadge = isHosting ? 'HOST'
                  : isViewing ? 'VIEWER'
                  : status === 'unsupported' ? 'NOT SUPPORTED'
                  : 'DISCONNECTED';

  const supabaseOk = !!supabase;

  // ── CNN derived state ─────────────────────────────────────────────────────
  const CNN_THRESHOLD = 26;
  const flags      = stats?.flags ?? 0;
  const fpgaActive = stats ? Boolean(flags & 0x01) : null;
  const cnnAnomaly = stats ? Boolean(flags & 0x02) : null;
  const cnnRan     = stats ? Boolean(flags & 0x04) : null;
  const mae        = stats?.metric ?? null;

  // Classification label + colours
  let cnnLabel, cnnColor, cnnBg;
  if (!stats) {
    cnnLabel = '--';        cnnColor = 'var(--text-lo)';  cnnBg = 'transparent';
  } else if (!fpgaActive) {
    cnnLabel = 'FPGA OFF';  cnnColor = 'var(--text-lo)';  cnnBg = 'transparent';
  } else if (!cnnRan) {
    cnnLabel = 'PENDING';   cnnColor = 'var(--amber-lo)'; cnnBg = 'var(--amber-glow)';
  } else if (cnnAnomaly) {
    cnnLabel = 'ANOMALY';   cnnColor = 'var(--red-hi)';   cnnBg = 'var(--red-glow)';
  } else {
    cnnLabel = 'NOMINAL';   cnnColor = 'var(--green-hi)'; cnnBg = 'rgba(0,204,184,0.08)';
  }

  const maePct       = mae != null ? Math.min((mae / 255) * 100, 100) : 0;
  const thresholdPct = (CNN_THRESHOLD / 255) * 100;

  return (
    <div className="app">

      {/* ── Header ────────────────────────────────────────────────────────── */}
      <header className="header">
        <div>
          <div className="header-title">Spectrogram</div>
          <div className="header-sub">
            FPGA · 64-bin FFT · 0 – 23.4 kHz
            {isHosting && ' · broadcasting to all viewers'}
            {isViewing && ' · receiving live stream'}
          </div>
        </div>
        <div className="header-right">
          <Link href="/" className="spec-nav-link">← Dashboard</Link>
          <Link href="/info" className="spec-nav-link">About</Link>
          <div className={`live-pill ${isLive ? 'online' : ''}`}>
            <div className={`live-dot ${isLive ? 'on' : ''}`} />
            {modeBadge}
          </div>
          <button className="theme-toggle" onClick={toggleTheme} aria-label="Toggle theme">
            {isDark ? '☀️ Light' : '🌙 Dark'}
          </button>
        </div>
      </header>

      {/* ── Banners ───────────────────────────────────────────────────────── */}
      {status === 'unsupported' && (
        <div className="spec-banner" style={{ borderColor: 'var(--red)', color: 'var(--red-hi)' }}>
          Web Serial API is not supported in this browser — use <strong>Chrome</strong> or{' '}
          <strong>Edge</strong> on desktop to act as host.
          {supabaseOk && ' You can still view a live stream if another device is hosting.'}
        </div>
      )}
      {status === 'error' && (
        <div className="spec-banner" style={{ borderColor: 'var(--red)' }}>
          <span style={{ color: 'var(--red-hi)' }}>Serial error: </span>{errMsg}
        </div>
      )}
      {!supabaseOk && (
        <div className="spec-banner">
          Local-only mode — the cloud relay is off, so other devices cannot view this stream.
          Set <code className="spec-code">NEXT_PUBLIC_SUPABASE_ENABLED=true</code> (with the URL and
          anon-key vars) to re-enable multi-device sharing.
        </div>
      )}

      {/* ── Connect controls ──────────────────────────────────────────────── */}
      <div className="spec-controls">
        {!isHosting ? (
          <button
            className="spec-btn spec-btn-connect"
            onClick={connect}
            disabled={status === 'unsupported'}
          >
            ⬡ Connect via USB  {supabaseOk ? '(+ stream to viewers)' : '(local only)'}
          </button>
        ) : (
          <button className="spec-btn spec-btn-disconnect" onClick={disconnect}>
            ✕ Disconnect
          </button>
        )}
        {!isHosting && !isViewing && status !== 'unsupported' && (
          <span className="spec-hint">
            {supabaseOk
              ? 'HOST: plug in the device and click Connect — data streams to all open viewers automatically. VIEWER: just open this page on any device.'
              : 'Plug in the device via USB then click Connect. Baud rate is set to ' + BAUD_RATE.toLocaleString() + ' automatically.'}
          </span>
        )}
        {isViewing && (
          <span className="spec-hint" style={{ color: 'var(--amber)' }}>
            Receiving live stream from host — no USB required on this device.
          </span>
        )}
      </div>

      {/* ── CNN Status Card ───────────────────────────────────────────────── */}
      <div className="cnn-card" style={{ background: cnnBg, borderColor: cnnColor }}>

        {/* Left: classification verdict */}
        <div className="cnn-verdict">
          <div className="cnn-verdict-label">CNN CLASSIFICATION</div>
          <div className="cnn-verdict-value" style={{ color: cnnColor }}>
            {cnnLabel}
          </div>
          <div className="cnn-badges">
            <span className={`cnn-badge ${fpgaActive ? 'cnn-badge-ok' : 'cnn-badge-dim'}`}>
              FPGA {fpgaActive ? 'ACTIVE' : 'OFF'}
            </span>
            <span className={`cnn-badge ${cnnRan ? 'cnn-badge-ok' : 'cnn-badge-dim'}`}>
              CNN {cnnRan ? 'RAN' : 'PENDING'}
            </span>
            <span className={`cnn-badge ${cnnAnomaly ? 'cnn-badge-err' : cnnRan ? 'cnn-badge-ok' : 'cnn-badge-dim'}`}>
              {cnnAnomaly ? 'ANOMALY' : cnnRan ? 'NOMINAL' : '---'}
            </span>
          </div>
        </div>

        {/* Right: MAE score + bar */}
        <div className="cnn-mae">
          <div className="cnn-mae-header">
            <span className="cnn-mae-label">MAE SCORE</span>
            <span className="cnn-mae-value" style={{ color: cnnColor }}>
              {mae != null ? `${mae} / 255` : '-- / 255'}
            </span>
          </div>
          <div className="cnn-mae-track">
            {/* Filled bar */}
            <div className="cnn-mae-fill"
              style={{ width: `${maePct}%`, background: cnnColor, opacity: 0.85 }} />
            {/* Threshold marker */}
            <div className="cnn-mae-threshold" style={{ left: `${thresholdPct}%` }}>
              <div className="cnn-mae-threshold-line" />
              <div className="cnn-mae-threshold-label">{CNN_THRESHOLD}</div>
            </div>
          </div>
          <div className="cnn-mae-axis">
            <span>0</span>
            <span style={{ color: 'var(--amber)', fontSize: 10 }}>
              ← normal &nbsp; threshold: {CNN_THRESHOLD} &nbsp; anomaly →
            </span>
            <span>255</span>
          </div>
        </div>

      </div>

      {/* ── Secondary stats strip ─────────────────────────────────────────── */}
      <div className="spec-stats">
        {[
          ['RMS',    stats?.rms ?? '--'],
          ['Result', fmtHex(stats?.result)],
          ['Flags',  fmtHex(stats?.flags)],
          ['Seq',    fmtHex(stats?.seq)],
          ['Sweeps', sweepCount],
          ...(isHosting ? [['CRC Err', checksumErrors]] : []),
        ].map(([label, value]) => (
          <div className="spec-stat" key={label}>
            <div className="spec-stat-label">{label}</div>
            <div className="spec-stat-value"
              style={label === 'CRC Err' && checksumErrors > 0 ? { color: 'var(--red-hi)' } : {}}>
              {value}
            </div>
          </div>
        ))}
      </div>

      {/* ── Waterfall ─────────────────────────────────────────────────────── */}
      <div className="section">
        <div className="section-header">
          <span className="section-title">WATERFALL</span>
          <span className="section-meta">newest at top · {WATERFALL_ROWS} rows buffered</span>
        </div>
        <div className="spec-wf-wrap">
          <div className="spec-scale-bar" />
          <canvas ref={wfCanvasRef} width={NUM_BINS} height={WATERFALL_ROWS}
            className="spec-wf-canvas" />
        </div>
        <div className="spec-freq-axis">
          {FREQ_LABELS.map(({ bin, label }) => (
            <div key={bin} className="spec-freq-tick"
              style={{ left: `${(bin / (NUM_BINS - 1)) * 100}%` }}>{label}</div>
          ))}
        </div>
      </div>

      {/* ── Current spectrum ───────────────────────────────────────────────── */}
      <div className="section">
        <div className="section-header">
          <span className="section-title">CURRENT SPECTRUM</span>
          <span className="section-meta">64 bins · 0 – 23.4 kHz</span>
        </div>
        <div className="spec-bar-wrap">
          <canvas ref={barCanvasRef} width={640} height={100}
            className="spec-bar-canvas" />
        </div>
        <div className="spec-freq-axis">
          {FREQ_LABELS.map(({ bin, label }) => (
            <div key={bin} className="spec-freq-tick"
              style={{ left: `${(bin / (NUM_BINS - 1)) * 100}%` }}>{label}</div>
          ))}
        </div>
      </div>

    </div>
  );
}
