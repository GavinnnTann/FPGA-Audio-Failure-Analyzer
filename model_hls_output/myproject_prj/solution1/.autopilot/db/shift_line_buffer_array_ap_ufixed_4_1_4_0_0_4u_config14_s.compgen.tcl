# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler myproject_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_p_ZZN4nnet26conv_2dHfu BINDTYPE {storage} TYPE {shiftreg} IMPL {auto} LATENCY 1 ALLOW_PRAGMA 1
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 200 \
    name p_read \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_p_read \
    op interface \
    ports { p_read { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 201 \
    name p_read1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_p_read1 \
    op interface \
    ports { p_read1 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 202 \
    name p_read2 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_p_read2 \
    op interface \
    ports { p_read2 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 203 \
    name p_read3 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_p_read3 \
    op interface \
    ports { p_read3 { I 4 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 204 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_14_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 205 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18 { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_18_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 206 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_13_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 207 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17 { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_17_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 208 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_12_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 209 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16 { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_16_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 210 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_11_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 211 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15 { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_15_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 212 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_19_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 213 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_23_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 214 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_18_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 215 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_22_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 216 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_17_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 217 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_21_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 218 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_16_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 219 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_20_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 220 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_7_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 221 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_11_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 222 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_6_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 223 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_10_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 224 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_5_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 225 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_9_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 226 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_4_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 227 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8 { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_8_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 228 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_10_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 229 \
    name void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9 \
    op interface \
    ports { void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9_i { I 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9_o { O 4 vector } void_compute_output_buffer_2d_array_const_ap_shift_reg_n_chan_stream_weig_9_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 230 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_25_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 231 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_24_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 232 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_15_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 233 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_14_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 234 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_13_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 235 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_12_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 236 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_3_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 237 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_2_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 238 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_1_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 239 \
    name p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9 \
    op interface \
    ports { p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_i { I 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_o { O 4 vector } p_ZZN4nnet24compute_output_buffer_2dINS_5arrayI9ap_ufixedILi4ELi1EL9ap_q_mode4EL9_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


