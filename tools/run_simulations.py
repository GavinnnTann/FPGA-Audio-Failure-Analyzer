#!/usr/bin/env python3
"""
run_simulations.py
==================
Compiles and runs all self-checking Verilog testbenches and generates a
Markdown simulation report in the testbench/ folder.

Simulator auto-detection order:
  1. Icarus Verilog (iverilog / vvp) — install from https://steveicarus.github.io/iverilog/
  2. Vivado xsim    (xvlog / xelab)  — available if Vivado is on PATH

Usage:
    python tools/run_simulations.py           # from repo root
    python run_simulations.py                 # from testbench/ folder

Alternatively, run via the PowerShell build script (uses Vivado batch mode):
    .\scripts\build.ps1 -Action simulate
"""

import subprocess
import sys
import os
import re
import shutil
from datetime import datetime, timezone
from pathlib import Path

# ── Locate directories ───────────────────────────────────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT  = SCRIPT_DIR.parent if SCRIPT_DIR.name == "tools" else SCRIPT_DIR.parent
TB_DIR     = REPO_ROOT / "testbench"
SRC_DIR    = REPO_ROOT / "src_main"
REPORT_OUT = TB_DIR / "simulation_report.md"

# ── Test suite definition ─────────────────────────────────────────────────────
# Each entry: (testbench_file, [dut_source_files], description, [expected_tests])
SUITES = [
    (
        "uart_tx_tb.v",
        ["uart_tx.v"],
        "UART 8N1 Transmitter",
        [
            "Idle TX line is high",
            "0x55 serial frame (alternating bits)",
            "0xAA serial frame (complement pattern)",
            "0x00 serial frame (all-zero data)",
            "0xFF serial frame (all-one data)",
            "Back-to-back 3 bytes — 3 done pulses",
            "start ignored while busy",
        ],
    ),
    (
        "i2s_receiver_tb.v",
        ["i2s_receiver.v"],
        "I2S Receiver (INMP441)",
        [
            "Capture known sample 0xABCDEF",
            "Capture zero sample 0x000000",
            "Capture max positive 0x7FFFFF",
            "10 consecutive frames — valid pulse count",
            "Right-channel bits are discarded",
        ],
    ),
    (
        "fft_feature_quantizer_tb.v",
        ["fft_feature_quantizer.v"],
        "FFT Feature Quantizer (log2 companding)",
        [
            "Zero input → 0x00 special case",
            "Powers of two: 0x0001, 0x0002, 0x0004, 0x0080, 0x8000",
            "Non-power-of-two values (non-zero mantissa)",
            "Maximum 0xFFFF → 0xFF",
            "Monotonicity sweep (sampled every 256 steps)",
            "No spurious feature_valid when input idle",
        ],
    ),
    (
        "fft_magnitude_tb.v",
        ["fft_magnitude.v"],
        "FFT Magnitude (Alphamax+Betamax + bin downsampling)",
        [
            "Pure-real input → magnitude ≈ 0.96 × |real|",
            "Pure-imaginary input → same approximation",
            "Equal I/Q (45°) → Alphamax+Betamax formula",
            "Odd-indexed bins suppressed (downsampling)",
            "Every-4th bin passes (bins 0,4,8,…,252)",
            "Bins ≥ 256 suppressed (mirror half)",
            "spec_bin_index = fft_bin_index >> 2 for all 64 bins",
            "Large magnitude saturates to 0xFFFF",
            "Negative real/imaginary (abs-value) correct",
        ],
    ),
    (
        "spectrogram_buffer_64x64_tb.v",
        ["spectrogram_buffer_64x64.v"],
        "64×64 Spectrogram Buffer (BRAM staging)",
        [
            "Full frame (64 lines) → exactly 1 frame_complete pulse",
            "frame_id increments on each frame boundary",
            "Partial write (32 lines) → no frame_complete",
            "5 back-to-back frames → 5 pulses",
            "line_index==63 is the sole frame trigger",
            "frame_id wraps through 0xFF → 0x00",
        ],
    ),
    (
        "fft_backpressure_tb.v",
        ["fft_window_buffer.v"],
        "FFT Window Buffer (backpressure regression)",
        [
            "Fill ring buffer with 512 samples (Phase 1)",
            "Forced backpressure stalls during streaming (Phase 2)",
            "Frame continuity: FFT_N samples per frame",
            "Extended run: 2048 samples, periodic stalls (Phase 3)",
        ],
    ),
]

# ── Helpers ───────────────────────────────────────────────────────────────────

def find_simulator():
    """Return (backend, tools_dict) where backend is 'iverilog', 'xsim', or None."""
    iv = shutil.which("iverilog")
    vvp = shutil.which("vvp")
    if iv and vvp:
        return "iverilog", {"iverilog": iv, "vvp": vvp}

    xvlog = shutil.which("xvlog")
    xelab = shutil.which("xelab")
    xsim  = shutil.which("xsim")
    if xvlog and xelab and xsim:
        return "xsim", {"xvlog": xvlog, "xelab": xelab, "xsim": xsim}

    # Try common Vivado install paths on Windows
    for year in ["2024.1", "2023.2", "2023.1", "2022.2", "2022.1"]:
        base = Path(f"C:/Xilinx/Vivado/{year}/bin")
        xv = base / "xvlog.bat"
        xe = base / "xelab.bat"
        xs = base / "xsim.bat"
        if xv.exists() and xe.exists() and xs.exists():
            return "xsim", {"xvlog": str(xv), "xelab": str(xe), "xsim": str(xs)}

    return None, {}


def _parse_sim_output(stdout: str) -> dict:
    pass_count  = stdout.count("PASS")
    fail_count  = stdout.count("FAIL")
    result_pass = "RESULT: PASS" in stdout
    result_fail = "RESULT: FAIL" in stdout
    if result_pass:
        status = "PASS"
    elif result_fail or fail_count > 0:
        status = "FAIL"
    else:
        status = "UNKNOWN"
    fail_lines = [
        line.strip() for line in stdout.splitlines()
        if "FAIL" in line and "RESULT" not in line
    ]
    return {
        "status": status,
        "stdout": stdout,
        "stderr": "",
        "pass_count": pass_count,
        "fail_count": fail_count,
        "errors": fail_lines,
    }


def run_tb_iverilog(tb_file: Path, dut_files: list, sim_dir: Path) -> dict:
    out_bin = sim_dir / (tb_file.stem + ".vvp")
    compile_cmd = [
        "iverilog", "-g2001", "-Wall",
        "-o", str(out_bin), str(tb_file),
    ] + [str(f) for f in dut_files]
    cp = subprocess.run(compile_cmd, capture_output=True, text=True, timeout=60)
    if cp.returncode != 0:
        return {
            "status": "COMPILE_ERROR", "stdout": "", "stderr": cp.stderr,
            "pass_count": 0, "fail_count": 0, "errors": [cp.stderr.strip()],
        }
    rp = subprocess.run(["vvp", str(out_bin)], capture_output=True, text=True, timeout=300)
    return _parse_sim_output(rp.stdout)


def run_tb_xsim(tb_file: Path, dut_files: list, sim_dir: Path, tools: dict) -> dict:
    """Run one testbench using Vivado xvlog + xelab + xsim."""
    work_dir = sim_dir / tb_file.stem
    work_dir.mkdir(exist_ok=True)
    tb_top = tb_file.stem

    # Step 1: Compile — run from work_dir so xsim.dir/work/ is created there
    src_list = [str(f) for f in dut_files] + [str(tb_file)]
    cp = subprocess.run(
        [tools["xvlog"], "-v", "0", "-work", "work"] + src_list,
        capture_output=True, text=True, timeout=120, cwd=str(work_dir)
    )
    combined = cp.stdout + cp.stderr
    if cp.returncode != 0 or "ERROR" in combined.upper():
        return {
            "status": "COMPILE_ERROR", "stdout": combined, "stderr": cp.stderr,
            "pass_count": 0, "fail_count": 0, "errors": [combined[:400]],
        }

    # Step 2: Elaborate only (no -R) — creates the simulation snapshot
    ep = subprocess.run(
        [tools["xelab"], "-v", "0",
         f"work.{tb_top}",
         "-snapshot", f"{tb_top}_snap",
         "--debug", "none"],
        capture_output=True, text=True, timeout=120, cwd=str(work_dir)
    )
    if ep.returncode != 0:
        elab_out = ep.stdout + ep.stderr
        return {
            "status": "COMPILE_ERROR", "stdout": elab_out, "stderr": ep.stderr,
            "pass_count": 0, "fail_count": 0, "errors": [elab_out[:400]],
        }

    # Step 3: Simulate — xsim --runall --nolog so $display output goes to stdout
    sp = subprocess.run(
        [tools["xsim"], f"{tb_top}_snap", "--runall", "--nolog"],
        capture_output=True, text=True, timeout=600, cwd=str(work_dir)
    )
    out = sp.stdout + sp.stderr
    return _parse_sim_output(out)


def run_tb(tb_file: Path, dut_files: list, sim_dir: Path, backend: str, tools: dict) -> dict:
    if backend == "iverilog":
        return run_tb_iverilog(tb_file, dut_files, sim_dir)
    elif backend == "xsim":
        return run_tb_xsim(tb_file, dut_files, sim_dir, tools)
    return {"status": "SKIP", "stdout": "", "stderr": "",
            "pass_count": 0, "fail_count": 0, "errors": ["no simulator"]}


def badge(status: str) -> str:
    icons = {
        "PASS":          "✅ PASS",
        "FAIL":          "❌ FAIL",
        "COMPILE_ERROR": "🔴 COMPILE ERROR",
        "RUNTIME_ERROR": "🟠 RUNTIME ERROR",
        "SKIP":          "⏭ SKIPPED",
        "UNKNOWN":       "❓ UNKNOWN",
    }
    return icons.get(status, status)


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    backend, tools = find_simulator()
    have_tools = backend is not None

    if have_tools:
        print(f"Simulator: {backend} ({tools})")        
    else:
        print("No simulator found (tried iverilog, xvlog). Report will list expected tests.")

    sim_dir = TB_DIR / "_sim_output"
    if have_tools:
        sim_dir.mkdir(exist_ok=True)

    results = []
    total_pass = 0
    total_fail = 0
    total_skip = 0

    for tb_name, dut_names, description, expected_tests in SUITES:
        tb_path   = TB_DIR / tb_name
        dut_paths = [SRC_DIR / d for d in dut_names]

        if not tb_path.exists():
            results.append({
                "tb": tb_name, "desc": description,
                "expected": expected_tests,
                "result": {"status": "SKIP", "pass_count": 0, "fail_count": 0,
                           "errors": ["Testbench file not found"],
                           "stdout": "", "stderr": ""},
            })
            total_skip += 1
            continue

        missing_duts = [p for p in dut_paths if not p.exists()]
        if missing_duts:
            results.append({
                "tb": tb_name, "desc": description,
                "expected": expected_tests,
                "result": {"status": "SKIP", "pass_count": 0, "fail_count": 0,
                           "errors": [f"DUT not found: {p.name}" for p in missing_duts],
                           "stdout": "", "stderr": ""},
            })
            total_skip += 1
            continue

        if not have_tools:
            results.append({
                "tb": tb_name, "desc": description,
                "expected": expected_tests,
                "result": {"status": "SKIP", "pass_count": 0, "fail_count": 0,
                           "errors": ["no simulator on PATH (iverilog or xvlog/xelab)"],
                           "stdout": "", "stderr": ""},
            })
            total_skip += 1
            continue

        print(f"  Running {tb_name} ... ", end="", flush=True)
        try:
            res = run_tb(tb_path, dut_paths, sim_dir, backend, tools)
        except subprocess.TimeoutExpired:
            res = {"status": "RUNTIME_ERROR", "pass_count": 0, "fail_count": 0,
                   "errors": ["Simulation timed out"], "stdout": "", "stderr": ""}

        results.append({"tb": tb_name, "desc": description,
                        "expected": expected_tests, "result": res})
        print(res["status"])

        if res["status"] == "PASS":
            total_pass += 1
        else:
            total_fail += 1

    # ── Generate Markdown report ──────────────────────────────────────────────
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    lines = []
    lines.append("# FPGA Acoustic Anomaly Detector — Simulation Report")
    lines.append("")
    lines.append(f"**Generated:** {now}  ")
    sim_label = {
        "iverilog": "Icarus Verilog (iverilog + vvp)",
        "xsim":     "Vivado xsim (xvlog + xelab -R)",
    }.get(backend, "Not run — no simulator found on PATH")
    lines.append(f"**Simulator:** {sim_label}  ")
    lines.append(f"**Verilog standard:** 2001  ")
    lines.append("")

    # Summary table
    lines.append("## Summary")
    lines.append("")
    lines.append("| Module | Testbench | Status | Checks |")
    lines.append("|--------|-----------|--------|--------|")
    for r in results:
        res    = r["result"]
        status = badge(res["status"])
        checks = f"{res['pass_count']} passed" if res["status"] in ("PASS", "FAIL") else "—"
        if res["fail_count"] > 0:
            checks += f", {res['fail_count']} failed"
        lines.append(f"| {r['desc']} | `{r['tb']}` | {status} | {checks} |")
    lines.append("")

    skipped_note = f"  ({total_skip} skipped — files missing or no simulator)" if total_skip else ""
    if have_tools:
        lines.append(f"**Total:** {total_pass} passed, {total_fail} failed{skipped_note}")
    else:
        lines.append(
            "**Note:** No simulator found on PATH. Options:\n"
            "- Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog`)\n"
            "- Or use the Vivado build script: `.\\scripts\\build.ps1 -Action simulate`"
        )
    lines.append("")

    # Per-testbench details
    lines.append("---")
    lines.append("")
    lines.append("## Testbench Details")
    lines.append("")

    for r in results:
        res = r["result"]
        lines.append(f"### `{r['tb']}` — {r['desc']}")
        lines.append("")
        lines.append(f"**Status:** {badge(res['status'])}")
        lines.append("")
        lines.append("**Tests covered:**")
        lines.append("")
        for t in r["expected"]:
            lines.append(f"- {t}")
        lines.append("")

        if res["errors"]:
            lines.append("**Issues:**")
            lines.append("")
            lines.append("```")
            for e in res["errors"][:20]:
                lines.append(e)
            lines.append("```")
            lines.append("")

        if res["stdout"] and res["status"] not in ("SKIP",):
            lines.append("<details>")
            lines.append("<summary>Simulation output (click to expand)</summary>")
            lines.append("")
            lines.append("```")
            # Keep last 80 lines to avoid huge report
            out_lines = res["stdout"].splitlines()
            if len(out_lines) > 80:
                lines.append(f"... ({len(out_lines) - 80} lines truncated) ...")
            lines.append("\n".join(out_lines[-80:]))
            lines.append("```")
            lines.append("")
            lines.append("</details>")
            lines.append("")

    # Quick-start section
    lines.append("---")
    lines.append("")
    lines.append("## Running Simulations")
    lines.append("")
    lines.append("### Option 1: Vivado xsim (recommended — no extra install)")
    lines.append("")
    lines.append("```powershell")
    lines.append(".\\scripts\\build.ps1 -Action simulate")
    lines.append("```")
    lines.append("")
    lines.append("### Option 2: Icarus Verilog")
    lines.append("")
    lines.append("Install from https://steveicarus.github.io/iverilog/ then:")
    lines.append("")
    lines.append("```powershell")
    lines.append("# From repo root")
    for tb_name, dut_names, description, _ in SUITES:
        dut_args = " ".join(f"src_main/{d}" for d in dut_names)
        lines.append(f"# {description}")
        lines.append(f"iverilog -g2001 -o testbench/{tb_name.replace('.v','')}.vvp testbench/{tb_name} {dut_args}")
        lines.append(f"vvp testbench/{tb_name.replace('.v','')}.vvp")
        lines.append("")
    lines.append("```")
    lines.append("")
    lines.append("### Option 3: Re-run this script (auto-detects iverilog or xsim)")
    lines.append("")
    lines.append("```powershell")
    lines.append("python tools/run_simulations.py")
    lines.append("```")

    report_text = "\n".join(lines)
    REPORT_OUT.write_text(report_text, encoding="utf-8")
    print(f"\nReport written to: {REPORT_OUT}")

    # Exit with error code if any failures
    if total_fail > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
