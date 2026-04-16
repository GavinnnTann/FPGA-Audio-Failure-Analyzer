set ModuleHierarchy {[{
"Name" : "myproject","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_U0","ID" : "1","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadTopWidth_fu_28","ID" : "2","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadTopWidth","ID" : "3","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_8_0_5_3_0_1u_config17_Pipeline_PadMain_fu_34","ID" : "4","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadMain","ID" : "5","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_1u_config17_Pipeline_PadBottomWidth_fu_42","ID" : "6","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadBottomWidth","ID" : "7","Type" : "pipeline"},]},]},
	{"Name" : "conv_2d_cl_array_ap_ufixed_1u_array_ap_fixed_16_6_5_3_0_4u_config2_U0","ID" : "8","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight_ReadInputWidth","ID" : "9","Type" : "no",
		"SubInsts" : [
		{"Name" : "call_ln286_shift_line_buffer_array_ap_ufixed_8_0_5_3_0_1u_config2_s_fu_275","ID" : "10","Type" : "pipeline"},],
		"SubLoops" : [
		{"Name" : "ReuseLoop","ID" : "11","Type" : "pipeline"},]},]},
	{"Name" : "relu_array_ap_fixed_4u_array_ap_ufixed_8_2_5_3_0_4u_relu_config4_U0","ID" : "12","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReLUActLoop","ID" : "13","Type" : "pipeline"},]},
	{"Name" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config5_U0","ID" : "14","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight_ReadInputWidth","ID" : "15","Type" : "pipeline",
		"SubInsts" : [
		{"Name" : "call_ln52_shift_line_buffer_array_ap_ufixed_8_2_5_3_0_4u_config5_s_fu_140","ID" : "16","Type" : "pipeline"},]},]},
	{"Name" : "zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config18_U0","ID" : "17","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadTopWidth_fu_22","ID" : "18","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadTopWidth","ID" : "19","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config18_Pipeline_PadMain_fu_28","ID" : "20","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadMain","ID" : "21","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_4u_config18_Pipeline_PadBottomWidth_fu_36","ID" : "22","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadBottomWidth","ID" : "23","Type" : "pipeline"},]},]},
	{"Name" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config6_U0","ID" : "24","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight","ID" : "25","Type" : "no",
		"SubLoops" : [
		{"Name" : "ReadInputWidth","ID" : "26","Type" : "no",
			"SubInsts" : [
			{"Name" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config6_s_fu_411","ID" : "27","Type" : "pipeline"},],
			"SubLoops" : [
			{"Name" : "ReuseLoop","ID" : "28","Type" : "pipeline"},]},]},]},
	{"Name" : "relu_array_ap_fixed_4u_array_ap_ufixed_6_1_5_3_0_4u_relu_config8_U0","ID" : "29","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReLUActLoop","ID" : "30","Type" : "pipeline"},]},
	{"Name" : "pooling2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_4u_config9_U0","ID" : "31","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight_ReadInputWidth","ID" : "32","Type" : "pipeline",
		"SubInsts" : [
		{"Name" : "call_ln52_shift_line_buffer_array_ap_ufixed_6_1_5_3_0_4u_config9_s_fu_142","ID" : "33","Type" : "pipeline"},]},]},
	{"Name" : "zeropad2d_cl_array_ap_fixed_4u_array_ap_fixed_16_6_5_3_0_4u_config19_U0","ID" : "34","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadTopWidth_fu_22","ID" : "35","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadTopWidth","ID" : "36","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_16_6_5_3_0_4u_config19_Pipeline_PadMain_fu_28","ID" : "37","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadMain","ID" : "38","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_fixed_4u_config19_Pipeline_PadBottomWidth_fu_36","ID" : "39","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadBottomWidth","ID" : "40","Type" : "pipeline"},]},]},
	{"Name" : "conv_2d_cl_array_ap_fixed_4u_array_ap_fixed_8_4_5_3_0_4u_config10_U0","ID" : "41","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight","ID" : "42","Type" : "no",
		"SubLoops" : [
		{"Name" : "ReadInputWidth","ID" : "43","Type" : "no",
			"SubInsts" : [
			{"Name" : "call_ln286_shift_line_buffer_array_ap_fixed_16_6_5_3_0_4u_config10_s_fu_417","ID" : "44","Type" : "pipeline"},],
			"SubLoops" : [
			{"Name" : "ReuseLoop","ID" : "45","Type" : "pipeline"},]},]},]},
	{"Name" : "relu_array_ap_fixed_4u_array_ap_ufixed_4_1_4_0_0_4u_relu_config12_U0","ID" : "46","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReLUActLoop","ID" : "47","Type" : "pipeline"},]},
	{"Name" : "resize_nearest_array_ap_ufixed_4_1_4_0_0_4u_config13_U0","ID" : "48","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ImageHeight","ID" : "49","Type" : "pipeline"},]},
	{"Name" : "zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_U0","ID" : "50","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadTopWidth_fu_22","ID" : "51","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadTopWidth","ID" : "52","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_4_1_4_0_0_4u_config20_Pipeline_PadMain_fu_28","ID" : "53","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadMain","ID" : "54","Type" : "pipeline"},]},
		{"Name" : "grp_zeropad2d_cl_array_array_ap_ufixed_4u_config20_Pipeline_PadBottomWidth_fu_36","ID" : "55","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "PadBottomWidth","ID" : "56","Type" : "pipeline"},]},]},
	{"Name" : "conv_2d_cl_array_ap_ufixed_4u_array_ap_fixed_16_6_5_3_0_1u_config14_U0","ID" : "57","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReadInputHeight","ID" : "58","Type" : "no",
		"SubLoops" : [
		{"Name" : "ReadInputWidth","ID" : "59","Type" : "no",
			"SubInsts" : [
			{"Name" : "call_ln286_shift_line_buffer_array_ap_ufixed_4_1_4_0_0_4u_config14_s_fu_332","ID" : "60","Type" : "pipeline"},],
			"SubLoops" : [
			{"Name" : "ReuseLoop","ID" : "61","Type" : "pipeline"},]},]},]},
	{"Name" : "relu_array_ap_fixed_1u_array_ap_ufixed_8_0_4_0_0_1u_relu_config16_U0","ID" : "62","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "ReLUActLoop","ID" : "63","Type" : "pipeline"},]},]
}]}