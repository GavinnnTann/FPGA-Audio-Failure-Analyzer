#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_fixed.h"
#include "ap_int.h"
#include "nnet_utils/nnet_types.h"
#include <cstddef>
#include <cstdio>

// hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 64
#define N_INPUT_2_1 64
#define N_INPUT_3_1 1
#define OUT_HEIGHT_17 66
#define OUT_WIDTH_17 66
#define N_CHAN_17 1
#define OUT_HEIGHT_2 64
#define OUT_WIDTH_2 64
#define N_FILT_2 4
#define OUT_HEIGHT_2 64
#define OUT_WIDTH_2 64
#define N_FILT_2 4
#define OUT_HEIGHT_5 32
#define OUT_WIDTH_5 32
#define N_FILT_5 4
#define OUT_HEIGHT_18 34
#define OUT_WIDTH_18 34
#define N_CHAN_18 4
#define OUT_HEIGHT_6 32
#define OUT_WIDTH_6 32
#define N_FILT_6 4
#define OUT_HEIGHT_6 32
#define OUT_WIDTH_6 32
#define N_FILT_6 4
#define OUT_HEIGHT_9 16
#define OUT_WIDTH_9 16
#define N_FILT_9 4
#define OUT_HEIGHT_19 18
#define OUT_WIDTH_19 18
#define N_CHAN_19 4
#define OUT_HEIGHT_10 16
#define OUT_WIDTH_10 16
#define N_FILT_10 4
#define OUT_HEIGHT_10 16
#define OUT_WIDTH_10 16
#define N_FILT_10 4
#define OUT_HEIGHT_13 64
#define OUT_WIDTH_13 64
#define N_CHAN_13 4
#define OUT_HEIGHT_20 66
#define OUT_WIDTH_20 66
#define N_CHAN_20 4
#define OUT_HEIGHT_14 64
#define OUT_WIDTH_14 64
#define N_FILT_14 1
#define OUT_HEIGHT_14 64
#define OUT_WIDTH_14 64
#define N_FILT_14 1

// hls-fpga-machine-learning insert layer-precision
typedef nnet::array<ap_ufixed<8,0>, 1*1> input_t;
typedef nnet::array<ap_ufixed<8,0>, 1*1> layer17_t;
typedef ap_fixed<16,6> enc_conv1_accum_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer2_t;
typedef ap_fixed<8,2> weight2_t;
typedef ap_fixed<8,2> bias2_t;
typedef nnet::array<ap_ufixed<8,2>, 4*1> layer4_t;
typedef ap_fixed<18,8> enc_act1_table_t;
typedef ap_fixed<16,8> enc_pool1_accum_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer5_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer18_t;
typedef ap_fixed<16,6> enc_conv2_accum_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer6_t;
typedef ap_fixed<8,2> weight6_t;
typedef ap_fixed<8,2> bias6_t;
typedef nnet::array<ap_ufixed<6,1>, 4*1> layer8_t;
typedef ap_fixed<18,8> enc_act2_table_t;
typedef ap_fixed<16,8> enc_pool2_accum_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer9_t;
typedef nnet::array<ap_fixed<16,6>, 4*1> layer19_t;
typedef ap_fixed<16,6> dec_conv1_accum_t;
typedef nnet::array<ap_fixed<8,4>, 4*1> layer10_t;
typedef ap_fixed<4,1> weight10_t;
typedef ap_fixed<4,1> bias10_t;
typedef nnet::array<ap_ufixed<4,1,AP_RND_CONV,AP_SAT>, 4*1> layer12_t;
typedef ap_fixed<18,8> dec_act1_table_t;
typedef nnet::array<ap_ufixed<4,1,AP_RND_CONV,AP_SAT>, 4*1> layer13_t;
typedef nnet::array<ap_ufixed<4,1,AP_RND_CONV,AP_SAT>, 4*1> layer20_t;
typedef ap_fixed<16,6> dec_out_conv_accum_t;
typedef nnet::array<ap_fixed<16,6>, 1*1> layer14_t;
typedef ap_fixed<4,1> weight14_t;
typedef ap_fixed<4,1> bias14_t;
typedef nnet::array<ap_ufixed<8,0,AP_RND_CONV,AP_SAT>, 1*1> result_t;
typedef ap_fixed<18,8> dec_out_act_table_t;

#endif
