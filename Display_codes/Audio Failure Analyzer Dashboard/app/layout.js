import './globals.css';
import ThemeProvider from './ThemeProvider';

export const metadata = {
  title: 'Audio Failure Analyzer',
  description: 'Real-time telemetry for ESP32 acoustic anomaly detection',
  icons: {
    icon: '/favicon.ico',
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        {/* Runs synchronously before any paint — prevents theme flash on load */}
        <script dangerouslySetInnerHTML={{ __html: `
          (function(){
            var s = localStorage.getItem('theme-mode');
            var dark = s ? s === 'dark' : false;
            if (!dark) document.documentElement.setAttribute('data-theme','light');
          })();
        `}} />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Share+Tech+Mono&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  );
}
