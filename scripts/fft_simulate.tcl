# Vivado simulation script for FFT testbench
# Runs behavioral simulation of the complete FFT pipeline with 440 Hz test signal

# Configuration
set PROJECT_NAME "fft_sim"
set PART_NAME "xc7a35tcpg236-1"

# Get paths from arguments or use defaults
set script_dir [file dirname [file normalize [info script]]]
if {[llength $argv] >= 3} {
    set src_dir [lindex $argv 0]
    set tb_dir [lindex $argv 1]
    set build_dir [lindex $argv 2]
} else {
    set src_dir [file normalize "$script_dir/../src_main"]
    set tb_dir [file normalize "$script_dir/../testbench"]
    set build_dir "C:/fpga_build"
}

# Create simulation project
set sim_dir "$build_dir/fft_sim"
file mkdir $sim_dir

puts "========================================"
puts "FFT Testbench Simulation Setup"
puts "========================================"
puts "Source dir:  $src_dir"
puts "Testbench dir: $tb_dir"
puts "Sim dir: $sim_dir"

create_project -force $PROJECT_NAME $sim_dir -part $PART_NAME

# Add FFT IP if available
set ip_repo_path [file normalize "$script_dir/../ip"]
if {[file exists $ip_repo_path]} {
    puts "Adding IP repository: $ip_repo_path"
    set_property ip_repo_paths [list $ip_repo_path] [current_project]
    update_ip_catalog
    
    set fft_xci_file [file normalize "$ip_repo_path/xfft_1/xfft_1.xci"]
    if {[file exists $fft_xci_file]} {
        add_files [list $fft_xci_file]
        puts "Added FFT IP core"
    }
}

# Add design source files
puts "\nAdding source files..."
foreach src_file {recorder_top.v i2s_receiver.v uart_tx.v fft_window_buffer.v fft_magnitude.v fft_frontend.v} {
    set full_path [file normalize "$src_dir/$src_file"]
    if {[file exists $full_path]} {
        add_files [list $full_path]
        puts "  ✓ $src_file"
    } else {
        puts "  ✗ NOT FOUND: $src_file"
    }
}

# Add Hann window coefficients
set mem_file [file normalize "$src_dir/hann_512_q15.mem"]
if {[file exists $mem_file]} {
    add_files [list $mem_file]
    puts "  ✓ hann_512_q15.mem"
}

# Add testbench
puts "\nAdding testbench files..."
set tb_file [file normalize "$tb_dir/fft_test.v"]
if {[file exists $tb_file]} {
    add_files -fileset sim_1 [list $tb_file]
    puts "  ✓ fft_test.v"
} else {
    puts "  ✗ NOT FOUND: fft_test.v"
    exit 1
}

# Set simulation top module
set_property top fft_test [get_fileset sim_1]
set_property top_lib xil_defaultlib [get_fileset sim_1]

# Generate IP cores
puts "\nGenerating IP cores..."
generate_target all [get_ips]

# Update compile order
update_compile_order -fileset sim_1

# Compile simulation
puts "\n========================================"
puts "Compiling Simulation"
puts "========================================"
compile_simlib -simulator xsim -simulator_language verilog -family artix7

# Create simulation fileset and compile it
set_property xelab.nosort true [get_fileset sim_1]
set_property xsim.simulate.runtime 100ms [get_fileset sim_1]

puts "\nCompiling design..."
set compile_cmd "xelab -prj [get_property name [get_fileset sim_1]].prj xil_defaultlib.fft_test -debug all 2>&1"

# Instead, use vivado simulation compile
catch {exec vivado -mode batch -source <(echo "cd $sim_dir; compile_simlib -simulator xsim -family artix7; reset_run sim_1 ; launch_simulation -simset sim_1 -mode behavioral") 2>@1} result

puts "\n========================================"
puts "Running Behavioral Simulation"
puts "========================================"

# Run simulation in batch mode using xsim directly
set xsim_proj_dir "$sim_dir/fft_sim.sim/sim_1/behav/xsim"
if {[file exists $xsim_proj_dir]} {
    puts "Found xsim project at: $xsim_proj_dir"
    cd $xsim_proj_dir
    
    # Run xsim with command file
    set cmd_file [open "xsim_run.tcl" w]
    puts $cmd_file "run 100ms"
    puts $cmd_file "exit"
    close $cmd_file
    
    catch {exec xsim fft_test -t xsim_run.tcl 2>@1} xsim_result
    puts "xsim result: $xsim_result"
} else {
    puts "Warning: xsim project directory not found, simulation may have compiled elsewhere"
}

# Check if VCD was generated
set vcd_file "$sim_dir/fft_test.vcd"
if {[file exists $vcd_file]} {
    puts "VCD file generated successfully: $vcd_file"
} else {
    puts "Note: VCD file not found at expected location"
    puts "Checking for waveform database files..."
    foreach wdb [glob -nocomplain -directory $sim_dir *.wdb] {
        puts "  Found: $wdb"
    }
}

# After simulation, summarize
puts "\n========================================"
puts "Simulation Complete!"
puts "========================================"
puts "Output directory: $sim_dir"
puts "\nExpected observations:"
puts "  1. FFT window accumulates 512 samples"
puts "  2. Converts to frequency domain (512-point FFT)"
puts "  3. Extracts magnitude and downsamples to 64 bins"
puts "  4. Spectrogram frame completes every ~65ms"
puts "  5. Peak FFT bin ≈ 28-29 for 440 Hz input"
