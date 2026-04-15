#!/bin/bash
# Script to run FFT testbench simulation
# Usage: ./run_simulation.sh
# Or on Windows: powershell -ExecutionPolicy Bypass -File run_simulation.ps1

# Set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="C:/fpga_build"
SRC_DIR="$PROJECT_ROOT/src_main"
TB_DIR="$PROJECT_ROOT/testbench"

echo "=================================="
echo "FFT Testbench Simulation"
echo "=================================="
echo "Script dir: $SCRIPT_DIR"
echo "Source dir: $SRC_DIR"
echo "Testbench dir: $TB_DIR"
echo "Build dir: $BUILD_DIR"

# Run Vivado simulation
vivado -mode batch -source "$SCRIPT_DIR/fft_simulate.tcl" \
    -tclargs "$SRC_DIR" "$TB_DIR" "$BUILD_DIR"
