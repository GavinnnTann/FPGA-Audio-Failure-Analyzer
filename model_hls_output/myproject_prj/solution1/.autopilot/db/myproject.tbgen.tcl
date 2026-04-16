set moduleName myproject
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
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
set C_modelName {myproject}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ input_4 int 8 regular {axi_s 0 volatile  { input_4 Data } }  }
	{ layer16_out int 8 regular {axi_s 1 volatile  { layer16_out Data } }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "input_4", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "layer16_out", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 12
set portList { 
	{ input_4_TDATA sc_in sc_lv 8 signal 0 } 
	{ layer16_out_TDATA sc_out sc_lv 8 signal 1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ input_4_TVALID sc_in sc_logic 1 invld 0 } 
	{ input_4_TREADY sc_out sc_logic 1 inacc 0 } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ layer16_out_TVALID sc_out sc_logic 1 outvld 1 } 
	{ layer16_out_TREADY sc_in sc_logic 1 outacc 1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
}
set NewPortList {[ 
	{ "name": "input_4_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "input_4", "role": "TDATA" }} , 
 	{ "name": "layer16_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "layer16_out", "role": "TDATA" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "input_4_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "input_4", "role": "TVALID" }} , 
 	{ "name": "input_4_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "input_4", "role": "TREADY" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "layer16_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "layer16_out", "role": "TVALID" }} , 
 	{ "name": "layer16_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "layer16_out", "role": "TREADY" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "9", "18", "20", "27", "34", "49", "51", "58", "65", "80", "82", "84", "91", "104", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134"],
		"CDFG" : "myproject",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "178534", "EstimateLatencyMax" : "178602",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "1", "Name" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0"}],
		"OutputProcess" : [
			{"ID" : "104", "Name" : "relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0"}],
		"Port" : [
			{"Name" : "input_4", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0", "Port" : "input_4"}]},
			{"Name" : "layer16_out", "Type" : "Axis", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "104", "SubInstance" : "relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0", "Port" : "layer16_out"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig"}]},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1"}]},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer"}]},
			{"Name" : "sX_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "sX_2"}]},
			{"Name" : "pX_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "pX_2"}]},
			{"Name" : "sY_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "sY_2"}]},
			{"Name" : "pY_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "pY_2"}]},
			{"Name" : "outidx_i_i_i_i", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "outidx_i_i_i_i"}]},
			{"Name" : "w2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "9", "SubInstance" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Port" : "w2"}]},
			{"Name" : "sY", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "sY"}]},
			{"Name" : "pY", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "pY"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap"}]},
			{"Name" : "pX", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "pX"}]},
			{"Name" : "sX", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "sX"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "20", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E"}]},
			{"Name" : "sX_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "sX_5"}]},
			{"Name" : "pX_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "pX_5"}]},
			{"Name" : "sY_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "sY_5"}]},
			{"Name" : "pY_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "pY_5"}]},
			{"Name" : "outidx_i_i_i_i_204", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "outidx_i_i_i_i_204"}]},
			{"Name" : "w6", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Port" : "w6"}]},
			{"Name" : "sY_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "sY_1"}]},
			{"Name" : "pY_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "pY_1"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap"}]},
			{"Name" : "pX_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "pX_1"}]},
			{"Name" : "sX_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "sX_1"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "51", "SubInstance" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8"}]},
			{"Name" : "sX_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "sX_4"}]},
			{"Name" : "pX_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "pX_4"}]},
			{"Name" : "sY_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "sY_4"}]},
			{"Name" : "pY_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "pY_4"}]},
			{"Name" : "outidx_i_i_i_i_222", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "outidx_i_i_i_i_222"}]},
			{"Name" : "w10", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "65", "SubInstance" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Port" : "w10"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E"}]},
			{"Name" : "sX_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "sX_3"}]},
			{"Name" : "pX_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "pX_3"}]},
			{"Name" : "sY_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "sY_3"}]},
			{"Name" : "pY_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "pY_3"}]},
			{"Name" : "w14", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "91", "SubInstance" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Port" : "w14"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0", "Parent" : "0", "Child" : ["2", "4", "6", "8"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4367", "EstimateLatencyMax" : "4367",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "input_4", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain_fu_34", "Port" : "input_4", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "layer17_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["9"], "DependentChan" : "107", "DependentChanDepth" : "4356", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth_fu_28", "Port" : "layer17_out", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "4", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain_fu_34", "Port" : "layer17_out", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "6", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth_fu_42", "Port" : "layer17_out", "Inst_start_state" : "5", "Inst_end_state" : "6"}]}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth_fu_28", "Parent" : "1", "Child" : ["3"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "68", "EstimateLatencyMax" : "68",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer17_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer17_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadTopWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "3", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth_fu_28.flow_control_loop_pipe_sequential_init_U", "Parent" : "2"},
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain_fu_34", "Parent" : "1", "Child" : ["5"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4226", "EstimateLatencyMax" : "4226",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer17_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer17_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "input_4", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "input_4_TDATA_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadMain", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "66", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "5", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain_fu_34.flow_control_loop_pipe_sequential_init_U", "Parent" : "4"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth_fu_42", "Parent" : "1", "Child" : ["7"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "68", "EstimateLatencyMax" : "68",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer17_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer17_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadBottomWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "7", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.grp_zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth_fu_42.flow_control_loop_pipe_sequential_init_U", "Parent" : "6"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0.regslice_both_input_4_U", "Parent" : "1"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0", "Parent" : "0", "Child" : ["10", "11", "12", "15", "16", "17"],
		"CDFG" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "13068", "EstimateLatencyMax" : "178596",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "1",
		"StartFifo" : "start_for_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0_U",
		"Port" : [
			{"Name" : "layer17_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["1"], "DependentChan" : "107", "DependentChanDepth" : "4356", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer17_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer2_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["18"], "DependentChan" : "108", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer2_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "12", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Port" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "sX_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pX_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sY_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "outidx_i_i_i_i", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "w2", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "ReuseLoop", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state3"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state7"]}},
			{"Name" : "ReadInputHeight_ReadInputWidth", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state7"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.outidx_i_i_i_i_U", "Parent" : "9"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.w2_U", "Parent" : "9"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275", "Parent" : "9", "Child" : ["13", "14"],
		"CDFG" : "shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s",
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
			{"Name" : "in_elem_0_0_0_0_0_val", "Type" : "None", "Direction" : "I"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "13", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275.void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1_U", "Parent" : "12"},
	{"ID" : "14", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275.void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_U", "Parent" : "12"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.sparsemux_19_4_8_1_1_U19", "Parent" : "9"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.mul_8s_8ns_16_1_1_U20", "Parent" : "9"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0.sparsemux_9_2_16_1_1_U21", "Parent" : "9"},
	{"ID" : "18", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0", "Parent" : "0", "Child" : ["19"],
		"CDFG" : "relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4098", "EstimateLatencyMax" : "4098",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "9",
		"StartFifo" : "start_for_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0_U",
		"Port" : [
			{"Name" : "layer2_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["9"], "DependentChan" : "108", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer2_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer4_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["20"], "DependentChan" : "109", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer4_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "ReLUActLoop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0.flow_control_loop_pipe_U", "Parent" : "18"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0", "Parent" : "0", "Child" : ["21", "26"],
		"CDFG" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "8195", "EstimateLatencyMax" : "8195",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "18",
		"StartFifo" : "start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configQgW_U",
		"Port" : [
			{"Name" : "layer4_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["18"], "DependentChan" : "109", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer4_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer5_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["27"], "DependentChan" : "110", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer5_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "sY", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "pX", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sX", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "21", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer", "Inst_start_state" : "2", "Inst_end_state" : "2"}]}],
		"Loop" : [
			{"Name" : "ReadInputHeight_ReadInputWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage1", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage1_subdone", "QuitState" : "ap_ST_fsm_pp0_stage1", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage1_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140", "Parent" : "20", "Child" : ["22", "23", "24", "25"],
		"CDFG" : "shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "22", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3_U", "Parent" : "21"},
	{"ID" : "23", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2_U", "Parent" : "21"},
	{"ID" : "24", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1_U", "Parent" : "21"},
	{"ID" : "25", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_U", "Parent" : "21"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0.flow_control_loop_pipe_U", "Parent" : "20"},
	{"ID" : "27", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0", "Parent" : "0", "Child" : ["28", "30", "32"],
		"CDFG" : "zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1167", "EstimateLatencyMax" : "1167",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "20",
		"StartFifo" : "start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Rg6_U",
		"Port" : [
			{"Name" : "layer5_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["20"], "DependentChan" : "110", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "30", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain_fu_28", "Port" : "layer5_out", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["34"], "DependentChan" : "111", "DependentChanDepth" : "1156", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "28", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth_fu_22", "Port" : "layer18_out", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "30", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain_fu_28", "Port" : "layer18_out", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "32", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth_fu_36", "Port" : "layer18_out", "Inst_start_state" : "5", "Inst_end_state" : "6"}]}]},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth_fu_22", "Parent" : "27", "Child" : ["29"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "36", "EstimateLatencyMax" : "36",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer18_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadTopWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "29", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth_fu_22.flow_control_loop_pipe_sequential_init_U", "Parent" : "28"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain_fu_28", "Parent" : "27", "Child" : ["31"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1090", "EstimateLatencyMax" : "1090",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer18_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer5_out", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "layer5_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadMain", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "34", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain_fu_28.flow_control_loop_pipe_sequential_init_U", "Parent" : "30"},
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth_fu_36", "Parent" : "27", "Child" : ["33"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "36", "EstimateLatencyMax" : "36",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer18_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadBottomWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0.grp_zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth_fu_36.flow_control_loop_pipe_sequential_init_U", "Parent" : "32"},
	{"ID" : "34", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0", "Parent" : "0", "Child" : ["35", "36", "37", "46", "47", "48"],
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
		"StartSource" : "27",
		"StartFifo" : "start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0_U",
		"Port" : [
			{"Name" : "layer18_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["27"], "DependentChan" : "111", "DependentChanDepth" : "1156", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer18_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer6_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["49"], "DependentChan" : "112", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer6_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_34", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_38", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_33", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_37", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_32", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_36", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_31", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_35", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_19", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_23", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_18", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_22", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_17", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_21", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_16", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_20", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_11", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_10", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_8", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_30", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_29", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_25", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_24", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_15", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_14", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_13", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_12", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "37", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
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
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.outidx_i_i_i_i_204_U", "Parent" : "34"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.w6_U", "Parent" : "34"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411", "Parent" : "34", "Child" : ["38", "39", "40", "41", "42", "43", "44", "45"],
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
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_7_U", "Parent" : "37"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_3_U", "Parent" : "37"},
	{"ID" : "40", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_6_U", "Parent" : "37"},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_2_U", "Parent" : "37"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_5_U", "Parent" : "37"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_1_U", "Parent" : "37"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_4_U", "Parent" : "37"},
	{"ID" : "45", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_U", "Parent" : "37"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.sparsemux_73_6_16_1_1_U101", "Parent" : "34"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.mul_16s_6s_22_1_1_U102", "Parent" : "34"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0.sparsemux_9_2_16_1_1_U103", "Parent" : "34"},
	{"ID" : "49", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0", "Parent" : "0", "Child" : ["50"],
		"CDFG" : "relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "1026", "EstimateLatencyMax" : "1026",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "34",
		"StartFifo" : "start_for_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0_U",
		"Port" : [
			{"Name" : "layer6_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["34"], "DependentChan" : "112", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer6_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer8_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["51"], "DependentChan" : "113", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer8_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "ReLUActLoop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0.flow_control_loop_pipe_U", "Parent" : "49"},
	{"ID" : "51", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0", "Parent" : "0", "Child" : ["52", "57"],
		"CDFG" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "2051", "EstimateLatencyMax" : "2051",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "49",
		"StartFifo" : "start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configShg_U",
		"Port" : [
			{"Name" : "layer8_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["49"], "DependentChan" : "113", "DependentChanDepth" : "1024", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer8_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer9_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["58"], "DependentChan" : "114", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer9_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "sY_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "pX_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sX_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5", "Inst_start_state" : "2", "Inst_end_state" : "2"}]},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "52", "SubInstance" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Port" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4", "Inst_start_state" : "2", "Inst_end_state" : "2"}]}],
		"Loop" : [
			{"Name" : "ReadInputHeight_ReadInputWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "2", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage1", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage1_subdone", "QuitState" : "ap_ST_fsm_pp0_stage1", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage1_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142", "Parent" : "51", "Child" : ["53", "54", "55", "56"],
		"CDFG" : "shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "1",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "53", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7_U", "Parent" : "52"},
	{"ID" : "54", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6_U", "Parent" : "52"},
	{"ID" : "55", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5_U", "Parent" : "52"},
	{"ID" : "56", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4_U", "Parent" : "52"},
	{"ID" : "57", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0.flow_control_loop_pipe_U", "Parent" : "51"},
	{"ID" : "58", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0", "Parent" : "0", "Child" : ["59", "61", "63"],
		"CDFG" : "zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "335", "EstimateLatencyMax" : "335",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "51",
		"StartFifo" : "start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Thq_U",
		"Port" : [
			{"Name" : "layer9_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["51"], "DependentChan" : "114", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "61", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain_fu_28", "Port" : "layer9_out", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "layer19_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["65"], "DependentChan" : "115", "DependentChanDepth" : "324", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "59", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth_fu_22", "Port" : "layer19_out", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "61", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain_fu_28", "Port" : "layer19_out", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "63", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth_fu_36", "Port" : "layer19_out", "Inst_start_state" : "5", "Inst_end_state" : "6"}]}]},
	{"ID" : "59", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth_fu_22", "Parent" : "58", "Child" : ["60"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "20", "EstimateLatencyMax" : "20",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer19_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer19_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadTopWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "60", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth_fu_22.flow_control_loop_pipe_sequential_init_U", "Parent" : "59"},
	{"ID" : "61", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain_fu_28", "Parent" : "58", "Child" : ["62"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "290", "EstimateLatencyMax" : "290",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer19_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer19_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer9_out", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "layer9_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadMain", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "18", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "62", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain_fu_28.flow_control_loop_pipe_sequential_init_U", "Parent" : "61"},
	{"ID" : "63", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth_fu_36", "Parent" : "58", "Child" : ["64"],
		"CDFG" : "zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "20", "EstimateLatencyMax" : "20",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer19_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer19_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadBottomWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "64", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0.grp_zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth_fu_36.flow_control_loop_pipe_sequential_init_U", "Parent" : "63"},
	{"ID" : "65", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0", "Parent" : "0", "Child" : ["66", "67", "68", "77", "78", "79"],
		"CDFG" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "990", "EstimateLatencyMax" : "48294",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "58",
		"StartFifo" : "start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0_U",
		"Port" : [
			{"Name" : "layer19_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["58"], "DependentChan" : "115", "DependentChanDepth" : "324", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer19_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer10_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["80"], "DependentChan" : "116", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer10_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "68", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "sX_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pX_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sY_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "outidx_i_i_i_i_222", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "w10", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "ReuseLoop", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state4"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state8"]}},
			{"Name" : "ReadInputWidth", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state3", "LastState" : ["ap_ST_fsm_state8"], "QuitState" : ["ap_ST_fsm_state8"], "PreState" : ["ap_ST_fsm_state2"], "PostState" : ["ap_ST_fsm_state2"], "OneDepthLoop" : "0", "OneStateBlock": ""}},
			{"Name" : "ReadInputHeight", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state8"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "66", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.outidx_i_i_i_i_222_U", "Parent" : "65"},
	{"ID" : "67", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.w10_U", "Parent" : "65"},
	{"ID" : "68", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417", "Parent" : "65", "Child" : ["69", "70", "71", "72", "73", "74", "75", "76"],
		"CDFG" : "shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s",
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
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "69", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15_U", "Parent" : "68"},
	{"ID" : "70", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11_U", "Parent" : "68"},
	{"ID" : "71", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14_U", "Parent" : "68"},
	{"ID" : "72", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10_U", "Parent" : "68"},
	{"ID" : "73", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13_U", "Parent" : "68"},
	{"ID" : "74", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9_U", "Parent" : "68"},
	{"ID" : "75", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12_U", "Parent" : "68"},
	{"ID" : "76", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8_U", "Parent" : "68"},
	{"ID" : "77", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.sparsemux_73_6_16_1_1_U182", "Parent" : "65"},
	{"ID" : "78", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.mul_16s_4s_19_1_1_U183", "Parent" : "65"},
	{"ID" : "79", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0.sparsemux_9_2_16_1_1_U184", "Parent" : "65"},
	{"ID" : "80", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0", "Parent" : "0", "Child" : ["81"],
		"CDFG" : "relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "258", "EstimateLatencyMax" : "258",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "65",
		"StartFifo" : "start_for_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0_U",
		"Port" : [
			{"Name" : "layer10_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["65"], "DependentChan" : "116", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer10_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer12_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["82"], "DependentChan" : "117", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer12_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "ReLUActLoop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "81", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0.flow_control_loop_pipe_U", "Parent" : "80"},
	{"ID" : "82", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0", "Parent" : "0", "Child" : ["83"],
		"CDFG" : "resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4097", "EstimateLatencyMax" : "4097",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "80",
		"StartFifo" : "start_for_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0_U",
		"Port" : [
			{"Name" : "layer12_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["80"], "DependentChan" : "117", "DependentChanDepth" : "256", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer12_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer13_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["84"], "DependentChan" : "118", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer13_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "ImageHeight", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "256", "FirstState" : "ap_ST_fsm_state1", "FirstStateIter" : "", "FirstStateBlock" : "ap_ST_fsm_state1_blk", "LastState" : "ap_ST_fsm_state256", "LastStateIter" : "", "LastStateBlock" : "ap_ST_fsm_state256_blk", "QuitState" : "ap_ST_fsm_state256", "QuitStateIter" : "", "QuitStateBlock" : "ap_ST_fsm_state256_blk", "OneDepthLoop" : "1", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "83", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0.flow_control_loop_pipe_U", "Parent" : "82"},
	{"ID" : "84", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0", "Parent" : "0", "Child" : ["85", "87", "89"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4367", "EstimateLatencyMax" : "4367",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "82",
		"StartFifo" : "start_for_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0_U",
		"Port" : [
			{"Name" : "layer13_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["82"], "DependentChan" : "118", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "87", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain_fu_28", "Port" : "layer13_out", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "layer20_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["91"], "DependentChan" : "119", "DependentChanDepth" : "4356", "DependentChanType" : "0",
				"SubConnect" : [
					{"ID" : "85", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth_fu_22", "Port" : "layer20_out", "Inst_start_state" : "1", "Inst_end_state" : "2"},
					{"ID" : "87", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain_fu_28", "Port" : "layer20_out", "Inst_start_state" : "3", "Inst_end_state" : "4"},
					{"ID" : "89", "SubInstance" : "grp_zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth_fu_36", "Port" : "layer20_out", "Inst_start_state" : "5", "Inst_end_state" : "6"}]}]},
	{"ID" : "85", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth_fu_22", "Parent" : "84", "Child" : ["86"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "68", "EstimateLatencyMax" : "68",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer20_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer20_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadTopWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "86", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth_fu_22.flow_control_loop_pipe_sequential_init_U", "Parent" : "85"},
	{"ID" : "87", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain_fu_28", "Parent" : "84", "Child" : ["88"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4226", "EstimateLatencyMax" : "4226",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer20_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer20_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer13_out", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "layer13_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadMain", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "66", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "88", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain_fu_28.flow_control_loop_pipe_sequential_init_U", "Parent" : "87"},
	{"ID" : "89", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth_fu_36", "Parent" : "84", "Child" : ["90"],
		"CDFG" : "zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "68", "EstimateLatencyMax" : "68",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "layer20_out", "Type" : "Fifo", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer20_out_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "PadBottomWidth", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "90", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0.grp_zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth_fu_36.flow_control_loop_pipe_sequential_init_U", "Parent" : "89"},
	{"ID" : "91", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0", "Parent" : "0", "Child" : ["92", "93", "102", "103"],
		"CDFG" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "1",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "13134", "EstimateLatencyMax" : "174306",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "84",
		"StartFifo" : "start_for_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14UhA_U",
		"Port" : [
			{"Name" : "layer20_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["84"], "DependentChan" : "119", "DependentChanDepth" : "4356", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer20_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer14_out", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["104"], "DependentChan" : "120", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer14_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9", "Type" : "OVld", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E", "Type" : "Memory", "Direction" : "X",
				"SubConnect" : [
					{"ID" : "93", "SubInstance" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Port" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E", "Inst_start_state" : "3", "Inst_end_state" : "3"}]},
			{"Name" : "sX_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pX_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "sY_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pY_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "w14", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "ReuseLoop", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state4"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state7"]}},
			{"Name" : "ReadInputWidth", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state3", "LastState" : ["ap_ST_fsm_state7"], "QuitState" : ["ap_ST_fsm_state7"], "PreState" : ["ap_ST_fsm_state2"], "PostState" : ["ap_ST_fsm_state2"], "OneDepthLoop" : "0", "OneStateBlock": ""}},
			{"Name" : "ReadInputHeight", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "6", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state7"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "92", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.w14_U", "Parent" : "91"},
	{"ID" : "93", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332", "Parent" : "91", "Child" : ["94", "95", "96", "97", "98", "99", "100", "101"],
		"CDFG" : "shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s",
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
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4", "Type" : "Memory", "Direction" : "X"},
			{"Name" : "p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E", "Type" : "Memory", "Direction" : "X"}]},
	{"ID" : "94", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7_U", "Parent" : "93"},
	{"ID" : "95", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3_U", "Parent" : "93"},
	{"ID" : "96", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6_U", "Parent" : "93"},
	{"ID" : "97", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2_U", "Parent" : "93"},
	{"ID" : "98", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5_U", "Parent" : "93"},
	{"ID" : "99", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1_U", "Parent" : "93"},
	{"ID" : "100", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4_U", "Parent" : "93"},
	{"ID" : "101", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332.p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_U", "Parent" : "93"},
	{"ID" : "102", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.sparsemux_73_6_4_1_1_U240", "Parent" : "91"},
	{"ID" : "103", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0.mul_4s_4ns_7_1_1_U241", "Parent" : "91"},
	{"ID" : "104", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0", "Parent" : "0", "Child" : ["105", "106"],
		"CDFG" : "relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_s",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "4099", "EstimateLatencyMax" : "4099",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"StartSource" : "91",
		"StartFifo" : "start_for_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0_U",
		"Port" : [
			{"Name" : "layer14_out", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["91"], "DependentChan" : "120", "DependentChanDepth" : "4096", "DependentChanType" : "0",
				"BlockSignal" : [
					{"Name" : "layer14_out_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "layer16_out", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "layer16_out_TDATA_blk_n", "Type" : "RtlSignal"}]}],
		"Loop" : [
			{"Name" : "ReLUActLoop", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "105", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0.flow_control_loop_pipe_U", "Parent" : "104"},
	{"ID" : "106", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0.regslice_both_layer16_out_U", "Parent" : "104"},
	{"ID" : "107", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer17_out_U", "Parent" : "0"},
	{"ID" : "108", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_out_U", "Parent" : "0"},
	{"ID" : "109", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer4_out_U", "Parent" : "0"},
	{"ID" : "110", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer5_out_U", "Parent" : "0"},
	{"ID" : "111", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer18_out_U", "Parent" : "0"},
	{"ID" : "112", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer6_out_U", "Parent" : "0"},
	{"ID" : "113", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer8_out_U", "Parent" : "0"},
	{"ID" : "114", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer9_out_U", "Parent" : "0"},
	{"ID" : "115", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer19_out_U", "Parent" : "0"},
	{"ID" : "116", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer10_out_U", "Parent" : "0"},
	{"ID" : "117", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer12_out_U", "Parent" : "0"},
	{"ID" : "118", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer13_out_U", "Parent" : "0"},
	{"ID" : "119", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer20_out_U", "Parent" : "0"},
	{"ID" : "120", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer14_out_U", "Parent" : "0"},
	{"ID" : "121", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0_U", "Parent" : "0"},
	{"ID" : "122", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0_U", "Parent" : "0"},
	{"ID" : "123", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configQgW_U", "Parent" : "0"},
	{"ID" : "124", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Rg6_U", "Parent" : "0"},
	{"ID" : "125", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0_U", "Parent" : "0"},
	{"ID" : "126", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0_U", "Parent" : "0"},
	{"ID" : "127", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configShg_U", "Parent" : "0"},
	{"ID" : "128", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Thq_U", "Parent" : "0"},
	{"ID" : "129", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0_U", "Parent" : "0"},
	{"ID" : "130", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0_U", "Parent" : "0"},
	{"ID" : "131", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0_U", "Parent" : "0"},
	{"ID" : "132", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0_U", "Parent" : "0"},
	{"ID" : "133", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14UhA_U", "Parent" : "0"},
	{"ID" : "134", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	myproject {
		input_4 {Type I LastRead 64 FirstWrite -1}
		layer16_out {Type O LastRead -1 FirstWrite 1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig {Type IO LastRead -1 FirstWrite -1}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer {Type X LastRead -1 FirstWrite -1}
		sX_2 {Type IO LastRead -1 FirstWrite -1}
		pX_2 {Type IO LastRead -1 FirstWrite -1}
		sY_2 {Type IO LastRead -1 FirstWrite -1}
		pY_2 {Type IO LastRead -1 FirstWrite -1}
		outidx_i_i_i_i {Type I LastRead -1 FirstWrite -1}
		w2 {Type I LastRead -1 FirstWrite -1}
		sY {Type IO LastRead -1 FirstWrite -1}
		pY {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap {Type IO LastRead -1 FirstWrite -1}
		pX {Type IO LastRead -1 FirstWrite -1}
		sX {Type IO LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer {Type X LastRead -1 FirstWrite -1}
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
		w6 {Type I LastRead -1 FirstWrite -1}
		sY_1 {Type IO LastRead -1 FirstWrite -1}
		pY_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap {Type IO LastRead -1 FirstWrite -1}
		pX_1 {Type IO LastRead -1 FirstWrite -1}
		sX_1 {Type IO LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4 {Type X LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8 {Type X LastRead -1 FirstWrite -1}
		sX_4 {Type IO LastRead -1 FirstWrite -1}
		pX_4 {Type IO LastRead -1 FirstWrite -1}
		sY_4 {Type IO LastRead -1 FirstWrite -1}
		pY_4 {Type IO LastRead -1 FirstWrite -1}
		outidx_i_i_i_i_222 {Type I LastRead -1 FirstWrite -1}
		w10 {Type I LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E {Type X LastRead -1 FirstWrite -1}
		sX_3 {Type IO LastRead -1 FirstWrite -1}
		pX_3 {Type IO LastRead -1 FirstWrite -1}
		sY_3 {Type IO LastRead -1 FirstWrite -1}
		pY_3 {Type IO LastRead -1 FirstWrite -1}
		w14 {Type I LastRead -1 FirstWrite -1}}
	zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_s {
		input_4 {Type I LastRead 64 FirstWrite -1}
		layer17_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth {
		layer17_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain {
		layer17_out {Type O LastRead -1 FirstWrite 1}
		input_4 {Type I LastRead 64 FirstWrite -1}}
	zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth {
		layer17_out {Type O LastRead -1 FirstWrite 1}}
	conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s {
		layer17_out {Type I LastRead 1 FirstWrite -1}
		layer2_out {Type O LastRead -1 FirstWrite 6}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig {Type IO LastRead -1 FirstWrite -1}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer {Type X LastRead -1 FirstWrite -1}
		sX_2 {Type IO LastRead -1 FirstWrite -1}
		pX_2 {Type IO LastRead -1 FirstWrite -1}
		sY_2 {Type IO LastRead -1 FirstWrite -1}
		pY_2 {Type IO LastRead -1 FirstWrite -1}
		outidx_i_i_i_i {Type I LastRead -1 FirstWrite -1}
		w2 {Type I LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s {
		in_elem_0_0_0_0_0_val {Type I LastRead 0 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_7 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_8 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_4 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_5 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_1 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_2 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_6 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_3 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig {Type IO LastRead 0 FirstWrite 0}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_conv_2d_buffer_resource_cl_stream_stream_weight_t_bias_t_line_buffer {Type X LastRead -1 FirstWrite -1}}
	relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_s {
		layer2_out {Type I LastRead 0 FirstWrite -1}
		layer4_out {Type O LastRead -1 FirstWrite 1}}
	pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_s {
		layer4_out {Type I LastRead 1 FirstWrite -1}
		layer5_out {Type O LastRead -1 FirstWrite 3}
		sY {Type IO LastRead -1 FirstWrite -1}
		pY {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap {Type IO LastRead -1 FirstWrite -1}
		pX {Type IO LastRead -1 FirstWrite -1}
		sX {Type IO LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer {Type X LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 {Type O LastRead -1 FirstWrite 0}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer {Type X LastRead -1 FirstWrite -1}}
	zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_s {
		layer5_out {Type I LastRead 32 FirstWrite -1}
		layer18_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth {
		layer18_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain {
		layer18_out {Type O LastRead -1 FirstWrite 1}
		layer5_out {Type I LastRead 32 FirstWrite -1}}
	zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth {
		layer18_out {Type O LastRead -1 FirstWrite 1}}
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
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E {Type X LastRead -1 FirstWrite -1}}
	relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_s {
		layer6_out {Type I LastRead 0 FirstWrite -1}
		layer8_out {Type O LastRead -1 FirstWrite 1}}
	pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_s {
		layer8_out {Type I LastRead 1 FirstWrite -1}
		layer9_out {Type O LastRead -1 FirstWrite 3}
		sY_1 {Type IO LastRead -1 FirstWrite -1}
		pY_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16 {Type IO LastRead -1 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap {Type IO LastRead -1 FirstWrite -1}
		pX_1 {Type IO LastRead -1 FirstWrite -1}
		sX_1 {Type IO LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4 {Type X LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_15 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_19 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_14 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_18 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_13 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_17 {Type O LastRead -1 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_12 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_16 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_3 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_11 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_2 {Type IO LastRead 0 FirstWrite 0}
		void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_10 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_1 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_5 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi6ELi1EL9ap_q_mode5EL9ap_4 {Type O LastRead -1 FirstWrite 0}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_7 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_6 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_5 {Type X LastRead -1 FirstWrite -1}
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_4 {Type X LastRead -1 FirstWrite -1}}
	zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_s {
		layer9_out {Type I LastRead 16 FirstWrite -1}
		layer19_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth {
		layer19_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain {
		layer19_out {Type O LastRead -1 FirstWrite 1}
		layer9_out {Type I LastRead 16 FirstWrite -1}}
	zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth {
		layer19_out {Type O LastRead -1 FirstWrite 1}}
	conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s {
		layer19_out {Type I LastRead 2 FirstWrite -1}
		layer10_out {Type O LastRead -1 FirstWrite 7}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8 {Type X LastRead -1 FirstWrite -1}
		sX_4 {Type IO LastRead -1 FirstWrite -1}
		pX_4 {Type IO LastRead -1 FirstWrite -1}
		sY_4 {Type IO LastRead -1 FirstWrite -1}
		pY_4 {Type IO LastRead -1 FirstWrite -1}
		outidx_i_i_i_i_222 {Type I LastRead -1 FirstWrite -1}
		w10 {Type I LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_24 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_28 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_23 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_27 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_22 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_26 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_21 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_25 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_45 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_49 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_44 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_48 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_43 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_47 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_42 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_46 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_33 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_37 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_32 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_36 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_31 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_35 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_30 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_34 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_20 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_19 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_51 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_50 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_41 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_40 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_39 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_38 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_29 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_28 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_27 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5EL9_26 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_15 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_11 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_14 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_10 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_13 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_9 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_12 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI8ap_fixedILi16ELi6EL9ap_q_mode5E_8 {Type X LastRead -1 FirstWrite -1}}
	relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_s {
		layer10_out {Type I LastRead 0 FirstWrite -1}
		layer12_out {Type O LastRead -1 FirstWrite 1}}
	resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_s {
		layer12_out {Type I LastRead 15 FirstWrite -1}
		layer13_out {Type O LastRead -1 FirstWrite 0}}
	zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_s {
		layer13_out {Type I LastRead 64 FirstWrite -1}
		layer20_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth {
		layer20_out {Type O LastRead -1 FirstWrite 1}}
	zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain {
		layer20_out {Type O LastRead -1 FirstWrite 1}
		layer13_out {Type I LastRead 64 FirstWrite -1}}
	zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth {
		layer20_out {Type O LastRead -1 FirstWrite 1}}
	conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s {
		layer20_out {Type I LastRead 2 FirstWrite -1}
		layer14_out {Type O LastRead -1 FirstWrite 6}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10 {Type IO LastRead -1 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9 {Type IO LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E {Type X LastRead -1 FirstWrite -1}
		sX_3 {Type IO LastRead -1 FirstWrite -1}
		pX_3 {Type IO LastRead -1 FirstWrite -1}
		sY_3 {Type IO LastRead -1 FirstWrite -1}
		pY_3 {Type IO LastRead -1 FirstWrite -1}
		w14 {Type I LastRead -1 FirstWrite -1}}
	shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 {Type O LastRead -1 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 {Type O LastRead -1 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10 {Type IO LastRead 0 FirstWrite 0}
		void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9 {Type IO LastRead 0 FirstWrite 0}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_7 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_3 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_6 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_2 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_5 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_1 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E_4 {Type X LastRead -1 FirstWrite -1}
		p_ZZN4nnet26conv_2d_buffer_resource_clINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4E {Type X LastRead -1 FirstWrite -1}}
	relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_s {
		layer14_out {Type I LastRead 0 FirstWrite -1}
		layer16_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "178534", "Max" : "178602"}
	, {"Name" : "Interval", "Min" : "13135", "Max" : "178597"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	input_4 { axis {  { input_4_TDATA in_data 0 8 }  { input_4_TVALID in_vld 0 1 }  { input_4_TREADY in_acc 1 1 } } }
	layer16_out { axis {  { layer16_out_TDATA out_data 1 8 }  { layer16_out_TVALID out_vld 1 1 }  { layer16_out_TREADY out_acc 0 1 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
