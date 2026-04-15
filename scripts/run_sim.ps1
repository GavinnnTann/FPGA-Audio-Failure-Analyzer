# Simple PowerShell script to run FFT simulation using xvlog/xelab/xsim

param([int]$SimTime = 100)

# Setup paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$srcDir = Join-Path $projectRoot "src_main"
$tbDir = Join-Path $projectRoot "testbench"
$vivadoPath = "C:\Xilinx\Vivado\2023.1\bin"

Write-Host "FFT Testbench Simulation (Batch Mode)" -ForegroundColor Cyan
Write-Host "====================================="
Write-Host "Source dir:    $srcDir"
Write-Host "Testbench dir: $tbDir"
Write-Host "Vivado path:   $vivadoPath"
Write-Host ""

# Create simulation directory
$simDir = "$projectRoot\fft_sim"
if (-not (Test-Path $simDir)) {
    New-Item -ItemType Directory -Path $simDir -Force | Out-Null
}

# Navigate to sim directory
Push-Location $simDir
Write-Host "Simulation directory: $simDir"

# Check if tools exist
$xvlog = "$vivadoPath\xvlog.bat"
$xelab = "$vivadoPath\xelab.bat"
$xsim = "$vivadoPath\xsim.bat"

if (-not (Test-Path $xvlog)) {
    Write-Host "ERROR: xvlog not found at $xvlog" -ForegroundColor Red
    Pop-Location
    exit 1
}

# List source files
$srcFiles = @(
    "$tbDir\fft_test_simple.v"
)

# Verify all files exist
Write-Host "Checking source files..."
$allExist = $true
foreach ($f in $srcFiles) {
    if (Test-Path $f) {
        Write-Host "  [OK] $(Split-Path $f -Leaf)"
    } else {
        Write-Host "  [MISSING] $f" -ForegroundColor Red
        $allExist = $false
    }
}

if (-not $allExist) {
    Write-Host "ERROR: Some source files missing" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Add .mem file if it exists (just for information, not compilation)
$memFile = "$srcDir\hann_512_q15.mem"
if (Test-Path $memFile) {
    Write-Host "  [OK] hann_512_q15.mem"
}

Write-Host ""
Write-Host "Step 1: Compiling Verilog..." -ForegroundColor Yellow
& $xvlog -work work -sv $srcFiles 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Compilation failed" -ForegroundColor Red
    Pop-Location
    exit 1
}
Write-Host "Compilation complete" -ForegroundColor Green

Write-Host ""
Write-Host "Step 2: Elaborating..." -ForegroundColor Yellow
& $xelab -debug all -top fft_test_simple fft_test_simple -s fft_test_sim 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Elaboration failed" -ForegroundColor Red
    Pop-Location
    exit 1
}
Write-Host "Elaboration complete" -ForegroundColor Green

Write-Host ""
Write-Host "Step 3: Running simulation (${SimTime}ms)..." -ForegroundColor Yellow

# Create TCL command file
$tclContent = "run ${SimTime}ms`nexit"
Set-Content -Path "xsim_run.tcl" -Value $tclContent

& $xsim fft_test_sim -t xsim_run.tcl -log xsim.log 2>&1

Write-Host "Simulation complete" -ForegroundColor Green

Write-Host ""
Write-Host "Output files:"
Write-Host "  $(Get-ChildItem -Filter '*.vcd' | ForEach-Object {$_.FullName})"
Write-Host "  $(Get-ChildItem -Filter '*.pb' | ForEach-Object {$_.FullName})"
Write-Host "  $(Get-ChildItem -Filter 'xsim.log' | ForEach-Object {$_.FullName})"

Pop-Location
Write-Host ""
Write-Host "Done!" -ForegroundColor Green
