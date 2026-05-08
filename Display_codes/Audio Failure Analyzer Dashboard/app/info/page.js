'use client';

import Link from 'next/link';
import { useTheme } from '../ThemeProvider';

function Section({ title }) {
  return (
    <div className="info-section-title">{title}</div>
  );
}

function Body({ children }) {
  return <p className="info-body">{children}</p>;
}

function Divider() {
  return <div className="info-divider" />;
}

function Row({ label, value, accent }) {
  return (
    <div className="info-row">
      <span className="info-row-label">{label}</span>
      <span className="info-row-value" style={accent ? { color: 'var(--amber-hi)' } : {}}>
        {value}
      </span>
    </div>
  );
}

function Bullet({ children, color }) {
  return (
    <div className="info-bullet" style={color ? { color } : {}}>
      <span className="info-bullet-dot">▸</span>
      <span>{children}</span>
    </div>
  );
}

function Pipeline({ steps }) {
  return (
    <div className="info-pipeline">
      {steps.map(([stage, desc], i) => (
        <div className="info-pipeline-row" key={i}>
          <div className="info-pipeline-stage">{stage}</div>
          <div className="info-pipeline-arrow">→</div>
          <div className="info-pipeline-desc">{desc}</div>
        </div>
      ))}
    </div>
  );
}

function Code({ children }) {
  return <code className="info-code">{children}</code>;
}

export default function InfoPage() {
  const { isDark, toggleTheme } = useTheme();

  return (
    <div className="app">

      {/* ── Header ──────────────────────────────────────────────────────── */}
      <header className="header">
        <div>
          <div className="header-title">About</div>
          <div className="header-sub">
            Project overview · Hardware pipeline · Protocol reference · Creator
          </div>
        </div>
        <div className="header-right">
          <Link href="/" className="spec-nav-link">← Dashboard</Link>
          <Link href="/spectrogram" className="spec-nav-link">Spectrogram</Link>
          <button className="theme-toggle" onClick={toggleTheme} aria-label="Toggle theme">
            {isDark ? '☀️ Light' : '🌙 Dark'}
          </button>
        </div>
      </header>

      <div className="info-wrap">

        {/* ── Hero ──────────────────────────────────────────────────────── */}
        <div className="info-hero">
          <div className="info-hero-title">Audio Failure Analyzer</div>
          <div className="info-hero-sub">
            Real-time FPGA acoustic anomaly detection · CNN autoencoder · Live web telemetry
          </div>
        </div>

        <Divider />

        {/* ── Project & Course ──────────────────────────────────────────── */}
        <Section title="Project & Course" />
        <div className="info-rows">
          <Row label="Course"      value="SUTD-EPD 30.110  Digital Systems Laboratory" accent />
          <Row label="Instructor"  value="Prof Teo Tee Hui — Singapore University of Technology and Design" />
          <Row label="Creators"    value="Gavin Tan — Singapore University of Technology and Design" accent />
          <Row label=""            value="Eric Aleong — University of Waterloo, Mechatronics Engineering" accent />
          <Row label="Term"        value="Term 6 · Academic Year 2026" />
          <Row label="Repository"  value={
            <a href="https://github.com/GavinnnTann/FPGA-Audio-Failure-Analyzer"
               target="_blank" rel="noopener noreferrer" className="info-link">
              github.com/GavinnnTann/FPGA-Audio-Failure-Analyzer ↗
            </a>
          } />
        </div>

        <Divider />

        {/* ── Project Overview ──────────────────────────────────────────── */}
        <Section title="Project Overview" />
        <Body>
          This project implements an end-to-end acoustic anomaly detection pipeline on a Digilent
          CMOD A7-35T FPGA (Artix-7 xc7a35tcpg236-1). An INMP441 MEMS microphone streams I²S
          audio at 46 875 Hz. The FPGA computes a real-time 512-point FFT, condenses the result
          into 64 frequency bins, and feeds it through a CNN autoencoder synthesised with hls4ml.
          The autoencoder reconstructs the normal audio signature — the mean absolute error (MAE)
          between input and reconstruction is thresholded to classify audio as{' '}
          <span style={{ color: 'var(--green-hi)' }}>NORMAL</span> or{' '}
          <span style={{ color: 'var(--red-hi)' }}>ANOMALY</span>.
        </Body>
        <Body>
          Results are streamed over UART to an ESP32, which posts telemetry to Supabase over
          Wi-Fi. This webapp subscribes to the live data stream and renders it in real time — no
          page refresh required, accessible from any device on any browser.
        </Body>

        <Divider />

        {/* ── What This Webapp Does ─────────────────────────────────────── */}
        <Section title="What This Webapp Does" />
        <Body>
          The webapp has two main views, accessible from the navigation links in the header:
        </Body>
        <Bullet>
          <strong>Dashboard ( / )</strong> — Live telemetry from the ESP32. Shows current RMS
          amplitude, classification result, anomaly rate over the session, FPGA and CNN status
          flags, and a scrolling RMS timeline with anomaly events marked in red. All data arrives
          via Supabase Realtime — any number of devices can watch simultaneously.
        </Bullet>
        <Bullet>
          <strong>Spectrogram ( /spectrogram )</strong> — Real-time 64-bin waterfall and spectrum
          bar chart. On Chrome or Edge desktop, connect the FPGA directly via USB — the browser
          reads the serial port and renders the waterfall locally. The data is simultaneously
          broadcast over Supabase Realtime so phones and other devices can watch as viewers without
          needing a USB connection.
        </Bullet>

        <Divider />

        {/* ── Hardware Pipeline ─────────────────────────────────────────── */}
        <Section title="Hardware Pipeline" />
        <Pipeline steps={[
          ['INMP441 MEMS mic',     'I²S PDM → 24-bit PCM at 46 875 Hz (12 MHz BCLK ÷ 256)'],
          ['I²S Receiver',         'Captures left-channel 24-bit samples; top 16 bits forwarded'],
          ['Hann Window + FFT',    '512-point Xilinx xfft_1 v9.1 — pipelined streaming, 24-bit in / 34-bit out'],
          ['Magnitude + Downsamp', '34-bit complex → magnitude; every 4th of 256 bins → 64 output bins'],
          ['Ping-Pong Buffers',    'Double-buffer isolates FFT fill from CNN read at 100 MHz'],
          ['CNN Autoencoder',      'hls4ml 64-in × 64-out network; MAE scorer; result latched every frame'],
          ['UART Packetiser',      'Two frame types: 8-byte telemetry + 64 × 6-byte spectrogram burst at 1 Mbaud'],
          ['ESP32 Wi-Fi Upload',   'Parses UART on Core 1 · POSTs telemetry to Supabase REST on Core 0'],
          ['Supabase',             'Postgres + Realtime — stores telemetry rows, broadcasts spectrogram sweeps'],
          ['This Webapp',          'Next.js 14 · Supabase JS · Web Serial API · Vercel — live on any device'],
        ]} />

        <Divider />

        {/* ── UART Protocol ─────────────────────────────────────────────── */}
        <Section title="UART Protocol" />
        <Body>
          Baud rate 1 000 000 · 8N1 · Two output ports: J18 → USB (this viewer), N3 → ESP32.
          Checksum is XOR of all preceding bytes in the frame.
          Anomaly threshold: MAE ≥ 26 / 255 → ABNORMAL.
        </Body>
        <div className="info-protocol">
          <div className="info-proto-row">
            <span className="info-proto-type">Telemetry (8 bytes)</span>
            <Code>AA 55  result  rms  flags  seq  metric  checksum</Code>
          </div>
          <div className="info-proto-row">
            <span className="info-proto-type">Spectrum slice (6 bytes)</span>
            <Code>DD 77  bin_idx  bin_lo  bin_hi  checksum</Code>
          </div>
          <div className="info-proto-row">
            <span className="info-proto-type">Sweep</span>
            <Code>64 consecutive spectrum slices (bin 0 → 63) constitute one full sweep</Code>
          </div>
          <div className="info-proto-row">
            <span className="info-proto-type">Frequency axis</span>
            <Code>bin k → center freq = k × 4 × (46875 / 512) Hz · range 0 – 23.4 kHz</Code>
          </div>
        </div>

        <Divider />

        {/* ── Tech Stack ────────────────────────────────────────────────── */}
        <Section title="Tech Stack" />
        <div className="info-tags">
          {[
            'Artix-7 FPGA', 'Xilinx xfft_1 v9.1', 'hls4ml CNN',
            'INMP441 MEMS', 'ESP32 Arduino', 'LVGL 9.3',
            'ILI9488 480×320 TFT', 'Next.js 14', 'Supabase Realtime',
            'Web Serial API', 'Vercel', 'Python Tkinter',
          ].map(tag => (
            <span className="info-tag" key={tag}>{tag}</span>
          ))}
        </div>

        <Divider />

        {/* ── Footer ────────────────────────────────────────────────────── */}
        <div className="info-footer">
          SUTD-EPD Digital Systems Laboratory &nbsp;·&nbsp; Gavin Tan &nbsp;·&nbsp; 2026
        </div>

      </div>
    </div>
  );
}
