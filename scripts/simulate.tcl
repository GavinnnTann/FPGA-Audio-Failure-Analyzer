# =============================================================================
# simulate.tcl — Vivado xsim batch simulation for all testbenches
#
# Runs every self-checking testbench using the Vivado xsim non-project flow:
#   xvlog  (compile Verilog sources)
#   xelab  (elaborate / link)
#   xsim   (simulate, -runall to let $finish exit)
#
# Usage (from build.ps1):
#   .\scripts\build.ps1 -Action simulate
#
# Or directly from Vivado Tcl console / batch mode:
#   vivado -mode batch -source scripts/simulate.tcl
# =============================================================================

set script_dir  [file dirname [file normalize [info script]]]
set root_dir    [file normalize "$script_dir/.."]
set src_dir     [file normalize "$root_dir/src_main"]
set tb_dir      [file normalize "$root_dir/testbench"]
set sim_dir     [file normalize "$root_dir/build/sim"]

file mkdir $sim_dir

# Optional: filter to a single testbench if passed via -tclargs
# e.g.  vivado -mode batch -source simulate.tcl -tclargs uart_tx_tb
set FILTER_TB ""
if {[llength $argv] > 0} {
    set FILTER_TB [lindex $argv 0]
    puts "Filtering to testbench: $FILTER_TB"
}

# ---------------------------------------------------------------------------
# Test suite: { testbench_top  { dut_src_file ... } }
# ---------------------------------------------------------------------------
set SUITES {
    { uart_tx_tb                { uart_tx.v } }
    { i2s_receiver_tb           { i2s_receiver.v } }
    { fft_feature_quantizer_tb  { fft_feature_quantizer.v } }
    { fft_magnitude_tb          { fft_magnitude.v } }
    { spectrogram_buffer_64x64_tb { spectrogram_buffer_64x64.v } }
    { fft_backpressure_tb       { fft_window_buffer.v } }
}

# ---------------------------------------------------------------------------
# Helper: run a shell command from a specific directory, return combined output
# ---------------------------------------------------------------------------
proc xrun_in {dir args} {
    set save [pwd]
    cd $dir
    if {[catch {set out [exec {*}$args 2>@1]} msg]} {
        cd $save
        return $msg
    }
    cd $save
    return $out
}
    }
    return $out
}

# ---------------------------------------------------------------------------
# Run each suite
# ---------------------------------------------------------------------------
set pass_count 0
set fail_count 0
set skip_count 0
set results {}

puts ""
puts "============================================================"
puts "  FPGA Acoustic Anomaly Detector — Vivado xsim Simulation"
puts "============================================================"
puts ""

foreach suite $SUITES {
    set tb_top   [lindex $suite 0]
    set dut_list [lindex $suite 1]

    # Skip if not the requested testbench
    if {$FILTER_TB ne "" && $tb_top ne $FILTER_TB} {
        continue
    }

    # Verify all source files exist
    set missing {}
    foreach dut $dut_list {
        set fp "$src_dir/$dut"
        if {![file exists $fp]} { lappend missing $fp }
    }
    set tb_file "$tb_dir/${tb_top}.v"
    if {![file exists $tb_file]} { lappend missing $tb_file }

    if {[llength $missing] > 0} {
        puts "SKIP  $tb_top — missing files: $missing"
        incr skip_count
        lappend results [list $tb_top SKIP "missing files"]
        continue
    }

    puts "--- $tb_top ---"
    set work_dir "$sim_dir/$tb_top"
    file mkdir $work_dir

    # Build source file list
    set src_files {}
    foreach dut $dut_list {
        lappend src_files "$src_dir/$dut"
    }
    lappend src_files $tb_file

    # ---- Compile (run from work_dir so xsim.dir is created there) ----
    set compile_out [xrun_in $work_dir xvlog -v 0 -work work {*}$src_files]
    if {[string match "*ERROR*" $compile_out] || [string match "*error*" $compile_out]} {
        puts "  COMPILE ERROR:"
        puts "  $compile_out"
        incr fail_count
        lappend results [list $tb_top COMPILE_ERROR $compile_out]
        puts ""
        continue
    }

    # ---- Elaborate only (no -R) — creates the simulation snapshot ----
    # Top is specified as work.<module> — xelab finds xsim.dir/work/ in cwd
    set elab_out [xrun_in $work_dir xelab -v 0 \
        work.$tb_top \
        -snapshot "${tb_top}_snap" \
        --debug none]
    if {[string match "*ERROR*" $elab_out]} {
        puts "  ELAB ERROR:"
        puts "  $elab_out"
        incr fail_count
        lappend results [list $tb_top ELAB_ERROR $elab_out]
        puts ""
        continue
    }

    # ---- Simulate: xsim --runall --nolog so $display output goes to stdout ----
    set sim_out [xrun_in $work_dir xsim "${tb_top}_snap" --runall --nolog]

    # Parse PASS/FAIL from output
    set n_pass [regexp -all {PASS} $sim_out]
    set n_fail [regexp -all {FAIL} $sim_out]
    set result_pass [string match "*RESULT: PASS*" $sim_out]
    set result_fail [string match "*RESULT: FAIL*" $sim_out]

    if {$result_pass} {
        puts "  RESULT: PASS  ($n_pass passed)"
        incr pass_count
        lappend results [list $tb_top PASS "$n_pass passed"]
    } elseif {$result_fail || $n_fail > 0} {
        puts "  RESULT: FAIL  ($n_fail failures)"
        # Print FAIL lines
        foreach line [split $sim_out "\n"] {
            if {[string match "*FAIL*" $line] && ![string match "*RESULT*" $line]} {
                puts "    $line"
            }
        }
        incr fail_count
        lappend results [list $tb_top FAIL "$n_fail failures"]
    } else {
        puts "  RESULT: UNKNOWN (no RESULT line in output)"
        puts "  --- output ---"
        puts $sim_out
        puts "  --------------"
        incr fail_count
        lappend results [list $tb_top UNKNOWN "no result line"]
    }
    puts ""
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
puts "============================================================"
puts "  SIMULATION SUMMARY"
puts "============================================================"
foreach r $results {
    set tb     [lindex $r 0]
    set status [lindex $r 1]
    set detail [lindex $r 2]
    puts [format "  %-38s  %s  (%s)" $tb $status $detail]
}
puts ""
puts "  Passed: $pass_count"
puts "  Failed: $fail_count"
puts "  Skipped: $skip_count"
puts "============================================================"

if {$fail_count > 0} {
    puts "\nSome tests FAILED. Review output above."
    exit 1
} else {
    puts "\nAll tests PASSED."
}
add_wave {{/reaction_game_tb/uut/elapsed_cs}}
add_wave {{/reaction_game_tb/uut/target_pattern}}
add_wave {{/reaction_game_tb/seg}}
add_wave {{/reaction_game_tb/hex}}

puts "\nKey signals added to waveform viewer"
puts "Use Vivado GUI to explore waveforms interactively"
