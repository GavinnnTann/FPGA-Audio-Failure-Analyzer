'use client';

import { useState, useEffect, useMemo } from 'react';
import { createClient } from '@supabase/supabase-js';

// ── Supabase (handles missing env vars gracefully) ────────────────────────────
const SUPA_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPA_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const supabase = SUPA_URL && SUPA_KEY ? createClient(SUPA_URL, SUPA_KEY) : null;

// ── Utilities ─────────────────────────────────────────────────────────────────
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

  const tx = i  => PX + (i / (data.length - 1)) * (W - PX * 2);
  const ty = v  => PY + (1 - (v - minV) / range) * (H - PY * 2);

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
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
        <filter id="dot-glow" x="-100%" y="-100%" width="300%" height="300%">
          <feGaussianBlur in="SourceGraphic" stdDeviation="2.5" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      {/* Grid */}
      {gridYs.map(({ y }) => (
        <line key={y} x1={PX} y1={y} x2={W - PX} y2={y}
          stroke="#0a1e1e" strokeWidth="1" strokeDasharray="4 8" />
      ))}

      {/* Fill */}
      <polygon points={fill} fill="url(#fill-grad)" />

      {/* Line */}
      <polyline points={line} fill="none"
        stroke="#00ccb8" strokeWidth="1.8"
        vectorEffect="non-scaling-stroke"
        filter="url(#line-glow)" />

      {/* Anomaly dots */}
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

// ── Dashboard ─────────────────────────────────────────────────────────────────
export default function Dashboard() {
  const [rows,      setRows]      = useState([]);
  const [loading,   setLoading]   = useState(true);
  const [error,     setError]     = useState(null);
  const [isLive,    setIsLive]    = useState(false);
  const [newId,     setNewId]     = useState(null);
  const lastDataAt = useState(() => ({ current: null }))[0];

  // Recompute live status every 5 s — live only if data arrived within 60 s.
  useEffect(() => {
    const tick = () => {
      setIsLive(
        lastDataAt.current != null &&
        Date.now() - lastDataAt.current < 60_000
      );
    };
    const id = setInterval(tick, 5000);
    return () => clearInterval(id);
  }, [lastDataAt]);

  useEffect(() => {
    if (!supabase) {
      setError('Environment variables not set.\nAdd NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY.');
      setLoading(false);
      return;
    }

    // Initial fetch
    supabase
      .from('telemetry')
      .select('*')
      .order('inserted_at', { ascending: false })
      .limit(200)
      .then(({ data, error: err }) => {
        if (err) setError(err.message);
        else setRows(data ?? []);
        setLoading(false);
      });

    // Realtime
    const chan = supabase
      .channel('telemetry-stream')
      .on('postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'telemetry' },
        (payload) => {
          setRows(prev => [payload.new, ...prev].slice(0, 200));
          setNewId(payload.new.id);
          lastDataAt.current = Date.now();
          setIsLive(true);
          setTimeout(() => setNewId(null), 1000);
        }
      )
      .subscribe();

    return () => supabase.removeChannel(chan);
  }, []);

  const stats = useMemo(() => {
    if (!rows.length) return null;
    const total     = rows.length;
    const anomalies = rows.filter(r => r.anomaly).length;
    const maxRms    = Math.max(...rows.map(r => r.rms ?? 0));
    return {
      latest:    rows[0],
      total,
      anomalies,
      anomRate:  (anomalies / total) * 100,
      maxRms,
    };
  }, [rows]);

  // ── Loading / error ────────────────────────────────────────────────────────
  if (loading) return (
    <div className="state-center">
      <div className="state-title" style={{ color: 'var(--amber-lo)' }}>INITIALIZING</div>
      <div className="state-sub">Connecting to Supabase telemetry stream...</div>
    </div>
  );

  if (error) return (
    <div className="state-center">
      <div className="state-title" style={{ color: 'var(--red-hi)', animationDuration: '0.4s' }}>
        CONFIG ERROR
      </div>
      <div className="state-sub" style={{ whiteSpace: 'pre-line' }}>{error}</div>
    </div>
  );

  // ── Helpers ────────────────────────────────────────────────────────────────
  const l        = stats?.latest;
  const anomRate = stats?.anomRate ?? 0;
  const maxRms   = stats?.maxRms  ?? 1;
  const rmsRatio = Math.min(((l?.rms ?? 0) / maxRms) * 100, 100);

  return (
    <div className="app">

      {/* ── Header ────────────────────────────────────────────────────────── */}
      <header className="header">
        <div>
          <div className="header-title">Audio Failure Analyzer</div>
          <div className="header-sub">
            ESP32 · ILI9488 480×320 · FPGA Acoustic Anomaly Monitor
          </div>
        </div>
        <div className="header-right">
          <div className="header-stats">
            <div className="header-stat">
              <div className="header-stat-label">Packets</div>
              <div className="header-stat-value">{stats?.total ?? 0}</div>
            </div>
            <div className="header-stat">
              <div className="header-stat-label">Anomalies</div>
              <div className="header-stat-value" style={{ color: stats?.anomalies ? 'var(--red-hi)' : 'var(--green-hi)' }}>
                {stats?.anomalies ?? 0}
              </div>
            </div>
            <div className="header-stat">
              <div className="header-stat-label">Uptime</div>
              <div className="header-stat-value">{fmtUptime(l?.device_ms)}</div>
            </div>
            <div className="header-stat">
              <div className="header-stat-label">Last Seen</div>
              <div className="header-stat-value">{fmtTime(l?.inserted_at)}</div>
            </div>
          </div>
          <div className={`live-pill ${isLive ? 'online' : ''}`}>
            <div className={`live-dot ${isLive ? 'on' : ''}`} />
            {isLive ? 'LIVE' : 'NO DATA'}
          </div>
        </div>
      </header>

      {/* ── Metric cards ──────────────────────────────────────────────────── */}
      <div className="metrics-grid">

        {/* RMS */}
        <div className="card">
          <div className="card-label">Current RMS</div>
          <div className={`card-number ${l?.anomaly ? 'err' : 'ok'}`}>
            {l?.rms ?? '--'}
          </div>
          <div className="card-sub">
            Peak {maxRms} &nbsp;·&nbsp; Seq {fmtHex(l?.seq)}
          </div>
          <div className="card-bar">
            <div className={`card-bar-fill ${l?.anomaly ? 'fill-err' : 'fill-ok'}`}
              style={{ width: `${rmsRatio}%` }} />
          </div>
        </div>

        {/* Classification */}
        <div className={`card ${l?.anomaly ? 'card-alert' : ''}`}>
          <div className="card-label">Classification</div>
          <div className={`card-number ${l?.anomaly ? 'err' : 'ok'}`}>
            {l == null ? '--' : l.anomaly ? 'ANOMALY' : 'NOMINAL'}
          </div>
          <div className="card-sub">
            Result {fmtHex(l?.result)} &nbsp;·&nbsp; Flags {fmtHex(l?.flags)}
          </div>
        </div>

        {/* Anomaly rate */}
        <div className="card">
          <div className="card-label">Anomaly Rate</div>
          <div className={`card-number ${anomRate > 15 ? 'err' : anomRate > 0 ? '' : 'ok'}`}>
            {anomRate.toFixed(1)}%
          </div>
          <div className="card-sub">
            {stats?.anomalies ?? 0} events / {stats?.total ?? 0} packets
          </div>
          <div className="card-bar">
            <div className={`card-bar-fill ${anomRate > 15 ? 'fill-err' : ''}`}
              style={{ width: `${Math.min(anomRate, 100)}%` }} />
          </div>
        </div>

        {/* System */}
        <div className="card">
          <div className="card-label">System</div>
          <div className={`card-number ${l?.fpga_active ? 'ok' : 'dim'}`}>
            {l?.fpga_active ? 'ACTIVE' : l == null ? '--' : 'IDLE'}
          </div>
          <div className="card-sub" style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
            <span className={`badge ${l?.fpga_active ? 'badge-ok' : 'badge-dim'}`}>FPGA</span>
            <span className={`badge ${l?.cnn_ran ? 'badge-ok' : 'badge-dim'}`}>CNN</span>
            <span className="badge badge-dim">M {l?.metric ?? '--'}</span>
          </div>
        </div>

      </div>

      {/* ── RMS Timeline ──────────────────────────────────────────────────── */}
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

      {/* ── Telemetry feed ────────────────────────────────────────────────── */}
      <div className="section">
        <div className="section-header">
          <span className="section-title">TELEMETRY FEED</span>
          <span className="section-meta">Newest first · {rows.length} rows buffered</span>
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
                    NO DATA — WAITING FOR ESP32 PACKETS...
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
  );
}
