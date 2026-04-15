# PowerShell script to run FFT simulation
# Usage: .\scripts\run_fft_simulation.ps1

param(
    [string]$VivadoPath = "C:\Xilinx\Vivado\2023.1\bin\vivado.bat"
)

# Color functions
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }

# Check Vivado installation
if (-not (Test-Path $VivadoPath)) {
    Write-Error "ERROR: Vivado not found at: $VivadoPath"
    Write-Info "Specify correct path with: -VivadoPath 'C:\Xilinx\Vivado\2023.2\bin\vivado.bat'"
    exit 1
}

# Setup paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$srcDir = Join-Path $projectRoot "src_main"
$tbDir = Join-Path $projectRoot "testbench"
$buildDir = "C:/fpga_build"
$simTcl = Join-Path $scriptDir "fft_simulate.tcl"

Write-Success "=================================="
Write-Success "FFT Testbench Simulation"
Write-Success "=================================="
Write-Info "Project root: $projectRoot"
Write-Info "Source dir: $srcDir"
Write-Info "Testbench dir: $tbDir"
Write-Info "Vivado: $VivadoPath"

# Check that testbench exists
if (-not (Test-Path (Join-Path $tbDir "fft_test.v"))) {
    Write-Error "ERROR: Testbench not found at $(Join-Path $tbDir 'fft_test.v')"
    exit 1
}

Write-Info "`nLaunching Vivado simulation..."

# Run Vivado in batch mode with TCL script
& $VivadoPath -mode batch `
    -source $simTcl `
    -tclargs $srcDir $tbDir $buildDir

if ($LASTEXITCODE -eq 0) {
    Write-Success "`nSimulation completed successfully!"
    Write-Info "Check output at: $buildDir/fft_sim"
    Write-Info "VCD waveform: $buildDir/fft_sim/fft_test.vcd"
    Write-Info "`nTo view waveforms:"
    Write-Info "  1. Open $buildDir/fft_sim/fft_test.vcd in GTKWave or similar"
    Write-Info "  2. Look for:"
    Write-Info "     - 'led' signal toggling (heartbeat)"
    Write-Info "     - FFT frame valid pulses"
    Write-Info "     - Peak at bin 28-29 (440 Hz input)"
} else {
    Write-Error "Simulation failed with exit code: $LASTEXITCODE"
    exit 1
}
