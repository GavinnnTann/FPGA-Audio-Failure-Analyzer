set moduleName conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 36
set C_modelName {conv_2d_cl<array<ap_fixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config6>}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ layer18_out int 64 regular {fifo 0 volatile }  }
	{ layer6_out int 64 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "layer18_out", "interface" : "fifo", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "layer6_out", "interface" : "fifo", "bitwidth" : 64, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 20
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ layer18_out_dout sc_in sc_lv 64 signal 0 } 
	{ layer18_out_empty_n sc_in sc_logic 1 signal 0 } 
	{ layer18_out_read sc_out sc_logic 1 signal 0 } 
	{ layer18_out_num_data_valid sc_in sc_lv 12 signal 0 } 
	{ layer18_out_fifo_cap sc_in sc_lv 12 signal 0 } 
	{ layer6_out_din sc_out sc_lv 64 signal 1 } 
	{ layer6_out_full_n sc_in sc_logic 1 signal 1 } 
	{ layer6_out_write sc_out sc_logic 1 signal 1 } 
	{ layer6_out_num_data_valid sc_in sc_lv 11 signal 1 } 
	{ layer6_out_fifo_cap sc_in sc_lv 11 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "layer18_out_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "layer18_out", "role": "dout" }} , 
 	{ "name": "layer18_out_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "layer18_out", "role": "empty_n" }} , 
 	{ "name": "layer18_out_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "layer18_out", "role": "read" }} , 
 	{ "name": "layer18_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "layer18_out", "role": "num_data_valid" }} , 
 	{ "name": "layer18_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "layer18_out", "role": "fifo_cap" }} , 
 	{ "name": "layer6_out_din", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "layer6_out", "role": "din" }} , 
 	{ "name": "layer6_out_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "layer6_out", "role": "full_n" }} , 
 	{ "name": "layer6_out_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "layer6_out", "role": "write" }} , 
 	{ "name": "layer6_out_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "layer6_out", "role": "num_data_valid" }} , 
 	{ "name": "layer6_out_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "layer6_out", "role": "fifo_cap" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "12", "13", "14"],
		"CDFG" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "3502", "EstimateLatencyMax" : "172278",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "1156", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer18_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer6_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer6_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "sX_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pX_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sY_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "outidx_i_i_i_i_204", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "w6", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "ReuseLoop", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state4"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state8"]}},
			{"Name" : "ReadInputWidth", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state3", "LastState" : ["ap_ST_fsm_state8"], "QuitState" : ["ap_ST_fsm_state8"], "PreState" : ["ap_ST_fsm_state2"], "PostState" : ["ap_ST_fsm_state2"], "OneDepthLoop" : "0", "OneStateBlock": ""}},
			{"Name" : "ReadInputHeight", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state8"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.outidx_i_i_i_i_204_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.w6_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Parent" : "0", "Child" : ["4", "5", "6", "7", "8", "9", "10", "11"],
		"CDFG" : "shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3_U", "Parent" : "3"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6_U", "Parent" : "3"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2_U", "Parent" : "3"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5_U", "Parent" : "3"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1_U", "Parent" : "3"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4_U", "Parent" : "3"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_U", "Parent" : "3"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_73_6_16_1_1_U101", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_16s_6s_22_1_1_U102", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sparsemux_9_2_16_1_1_U103", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s {
		layer18_out {Type I LastRead 2 FirstWrite -1}
		layer6_out {Type O LastRead -1 FirstWrite 7}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E {Type X LastRead -1 FirstWrite -1}
		sX_5 {Type IO LastRead -1 FirstWrite -1}
		pX_5 {Type IO LastRead -1 FirstWrite -1}
		sY_5 {Type IO LastRead -1 FirstWrite -1}
		pY_5 {Type IO LastRead -1 FirstWrite -1}
		outidx_i_i_i_i_204 {Type I LastRead -1 FirstWrite -1}
		w6 {Type I LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E {Type X LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "3502", "Max" : "172278"}
	, {"Name" : "Interval", "Min" : "3502", "Max" : "172278"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	layer18_out { ap_fifo {  { layer18_out_dout fifo_data_in 0 64 }  { layer18_out_empty_n fifo_status 0 1 }  { layer18_out_read fifo_port_we 1 1 }  { layer18_out_num_data_valid fifo_status_num_data_valid 0 12 }  { layer18_out_fifo_cap fifo_update 0 12 } } }
	layer6_out { ap_fifo {  { layer6_out_din fifo_data_in 1 64 }  { layer6_out_full_n fifo_status 0 1 }  { layer6_out_write fifo_port_we 1 1 }  { layer6_out_num_data_valid fifo_status_num_data_valid 0 11 }  { layer6_out_fifo_cap fifo_update 0 11 } } }
}
