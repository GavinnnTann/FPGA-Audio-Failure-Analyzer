#!/usr/bin/tclsh
# Vivado batch simulation script for FFT testbench

puts "=================================="
puts "FFT Testbench Simulation (Batch Mode)"
puts "=================================="

# Setup paths - these will be passed as arguments or use defaults
set script_dir [file dirname [file normalize [info script]]]
set src_dir [file normalize "$script_dir/../src_main"]
set tb_dir [file normalize "$script_dir/../testbench"]
set sim_dir [file normalize "$script_dir/../fft_sim"]

puts "Source dir:    $src_dir"
puts "Testbench dir: $tb_dir"
puts "Sim dir:       $sim_dir"

# Create simulation directory
file mkdir $sim_dir
cd $sim_dir

puts "\n[Step 1/4] Creating simulation project..."
create_project -force sim_project . -part xc7a35tcpg236-1

# Add source files
puts "\n[Step 2/4] Adding source files..."
set source_files [list \
    [file normalize "$src_dir/i2s_receiver.v"] \
    [file normalize "$src_dir/uart_tx.v"] \
    [file normalize "$src_dir/fft_window_buffer.v"] \
    [file normalize "$src_dir/fft_magnitude.v"] \
    [file normalize "$src_dir/fft_frontend.v"] \
    [file normalize "$src_dir/recorder_top.v"]
]
add_files $source_files

# Add testbench
add_files -fileset sim_1 [file normalize "$tb_dir/fft_test.v"]

# Add memory file
add_files [list [file normalize "$src_dir/hann_512_q15.mem"]]

puts "\n[Step 3/4] Generating IP cores..."
set_property ip_repo_paths [file normalize "$script_dir/../ip"] [current_project]
update_ip_catalog -rebuild

# Try to add FFT IP if available
set fft_xci_file [file normalize "$script_dir/../ip/xfft_1/xfft_1.xci"]
if {[file exists $fft_xci_file]} {
    puts "Adding FFT IP from: $fft_xci_file"
    add_files [list $fft_xci_file]
}

# Set simulation top
set_property top fft_test [get_fileset sim_1]

# Generate IP targets
catch {generate_target all [get_ips]} result
puts "IP generation result: $result"

# Update compile order
update_compile_order -fileset sim_1

# Configure simulation
set_property xsim.simulate.runtime 100ms [get_fileset sim_1]
set_property xelab.nosort true [get_fileset sim_1]

puts "\n[Step 4/4] Running simulation..."
puts "=================================="

# Run simulation non-interactively
set_property gui_state maximized [current_project]
launch_simulation -mode behavioral -simset sim_1 -of_objects [get_fileset sim_1]

# Exit gracefully
after 2000
exit 0
