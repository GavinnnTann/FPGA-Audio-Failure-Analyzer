'use client';

import { createContext, useContext, useEffect, useState } from 'react';

const ThemeContext = createContext();

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

export default function ThemeProvider({ children }) {
  const [mounted, setMounted] = useState(false);
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    const saved = localStorage.getItem('theme-mode');
    const dark = saved ? saved === 'dark' : false;

    setIsDark(dark);
    applyTheme(dark);
    setMounted(true);
  }, []);

  const applyTheme = (dark) => {
    const html = document.documentElement;
    if (dark) {
      html.removeAttribute('data-theme');
    } else {
      html.setAttribute('data-theme', 'light');
    }
    localStorage.setItem('theme-mode', dark ? 'dark' : 'light');
  };

  const toggleTheme = () => {
    const newDark = !isDark;
    setIsDark(newDark);
    applyTheme(newDark);
  };

  return (
    <ThemeContext.Provider value={{ isDark, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}
