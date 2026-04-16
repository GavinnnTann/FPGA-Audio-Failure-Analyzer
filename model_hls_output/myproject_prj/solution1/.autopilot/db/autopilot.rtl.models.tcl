set SynModuleInfo {
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<8,0,5,3,0>,1u>,config17>_Pipeline_PadTopWidth MODELNAME zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth
    SUBMODULES {
      {MODELNAME myproject_flow_control_loop_pipe_sequential_init RTLNAME myproject_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME myproject_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<8,0,5,3,0>,1u>,config17>_Pipeline_PadMain MODELNAME zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed,1u>,config17>_Pipeline_PadBottomWidth MODELNAME zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<8,0,5,3,0>,1u>,config17> MODELNAME zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_s RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_s
    SUBMODULES {
      {MODELNAME myproject_regslice_both RTLNAME myproject_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
  {SRCNAME {shift_line_buffer<array<ap_ufixed<8, 0, 5, 3, 0>, 1u>, config2>} MODELNAME shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s RTLNAME myproject_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_void_conv_2d_buffer_bkb RTLNAME myproject_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_void_conv_2d_buffer_bkb BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME conv_2d_cl<array<ap_ufixed,1u>,array<ap_fixed<16,6,5,3,0>,4u>,config2> MODELNAME conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s RTLNAME myproject_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s
    SUBMODULES {
      {MODELNAME myproject_sparsemux_19_4_8_1_1 RTLNAME myproject_sparsemux_19_4_8_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
      {MODELNAME myproject_mul_8s_8ns_16_1_1 RTLNAME myproject_mul_8s_8ns_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME myproject_sparsemux_9_2_16_1_1 RTLNAME myproject_sparsemux_9_2_16_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
      {MODELNAME myproject_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s_outidx_idEe RTLNAME myproject_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s_outidx_idEe BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME myproject_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s_w2_ROM_AeOg RTLNAME myproject_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_s_w2_ROM_AeOg BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME relu<array<ap_fixed,4u>,array<ap_ufixed<8,2,5,3,0>,4u>,relu_config4> MODELNAME relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_s RTLNAME myproject_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_s
    SUBMODULES {
      {MODELNAME myproject_flow_control_loop_pipe RTLNAME myproject_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME myproject_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME {shift_line_buffer<array<ap_ufixed<8, 2, 5, 3, 0>, 4u>, config5>} MODELNAME shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s RTLNAME myproject_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_void_pooling2d_cl_stfYi RTLNAME myproject_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_void_pooling2d_cl_stfYi BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME pooling2d_cl<array<ap_ufixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config5> MODELNAME pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_s RTLNAME myproject_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_s}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed<16,6,5,3,0>,4u>,config18>_Pipeline_PadTopWidth MODELNAME zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed<16,6,5,3,0>,4u>,config18>_Pipeline_PadMain MODELNAME zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed,4u>,config18>_Pipeline_PadBottomWidth MODELNAME zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth}
  {SRCNAME zeropad2d_cl<array<ap_fixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config18> MODELNAME zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_s RTLNAME myproject_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_s}
  {SRCNAME {shift_line_buffer<array<ap_fixed<16, 6, 5, 3, 0>, 4u>, config6>} MODELNAME shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s RTLNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_p_ZZN4nnet26conv_2d_jbC RTLNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_p_ZZN4nnet26conv_2d_jbC BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME conv_2d_cl<array<ap_fixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config6> MODELNAME conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s RTLNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s
    SUBMODULES {
      {MODELNAME myproject_sparsemux_73_6_16_1_1 RTLNAME myproject_sparsemux_73_6_16_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
      {MODELNAME myproject_mul_16s_6s_22_1_1 RTLNAME myproject_mul_16s_6s_22_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s_outidx_i_rcU RTLNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s_outidx_i_rcU BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s_w6_ROM_AUsc4 RTLNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_s_w6_ROM_AUsc4 BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME relu<array<ap_fixed,4u>,array<ap_ufixed<6,1,5,3,0>,4u>,relu_config8> MODELNAME relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_s RTLNAME myproject_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_s}
  {SRCNAME {shift_line_buffer<array<ap_ufixed<6, 1, 5, 3, 0>, 4u>, config9>} MODELNAME shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s RTLNAME myproject_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_void_pooling2d_cl_sttde RTLNAME myproject_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_void_pooling2d_cl_sttde BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME pooling2d_cl<array<ap_ufixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config9> MODELNAME pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_s RTLNAME myproject_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_s}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed<16,6,5,3,0>,4u>,config19>_Pipeline_PadTopWidth MODELNAME zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed<16,6,5,3,0>,4u>,config19>_Pipeline_PadMain MODELNAME zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain}
  {SRCNAME zeropad2d_cl<array,array<ap_fixed,4u>,config19>_Pipeline_PadBottomWidth MODELNAME zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth}
  {SRCNAME zeropad2d_cl<array<ap_fixed,4u>,array<ap_fixed<16,6,5,3,0>,4u>,config19> MODELNAME zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_s RTLNAME myproject_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_s}
  {SRCNAME {shift_line_buffer<array<ap_fixed<16, 6, 5, 3, 0>, 4u>, config10>} MODELNAME shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s RTLNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_p_ZZN4nnet26conv_2dxdS RTLNAME myproject_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_p_ZZN4nnet26conv_2dxdS BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME conv_2d_cl<array<ap_fixed,4u>,array<ap_fixed<8,4,5,3,0>,4u>,config10> MODELNAME conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s RTLNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s
    SUBMODULES {
      {MODELNAME myproject_mul_16s_4s_19_1_1 RTLNAME myproject_mul_16s_4s_19_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s_w10_ROM_AGfk RTLNAME myproject_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_s_w10_ROM_AGfk BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME relu<array<ap_fixed,4u>,array<ap_ufixed<4,1,4,0,0>,4u>,relu_config12> MODELNAME relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_s RTLNAME myproject_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_s}
  {SRCNAME {resize_nearest<array<ap_ufixed<4, 1, 4, 0, 0>, 4u>, config13>} MODELNAME resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_s RTLNAME myproject_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_s}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<4,1,4,0,0>,4u>,config20>_Pipeline_PadTopWidth MODELNAME zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<4,1,4,0,0>,4u>,config20>_Pipeline_PadMain MODELNAME zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed,4u>,config20>_Pipeline_PadBottomWidth MODELNAME zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth}
  {SRCNAME zeropad2d_cl<array,array<ap_ufixed<4,1,4,0,0>,4u>,config20> MODELNAME zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_s RTLNAME myproject_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_s}
  {SRCNAME {shift_line_buffer<array<ap_ufixed<4, 1, 4, 0, 0>, 4u>, config14>} MODELNAME shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s RTLNAME myproject_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s
    SUBMODULES {
      {MODELNAME myproject_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_p_ZZN4nnet26conv_2dHfu RTLNAME myproject_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_p_ZZN4nnet26conv_2dHfu BINDTYPE storage TYPE shiftreg IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME conv_2d_cl<array<ap_ufixed,4u>,array<ap_fixed<16,6,5,3,0>,1u>,config14> MODELNAME conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s RTLNAME myproject_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s
    SUBMODULES {
      {MODELNAME myproject_sparsemux_73_6_4_1_1 RTLNAME myproject_sparsemux_73_6_4_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
      {MODELNAME myproject_mul_4s_4ns_7_1_1 RTLNAME myproject_mul_4s_4ns_7_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME myproject_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s_w14_ROMPgM RTLNAME myproject_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_s_w14_ROMPgM BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME relu<array<ap_fixed,1u>,array<ap_ufixed<8,0,4,0,0>,1u>,relu_config16> MODELNAME relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_s RTLNAME myproject_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_s}
  {SRCNAME myproject MODELNAME myproject RTLNAME myproject IS_TOP 1
    SUBMODULES {
      {MODELNAME myproject_fifo_w8_d4356_A RTLNAME myproject_fifo_w8_d4356_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer17_out_U}
      {MODELNAME myproject_fifo_w64_d4096_A RTLNAME myproject_fifo_w64_d4096_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer2_out_U}
      {MODELNAME myproject_fifo_w32_d4096_A RTLNAME myproject_fifo_w32_d4096_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer4_out_U}
      {MODELNAME myproject_fifo_w64_d1024_A RTLNAME myproject_fifo_w64_d1024_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer5_out_U}
      {MODELNAME myproject_fifo_w64_d1156_A RTLNAME myproject_fifo_w64_d1156_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer18_out_U}
      {MODELNAME myproject_fifo_w64_d1024_A RTLNAME myproject_fifo_w64_d1024_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer6_out_U}
      {MODELNAME myproject_fifo_w24_d1024_A RTLNAME myproject_fifo_w24_d1024_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer8_out_U}
      {MODELNAME myproject_fifo_w64_d256_A RTLNAME myproject_fifo_w64_d256_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer9_out_U}
      {MODELNAME myproject_fifo_w64_d324_A RTLNAME myproject_fifo_w64_d324_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer19_out_U}
      {MODELNAME myproject_fifo_w32_d256_A RTLNAME myproject_fifo_w32_d256_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer10_out_U}
      {MODELNAME myproject_fifo_w16_d256_A RTLNAME myproject_fifo_w16_d256_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer12_out_U}
      {MODELNAME myproject_fifo_w16_d4096_A RTLNAME myproject_fifo_w16_d4096_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer13_out_U}
      {MODELNAME myproject_fifo_w16_d4356_A RTLNAME myproject_fifo_w16_d4356_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer20_out_U}
      {MODELNAME myproject_fifo_w16_d4096_A RTLNAME myproject_fifo_w16_d4096_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME layer14_out_U}
      {MODELNAME myproject_start_for_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0 RTLNAME myproject_start_for_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0_U}
      {MODELNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0 RTLNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0_U}
      {MODELNAME myproject_start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configQgW RTLNAME myproject_start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configQgW BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configQgW_U}
      {MODELNAME myproject_start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Rg6 RTLNAME myproject_start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Rg6 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Rg6_U}
      {MODELNAME myproject_start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0 RTLNAME myproject_start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0_U}
      {MODELNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0 RTLNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0_U}
      {MODELNAME myproject_start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configShg RTLNAME myproject_start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configShg BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_configShg_U}
      {MODELNAME myproject_start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Thq RTLNAME myproject_start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Thq BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config1Thq_U}
      {MODELNAME myproject_start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0 RTLNAME myproject_start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0_U}
      {MODELNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0 RTLNAME myproject_start_for_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0_U}
      {MODELNAME myproject_start_for_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0 RTLNAME myproject_start_for_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0_U}
      {MODELNAME myproject_start_for_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0 RTLNAME myproject_start_for_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0_U}
      {MODELNAME myproject_start_for_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14UhA RTLNAME myproject_start_for_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14UhA BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14UhA_U}
      {MODELNAME myproject_start_for_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0 RTLNAME myproject_start_for_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0_U}
    }
  }
}
