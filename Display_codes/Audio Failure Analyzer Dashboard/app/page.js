'use client';

import { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { createClient } from '@supabase/supabase-js';
import Link from 'next/link';
import { useTheme } from './ThemeProvider';

// ── Supabase (optional cloud path) ────────────────────────────────────────────
// The Supabase project is currently switched off, so the cloud path is opt-in.
// Everything below is left intact — to bring it back, set
//   NEXT_PUBLIC_SUPABASE_ENABLED=true
// alongside the URL/anon-key vars (Vercel → Project Settings → Environment
// Variables) and redeploy. While it is off the dashboard runs entirely off the
// local USB / Web Serial feed and never blocks on a network round-trip.
const SUPA_ENABLED = process.env.NEXT_PUBLIC_SUPABASE_ENABLED === 'true';
const SUPA_URL = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
const SUPA_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY?.trim();
const supabase = SUPA_ENABLED && SUPA_URL && SUPA_KEY
  ? createClient(SUPA_URL, SUPA_KEY)
  : null;
const CLOUD_ON = !!supabase;
const CHANNEL_NAME = 'spectrogram-live';
const BROADCAST_HZ = 15;
const DB_INSERT_HZ  = 1;

// ── Constants ─────────────────────────────────────────────────────────────────
// Must match the ESP32 USB serial rate — Serial.begin(1000000) in src/main.cpp,
// which in turn matches kFpgaUartBaud so the FPGA stream is forwarded verbatim.
// A mismatch here reads pure garbage: no checksum validates and the parser
// silently resyncs forever, so the UI just sits at "NO DATA".
const BAUD_RATE      = 1_000_000;
const NUM_BINS       = 64;
const WATERFALL_ROWS = 128;
const SAMPLE_RATE    = 46875.0;
const BIN_SPACING    = SAMPLE_RATE / 512;
const CNN_THRESHOLD  = 26;

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

function drawWaterfall(canvas, buf, head, peak) {
  const ctx  = canvas.getContext('2d');
  const img  = ctx.createImageData(NUM_BINS, WATERFALL_ROWS);
  const pix  = img.data;
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

// ── Helpers ───────────────────────────────────────────────────────────────────
function fmtTime(iso) {
  if (!iso) return '--:--:--';
  return new Date(iso).toLocaleTimeString('en-US', {
    hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit',
  });
}

function fmtUptime(ms) {
  if (ms == null) return '--';
  const s = Math.floor(ms / 1000);
  const m = Math.floor(s / 60);
  const h = Math.floor(m / 60);
  if (h > 0) return `${h}h ${String(m % 60).padStart(2, '0')}m`;
  if (m > 0) return `${m}m ${String(s % 60).padStart(2, '0')}s`;
  return `${s}s`;
}

function fmtHex(n, pad = 2) {
  if (n == null) return '--';
  return '0x' + n.toString(16).toUpperCase().padStart(pad, '0');
}

// ── RMS Sparkline ─────────────────────────────────────────────────────────────
function RmsChart({ rows, maxRms }) {
  const data = useMemo(() => [...rows].reverse().slice(-140), [rows]);

  if (data.length < 2) {
    return <div className="chart-empty">AWAITING SIGNAL...</div>;
  }

  const W = 1200, H = 100, PX = 6, PY = 8;
  const vals  = data.map(r => r.rms ?? 0);
  const minV  = Math.min(...vals);
  const maxV  = Math.max(...vals);
  const range = Math.max(maxV - minV, 1);

  const tx = i => PX + (i / (data.length - 1)) * (W - PX * 2);
  const ty = v => PY + (1 - (v - minV) / range) * (H - PY * 2);

  const line = data.map((r, i) => `${tx(i).toFixed(1)},${ty(r.rms ?? 0).toFixed(1)}`).join(' ');
  const fill = `${PX},${H} ${line} ${W - PX},${H}`;

  const gridYs = [0.25, 0.5, 0.75].map(f => ({
    y: PY + (1 - f) * (H - PY * 2),
    label: Math.round(minV + f * range),
  }));

  return (
    <svg className="chart-svg" viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none">
      <defs>
        <linearGradient id="fill-grad" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%"   stopColor="#00ccb8" stopOpacity="0.28" />
          <stop offset="75%"  stopColor="#00ccb8" stopOpacity="0.05" />
          <stop offset="100%" stopColor="#00ccb8" stopOpacity="0" />
        </linearGradient>
        <filter id="line-glow" x="-5%" y="-40%" width="110%" height="180%">
          <feGaussianBlur in="SourceGraphic" stdDeviation="1.8" result="blur" />
          <feMerge><feMergeNode in="blur" /><feMergeNode in="SourceGraphic" /></feMerge>
        </filter>
        <filter id="dot-glow" x="-100%" y="-100%" width="300%" height="300%">
          <feGaussianBlur in="SourceGraphic" stdDeviation="2.5" result="blur" />
          <feMerge><feMergeNode in="blur" /><feMergeNode in="SourceGraphic" /></feMerge>
        </filter>
      </defs>

      {gridYs.map(({ y, label }) => (
        <g key={label}>
          <line x1={PX} y1={y} x2={W - PX} y2={y} stroke="rgba(0,204,184,0.06)" strokeWidth="1" />
          <text x={PX} y={y - 3} fill="rgba(0,204,184,0.3)" fontSize="10" fontFamily="monospace">{label}</text>
        </g>
      ))}

      <polygon points={fill} fill="url(#fill-grad)" />
      <polyline points={line} fill="none" stroke="#00ccb8" strokeWidth="1.5"
        vectorEffect="non-scaling-stroke" filter="url(#line-glow)" />

      {data.map((r, i) =>
        r.anomaly ? (
          <circle key={i}
            cx={tx(i)} cy={ty(r.rms ?? 0)} r="5"
            fill="#e83828" vectorEffect="non-scaling-stroke"
            filter="url(#dot-glow)" />
        ) : null
      )}
    </svg>
  );
}

// ── Combined Dashboard + Spectrogram Page ─────────────────────────────────────
export default function MainPage() {
  const { isDark, toggleTheme } = useTheme();

  // ── Mobile tab ──────────────────────────────────────────────────────────────
  const [activeTab, setActiveTab] = useState('dashboard');

  // ── Dashboard state ─────────────────────────────────────────────────────────
  const [rows,    setRows]    = useState([]);
  // Only the cloud path has anything to load; with it off we start ready.
  const [loading, setLoading] = useState(CLOUD_ON);
  // Cloud problems are advisory only — they never take the dashboard down.
  const [cloudErr, setCloudErr] = useState(null);
  const [isLive,  setIsLive]  = useState(false);
  const [newId,   setNewId]   = useState(null);
  const lastDataAt   = useRef(null);
  const lastViewerRow = useRef(0); // rate-limit for viewer-mode dashboard rows

  // ── Spectrogram state ───────────────────────────────────────────────────────
  const [serialStatus,   setSerialStatus]   = useState('idle');
  const [serialErr,      setSerialErr]      = useState('');
  const [stats,          setStats]          = useState(null);
  const [sweepCount,     setSweepCount]     = useState(0);
  const [checksumErrors, setChecksumErrors] = useState(0);

  // ── Canvas refs ──────────────────────────────────────────────────────────────
  const wfCanvasRef  = useRef(null);
  const barCanvasRef = useRef(null);
  const wfBufRef     = useRef(new Float32Array(WATERFALL_ROWS * NUM_BINS));
  const headRef      = useRef(0);
  const peakRef      = useRef(1);
  const canvasRefs   = { wfBufRef, headRef, peakRef, wfCanvasRef, barCanvasRef };

  // ── Serial + broadcast refs ──────────────────────────────────────────────────
  const portRef       = useRef(null);
  const readerRef     = useRef(null);
  const channelRef    = useRef(null);
  const lastBroadcast = useRef(0);
  const lastDbInsert  = useRef(0);

  // ── Live-status ticker ───────────────────────────────────────────────────────
  useEffect(() => {
    const id = setInterval(() => {
      setIsLive(lastDataAt.current != null && Date.now() - lastDataAt.current < 60_000);
    }, 5000);
    return () => clearInterval(id);
  }, []);

  // ── Supabase subscriptions ───────────────────────────────────────────────────
  useEffect(() => {
    if (typeof navigator !== 'undefined' && !('serial' in navigator)) {
      setSerialStatus('unsupported');
    }

    // Cloud path off — the dashboard runs on USB alone. Nothing to subscribe to.
    if (!supabase) {
      setLoading(false);
      return;
    }

    // Initial telemetry load — a failure here just means no history to backfill.
    supabase
      .from('telemetry')
      .select('*')
      .order('inserted_at', { ascending: false })
      .limit(200)
      .then(({ data, error: err }) => {
        if (err) setCloudErr(`History unavailable — ${err.message}`);
        else setRows(data ?? []);
        setLoading(false);
      }, (err) => {
        setCloudErr(`History unavailable — ${err?.message ?? 'cloud unreachable'}`);
        setLoading(false);
      });

    // ESP32 WiFi path — skipped when USB serial is active
    const telChan = supabase
      .channel('telemetry-stream')
      .on('postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'telemetry' },
        (payload) => {
          if (portRef.current) return; // USB is live; don't mix sources
          setRows(prev => [payload.new, ...prev].slice(0, 200));
          setNewId(payload.new.id);
          lastDataAt.current = Date.now();
          setIsLive(true);
          setTimeout(() => setNewId(null), 1000);
        }
      )
      .subscribe();

    // Spectrogram broadcast — viewer mode (another device is hosting via USB)
    const specChan = supabase
      .channel(CHANNEL_NAME, { config: { broadcast: { self: false } } })
      .on('broadcast', { event: 'sweep' }, (msg) => {
        if (portRef.current) return; // we are hosting locally; ignore echoes
        const sweep = msg.payload;

        // Update spectrogram display
        applySweep(sweep, canvasRefs);
        setStats({ rms: sweep.rms, result: sweep.result, flags: sweep.flags,
                   seq: sweep.seq, metric: sweep.metric });
        setSweepCount(sweep.sweep);
        setSerialStatus('viewing');

        // Update dashboard rows (rate-limited: max 2/sec)
        const now = Date.now();
        if (now - lastViewerRow.current >= 500) {
          lastViewerRow.current = now;
          const row = makeTelemetryRow(sweep, now);
          setRows(prev => [row, ...prev].slice(0, 200));
          setNewId(row.id);
          lastDataAt.current = now;
          setIsLive(true);
          setTimeout(() => setNewId(null), 1000);
        }
      })
      .subscribe((status, err) => {
        console.log('[spectrogram-live channel]', status);
        if (err) console.error('[spectrogram-live channel error]', err);
      });

    channelRef.current = specChan;

    return () => {
      supabase.removeChannel(telChan);
      supabase.removeChannel(specChan);
    };
  }, []);

  // ── Connect (host via USB) ───────────────────────────────────────────────────
  const connect = useCallback(async () => {
    if (!('serial' in navigator)) { setSerialStatus('unsupported'); return; }
    setSerialErr('');
    try {
      const port = await navigator.serial.requestPort();
      await port.open({ baudRate: BAUD_RATE });
      portRef.current = port;
      setSerialStatus('hosting');

      const minInterval = 1000 / BROADCAST_HZ;

      const parser = new UARTParser({
        onSweep: (sweep) => {
          // Update spectrogram display
          applySweep(sweep, canvasRefs);
          setStats({ rms: sweep.rms, result: sweep.result, flags: sweep.flags,
                     seq: sweep.seq, metric: sweep.metric });
          setSweepCount(sweep.sweep);
          setChecksumErrors(parser.checksumErrors);

          // Update dashboard rows directly (real-time, no WiFi lag)
          const now = Date.now();
          const row = makeTelemetryRow(sweep, now);
          setRows(prev => [row, ...prev].slice(0, 200));
          setNewId(row.id);
          lastDataAt.current = now;
          setIsLive(true);
          setTimeout(() => setNewId(null), 1000);

          // Broadcast to remote viewers (rate-limited)
          if (channelRef.current && now - lastBroadcast.current >= minInterval) {
            lastBroadcast.current = now;
            channelRef.current.send({
              type: 'broadcast',
              event: 'sweep',
              payload: sweep,
            }).then(status => {
              if (status !== 'ok') console.error('[broadcast]', status);
            });
          }

          // Persist spectrum to Supabase (rate-limited)
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
            }).then(({ error }) => {
              if (error) console.error('[spectrogram insert]', error.code, error.message);
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
            setSerialErr(err.message);
            setSerialStatus('error');
          }
        } finally {
          reader.releaseLock();
          portRef.current = null;
          setSerialStatus(s => s === 'hosting' ? 'idle' : s);
        }
      })();

    } catch (err) {
      if (err.name !== 'NotFoundError') {
        setSerialErr(err.message);
        setSerialStatus('error');
      }
    }
  }, []);

  // ── Disconnect ───────────────────────────────────────────────────────────────
  const disconnect = useCallback(async () => {
    try { readerRef.current?.cancel(); } catch {}
    try { await portRef.current?.close(); } catch {}
    portRef.current = null;
    readerRef.current = null;
    setSerialStatus('idle');
  }, []);

  // ── Derived: telemetry stats ──────────────────────────────────────────────────
  const telStats = useMemo(() => {
    if (!rows.length) return null;
    const total     = rows.length;
    const anomalies = rows.filter(r => r.anomaly).length;
    const maxRms    = Math.max(...rows.map(r => r.rms ?? 0));
    return { latest: rows[0], total, anomalies, anomRate: (anomalies / total) * 100, maxRms };
  }, [rows]);

  // ── Derived: CNN / spectrogram state ─────────────────────────────────────────
  const flags      = stats?.flags ?? 0;
  const fpgaActive = stats ? Boolean(flags & 0x01) : null;
  const cnnAnomaly = stats ? Boolean(flags & 0x02) : null;
  const cnnRan     = stats ? Boolean(flags & 0x04) : null;
  const mae        = stats?.metric ?? null;

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

  // ── Derived: serial mode labels ───────────────────────────────────────────────
  const isHosting   = serialStatus === 'hosting';
  const isViewing   = serialStatus === 'viewing';
  const isSerialOn  = isHosting || isViewing;
  const liveBadge   = isHosting ? 'LIVE (USB)' : isViewing ? 'LIVE (REMOTE)' : isLive ? 'LIVE' : 'NO DATA';
  const modeBadge   = isHosting ? 'HOST' : isViewing ? 'VIEWER'
                    : serialStatus === 'unsupported' ? 'NO SERIAL' : 'DISCONNECTED';

  const l        = telStats?.latest;
  const anomRate = telStats?.anomRate ?? 0;
  const maxRms   = telStats?.maxRms  ?? 1;
  const rmsRatio = Math.min(((l?.rms ?? 0) / maxRms) * 100, 100);

  // ── Loading ───────────────────────────────────────────────────────────────────
  // Only reachable with the cloud path on; USB-only mode renders immediately.
  if (loading) return (
    <div className="state-center">
      <div className="state-title" style={{ color: 'var(--amber-lo)' }}>INITIALIZING</div>
      <div className="state-sub">Connecting to Supabase telemetry stream...</div>
    </div>
  );

  return (
    <div className="app">

      {/* ── Header ──────────────────────────────────────────────────────────── */}
      <header className="header">
        <div>
          <div className="header-title">Audio Failure Analyzer</div>
          <div className="header-sub">
            ESP32 · ILI9488 480×320 · FPGA Acoustic Anomaly Monitor
            {isHosting && ' · streaming from USB'}
            {isViewing && ' · receiving remote stream'}
          </div>
        </div>
        <div className="header-right">
          <div className="header-stats">
            <div className="header-stat">
              <div className="header-stat-label">Packets</div>
              <div className="header-stat-value">{telStats?.total ?? 0}</div>
            </div>
            <div className="header-stat">
              <div className="header-stat-label">Anomalies</div>
              <div className="header-stat-value" style={{ color: telStats?.anomalies ? 'var(--red-hi)' : 'var(--green-hi)' }}>
                {telStats?.anomalies ?? 0}
              </div>
            </div>
            <div className="header-stat">
              <div className="header-stat-label">Last Seen</div>
              <div className="header-stat-value">{fmtTime(l?.inserted_at)}</div>
            </div>
          </div>
          <div className={`live-pill ${(isLive || isSerialOn) ? 'online' : ''}`}>
            <div className={`live-dot ${(isLive || isSerialOn) ? 'on' : ''}`} />
            {liveBadge}
          </div>
          {!isHosting ? (
            <button
              className="usb-btn"
              onClick={connect}
              disabled={serialStatus === 'unsupported'}
              title={serialStatus === 'unsupported'
                ? 'Web Serial not supported — use Chrome or Edge'
                : serialStatus === 'error' ? `Error: ${serialErr}` : 'Connect FPGA via USB'}>
              ⬡ {serialStatus === 'unsupported' ? 'USB N/A' : 'Connect USB'}
            </button>
          ) : (
            <button className="usb-btn usb-active" onClick={disconnect}>
              ✕ Disconnect USB
            </button>
          )}
          <Link href="/info" className="spec-nav-link">About</Link>
          <button className="theme-toggle" onClick={toggleTheme} aria-label="Toggle theme">
            {isDark ? '☀️ Light' : '🌙 Dark'}
          </button>
        </div>
      </header>

      {/* ── Cloud notice (advisory — never blocks the dashboard) ─────────────── */}
      {cloudErr && (
        <div className="spec-banner" style={{ borderColor: 'var(--amber)' }}>
          <span style={{ color: 'var(--amber-lo)' }}>Cloud offline: </span>{cloudErr}
          {' '}Live USB capture is unaffected.
        </div>
      )}

      {/* ── Mobile tab nav ──────────────────────────────────────────────────── */}
      <div className="tab-nav">
        <button className={`tab-btn ${activeTab === 'dashboard' ? 'active' : ''}`}
          onClick={() => setActiveTab('dashboard')}>
          Dashboard
        </button>
        <button className={`tab-btn ${activeTab === 'spectrogram' ? 'active' : ''}`}
          onClick={() => setActiveTab('spectrogram')}>
          Spectrogram {isSerialOn && '●'}
        </button>
      </div>

      {/* ── Split layout ────────────────────────────────────────────────────── */}
      <div className="split-layout">

        {/* ── LEFT: Dashboard ─────────────────────────────────────────────── */}
        <div className={`split-left ${activeTab !== 'dashboard' ? 'tab-hidden' : ''}`}>

          {/* Metric cards */}
          <div className="metrics-grid" style={{ marginTop: 20 }}>
            <div className="card">
              <div className="card-label">Current RMS</div>
              <div className={`card-number ${l?.anomaly ? 'err' : 'ok'}`}>{l?.rms ?? '--'}</div>
              <div className="card-sub">Peak {maxRms} &nbsp;·&nbsp; Seq {fmtHex(l?.seq)}</div>
              <div className="card-bar">
                <div className={`card-bar-fill ${l?.anomaly ? 'fill-err' : 'fill-ok'}`}
                  style={{ width: `${rmsRatio}%` }} />
              </div>
            </div>

            <div className={`card ${l?.anomaly ? 'card-alert' : ''}`}>
              <div className="card-label">Classification</div>
              <div className={`card-number-sm ${l?.anomaly ? 'err' : 'ok'}`}>
                {l == null ? '--' : l.anomaly ? 'ANOMALY' : 'NOMINAL'}
              </div>
              <div className="card-sub">Result {fmtHex(l?.result)} &nbsp;·&nbsp; Flags {fmtHex(l?.flags)}</div>
            </div>

            <div className="card">
              <div className="card-label">Anomaly Rate</div>
              <div className={`card-number ${anomRate > 15 ? 'err' : anomRate > 0 ? '' : 'ok'}`}>
                {anomRate.toFixed(1)}%
              </div>
              <div className="card-sub">{telStats?.anomalies ?? 0} events / {telStats?.total ?? 0} packets</div>
              <div className="card-bar">
                <div className={`card-bar-fill ${anomRate > 15 ? 'fill-err' : ''}`}
                  style={{ width: `${Math.min(anomRate, 100)}%` }} />
              </div>
            </div>

            <div className="card">
              <div className="card-label">System</div>
              <div className={`card-number-sm ${l?.fpga_active ? 'ok' : 'dim'}`}>
                {l?.fpga_active ? 'ACTIVE' : l == null ? '--' : 'IDLE'}
              </div>
              <div className="card-sub" style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
                <span className={`badge ${l?.fpga_active ? 'badge-ok' : 'badge-dim'}`}>FPGA</span>
                <span className={`badge ${l?.cnn_ran ? 'badge-ok' : 'badge-dim'}`}>CNN</span>
                <span className="badge badge-dim">M {l?.metric ?? '--'}</span>
              </div>
            </div>
          </div>

          {/* RMS Timeline */}
          <div className="section">
            <div className="section-header">
              <span className="section-title">RMS TIMELINE</span>
              <span className="section-meta">
                {Math.min(rows.length, 140)} readings &nbsp;·&nbsp;
                <span style={{ color: 'var(--red-hi)' }}>●</span> anomaly events
              </span>
            </div>
            <div className="chart-wrap">
              <RmsChart rows={rows} maxRms={maxRms} />
            </div>
          </div>

          {/* Telemetry feed */}
          <div className="section">
            <div className="section-header">
              <span className="section-title">TELEMETRY FEED</span>
              <span className="section-meta">
                Newest first · {rows.length} rows
                {isHosting && ' · from USB'}
                {isViewing && ' · from remote host'}
              </span>
            </div>
            <div className="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Time</th>
                    <th>Uptime</th>
                    <th>RMS</th>
                    <th>Status</th>
                    <th>Result</th>
                    <th>Seq</th>
                    <th>Metric</th>
                    <th>CNN</th>
                    <th>FPGA</th>
                    <th>Flags</th>
                  </tr>
                </thead>
                <tbody>
                  {rows.length === 0 && (
                    <tr>
                      <td colSpan={10} style={{ textAlign: 'center', padding: '40px', color: 'var(--text-lo)' }}>
                        {CLOUD_ON
                          ? 'NO DATA — Waiting for ESP32 (WiFi) or connect FPGA via USB on the Spectrogram tab...'
                          : 'NO DATA — Click "Connect USB" above to stream live from the FPGA.'}
                      </td>
                    </tr>
                  )}
                  {rows.map(row => (
                    <tr key={row.id}
                      className={[
                        row.anomaly      ? 'row-anomaly' : '',
                        row.id === newId ? 'row-new'     : '',
                      ].filter(Boolean).join(' ')}>
                      <td>{fmtTime(row.inserted_at)}</td>
                      <td style={{ color: 'var(--text-lo)' }}>{fmtUptime(row.device_ms)}</td>
                      <td>
                        <div className="rms-cell">
                          <span>{row.rms ?? '--'}</span>
                          <div className="rms-track">
                            <div className={`rms-fill ${row.anomaly ? 'hi' : ''}`}
                              style={{ width: `${Math.min(((row.rms ?? 0) / maxRms) * 100, 100)}%` }} />
                          </div>
                        </div>
                      </td>
                      <td>
                        <span className={`badge ${row.anomaly ? 'badge-err' : 'badge-ok'}`}>
                          {row.anomaly ? 'ANOMALY' : 'OK'}
                        </span>
                      </td>
                      <td style={{ color: 'var(--text-lo)' }}>{fmtHex(row.result)}</td>
                      <td style={{ color: 'var(--text-lo)' }}>{fmtHex(row.seq)}</td>
                      <td>{row.metric ?? '--'}</td>
                      <td>
                        <span className={`badge ${row.cnn_ran ? 'badge-ok' : 'badge-dim'}`}>
                          {row.cnn_ran ? 'RAN' : 'SKIP'}
                        </span>
                      </td>
                      <td>
                        <span className={`badge ${row.fpga_active ? 'badge-ok' : 'badge-dim'}`}>
                          {row.fpga_active ? 'ON' : 'OFF'}
                        </span>
                      </td>
                      <td style={{ color: 'var(--text-lo)' }}>{fmtHex(row.flags)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* ── RIGHT: Spectrogram ──────────────────────────────────────────── */}
        <div className={`split-right ${activeTab !== 'spectrogram' ? 'tab-hidden' : ''}`}>

          {/* CNN status card */}
          <div className="cnn-card" style={{ background: cnnBg, borderColor: cnnColor }}>
            <div className="cnn-verdict">
              <div className="cnn-verdict-label">CNN CLASSIFICATION</div>
              <div className="cnn-verdict-value" style={{ color: cnnColor }}>{cnnLabel}</div>
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
            <div className="cnn-mae">
              <div className="cnn-mae-header">
                <span className="cnn-mae-label">MAE SCORE</span>
                <span className="cnn-mae-value" style={{ color: cnnColor }}>
                  {mae != null ? `${mae} / 255` : '-- / 255'}
                </span>
              </div>
              <div className="cnn-mae-track">
                <div className="cnn-mae-fill" style={{ width: `${maePct}%`, background: cnnColor, opacity: 0.85 }} />
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

          {/* Stats strip */}
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

          {/* Waterfall */}
          <div className="section" style={{ marginTop: 16 }}>
            <div className="section-header">
              <span className="section-title">WATERFALL</span>
              <span className="section-meta">newest at top · {WATERFALL_ROWS} rows · 0 – 23.4 kHz</span>
            </div>
            <div style={{ padding: '12px 16px 4px' }}>
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
          </div>

          {/* Spectrum bar */}
          <div className="section">
            <div className="section-header">
              <span className="section-title">CURRENT SPECTRUM</span>
              <span className="section-meta">64 bins · 0 – 23.4 kHz</span>
            </div>
            <div style={{ padding: '12px 16px 4px' }}>
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

        </div>
      </div>
    </div>
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────
function makeTelemetryRow(sweep, now) {
  return {
    id:          `usb-${now}-${sweep.sweep}`,
    inserted_at: new Date(now).toISOString(),
    rms:         sweep.rms,
    result:      sweep.result,
    flags:       sweep.flags,
    seq:         sweep.seq,
    metric:      sweep.metric,
    device_ms:   null,
    anomaly:     Boolean(sweep.flags & 0x02),
    fpga_active: Boolean(sweep.flags & 0x01),
    cnn_ran:     Boolean(sweep.flags & 0x04),
  };
}
