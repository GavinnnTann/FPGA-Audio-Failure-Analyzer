set moduleName shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type function
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 1
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 36
set C_modelName {shift_line_buffer<array<ap_ufixed<8, 2, 5, 3, 0>, 4u>, config5>}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ p_read int 8 regular  }
	{ p_read1 int 8 regular  }
	{ p_read2 int 8 regular  }
	{ p_read3 int 8 regular  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 int 8 regular {pointer 1} {global 1}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 int 8 regular {pointer 1} {global 1}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 int 8 regular {pointer 1} {global 1}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 int 8 regular {pointer 1} {global 1}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 int 8 regular {pointer 1} {global 1}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2 int 8 regular {pointer 2} {global 2}  }
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel int 8 regular {pointer 1} {global 1}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1 int 8 regular {pointer 2} {global 2}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 int 8 regular {pointer 1} {global 1}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap int 8 regular {pointer 2} {global 2}  }
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 int 8 regular {pointer 1} {global 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "interface" : "wire", "bitwidth" : 8, "direction" : "READWRITE", "extern" : 0} , 
 	{ "Name" : "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY", "extern" : 0} ]}
# RTL Port declarations: 
set portNum 51
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ p_read sc_in sc_lv 8 signal 0 } 
	{ p_read1 sc_in sc_lv 8 signal 1 } 
	{ p_read2 sc_in sc_lv 8 signal 2 } 
	{ p_read3 sc_in sc_lv 8 signal 3 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_i sc_in sc_lv 8 signal 4 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o sc_out sc_lv 8 signal 4 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o_ap_vld sc_out sc_logic 1 outvld 4 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 sc_out sc_lv 8 signal 5 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9_ap_vld sc_out sc_logic 1 outvld 5 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_i sc_in sc_lv 8 signal 6 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o sc_out sc_lv 8 signal 6 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o_ap_vld sc_out sc_logic 1 outvld 6 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 sc_out sc_lv 8 signal 7 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8_ap_vld sc_out sc_logic 1 outvld 7 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_i sc_in sc_lv 8 signal 8 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o sc_out sc_lv 8 signal 8 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o_ap_vld sc_out sc_logic 1 outvld 8 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 sc_out sc_lv 8 signal 9 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7_ap_vld sc_out sc_logic 1 outvld 9 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_i sc_in sc_lv 8 signal 10 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o sc_out sc_lv 8 signal 10 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o_ap_vld sc_out sc_logic 1 outvld 10 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 sc_out sc_lv 8 signal 11 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6_ap_vld sc_out sc_logic 1 outvld 11 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_i sc_in sc_lv 8 signal 12 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o sc_out sc_lv 8 signal 12 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o_ap_vld sc_out sc_logic 1 outvld 12 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 sc_out sc_lv 8 signal 13 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1_ap_vld sc_out sc_logic 1 outvld 13 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_i sc_in sc_lv 8 signal 14 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o sc_out sc_lv 8 signal 14 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o_ap_vld sc_out sc_logic 1 outvld 14 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel sc_out sc_lv 8 signal 15 } 
	{ void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_ap_vld sc_out sc_logic 1 outvld 15 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_i sc_in sc_lv 8 signal 16 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o sc_out sc_lv 8 signal 16 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o_ap_vld sc_out sc_logic 1 outvld 16 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 sc_out sc_lv 8 signal 17 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5_ap_vld sc_out sc_logic 1 outvld 17 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_i sc_in sc_lv 8 signal 18 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o sc_out sc_lv 8 signal 18 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o_ap_vld sc_out sc_logic 1 outvld 18 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 sc_out sc_lv 8 signal 19 } 
	{ p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4_ap_vld sc_out sc_logic 1 outvld 19 } 
	{ ap_ce sc_in sc_logic 1 ce -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "p_read2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read2", "role": "default" }} , 
 	{ "name": "p_read3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read3", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "role": "i" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "role": "o" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9", "role": "ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "role": "i" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "role": "o" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8", "role": "ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "role": "i" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "role": "o" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7", "role": "ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "role": "i" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "role": "o" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6", "role": "ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "role": "i" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "role": "o" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1", "role": "ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "role": "i" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "role": "o" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2", "role": "o_ap_vld" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "role": "default" }} , 
 	{ "name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel", "role": "ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "role": "i" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "role": "o" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1", "role": "o_ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "role": "default" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5", "role": "ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_i", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "role": "i" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "role": "o" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap", "role": "o_ap_vld" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "role": "default" }} , 
 	{ "name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4", "role": "ap_vld" }} , 
 	{ "name": "ap_ce", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "ce", "bundle":{"name": "ap_ce", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4"],
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
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_3_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_2_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_1_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
		void_pooling2d_cl_stream_stream_array_ap_fixed_4u_0_line_buffer {Type X LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "0", "Max" : "0"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	p_read { ap_none {  { p_read in_data 0 8 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 8 } } }
	p_read2 { ap_none {  { p_read2 in_data 0 8 } } }
	p_read3 { ap_none {  { p_read3 in_data 0 8 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5 { ap_ovld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_i in_data 0 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_5_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9 out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_9_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4 { ap_ovld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_i in_data 0 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_4_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8 out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_8_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3 { ap_ovld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_i in_data 0 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_3_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7 out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_7_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2 { ap_ovld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_i in_data 0 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_2_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6 out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_6_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3 { ap_ovld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_i in_data 0 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_3_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1 out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_1_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2 { ap_ovld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_i in_data 0 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_2_o_ap_vld out_vld 1 1 } } }
	void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel { ap_vld {  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel out_data 1 8 }  { void_compute_pool_buffer_2d_array_const_ap_shift_reg_n_filt_stream_kernel_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1 { ap_ovld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_i in_data 0 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_1_o_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 { ap_vld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5 out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_5_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap { ap_ovld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_i in_data 0 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_o_ap_vld out_vld 1 1 } } }
	p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 { ap_vld {  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4 out_data 1 8 }  { p_ZZN4nnet22compute_pool_buffer_2dINS_5arrayI9ap_ufixedILi8ELi2EL9ap_q_mode5EL9ap_4_ap_vld out_vld 1 1 } } }
}
