#include <iostream>

#include "myproject.h"
#include "parameters.h"

void myproject(
    hls::stream<input_t> &input_4,
    hls::stream<result_t> &layer16_out
) {

    // hls-fpga-machine-learning insert IO
    #pragma HLS INTERFACE axis port=input_4,layer16_out 
    #pragma HLS DATAFLOW 

#ifndef __SYNTHESIS__
    static bool loaded_weights = false;
    if (!loaded_weights) {
        // hls-fpga-machine-learning insert load weights
        nnet::load_weights_from_txt<weight2_t, 36>(w2, "w2.txt");
        nnet::load_weights_from_txt<bias2_t, 4>(b2, "b2.txt");
        nnet::load_weights_from_txt<weight6_t, 144>(w6, "w6.txt");
        nnet::load_weights_from_txt<bias6_t, 4>(b6, "b6.txt");
        nnet::load_weights_from_txt<weight10_t, 144>(w10, "w10.txt");
        nnet::load_weights_from_txt<bias10_t, 4>(b10, "b10.txt");
        nnet::load_weights_from_txt<weight14_t, 36>(w14, "w14.txt");
        nnet::load_weights_from_txt<bias14_t, 1>(b14, "b14.txt");
        loaded_weights = true;
    }
#endif

    // ****************************************
    // NETWORK INSTANTIATION
    // ****************************************

    // hls-fpga-machine-learning insert layers

    hls::stream<layer17_t> layer17_out("layer17_out");
    #pragma HLS STREAM variable=layer17_out depth=4356
    nnet::zeropad2d_cl<input_t, layer17_t, config17>(input_4, layer17_out); // zp2d_enc_conv1

    hls::stream<layer2_t> layer2_out("layer2_out");
    #pragma HLS STREAM variable=layer2_out depth=4096
    nnet::conv_2d_cl<layer17_t, layer2_t, config2>(layer17_out, layer2_out, w2, b2); // enc_conv1

    hls::stream<layer4_t> layer4_out("layer4_out");
    #pragma HLS STREAM variable=layer4_out depth=4096
    nnet::relu<layer2_t, layer4_t, relu_config4>(layer2_out, layer4_out); // enc_act1

    hls::stream<layer5_t> layer5_out("layer5_out");
    #pragma HLS STREAM variable=layer5_out depth=1024
    nnet::pooling2d_cl<layer4_t, layer5_t, config5>(layer4_out, layer5_out); // enc_pool1

    hls::stream<layer18_t> layer18_out("layer18_out");
    #pragma HLS STREAM variable=layer18_out depth=1156
    nnet::zeropad2d_cl<layer5_t, layer18_t, config18>(layer5_out, layer18_out); // zp2d_enc_conv2

    hls::stream<layer6_t> layer6_out("layer6_out");
    #pragma HLS STREAM variable=layer6_out depth=1024
    nnet::conv_2d_cl<layer18_t, layer6_t, config6>(layer18_out, layer6_out, w6, b6); // enc_conv2

    hls::stream<layer8_t> layer8_out("layer8_out");
    #pragma HLS STREAM variable=layer8_out depth=1024
    nnet::relu<layer6_t, layer8_t, relu_config8>(layer6_out, layer8_out); // enc_act2

    hls::stream<layer9_t> layer9_out("layer9_out");
    #pragma HLS STREAM variable=layer9_out depth=256
    nnet::pooling2d_cl<layer8_t, layer9_t, config9>(layer8_out, layer9_out); // enc_pool2

    hls::stream<layer19_t> layer19_out("layer19_out");
    #pragma HLS STREAM variable=layer19_out depth=324
    nnet::zeropad2d_cl<layer9_t, layer19_t, config19>(layer9_out, layer19_out); // zp2d_dec_conv1

    hls::stream<layer10_t> layer10_out("layer10_out");
    #pragma HLS STREAM variable=layer10_out depth=256
    nnet::conv_2d_cl<layer19_t, layer10_t, config10>(layer19_out, layer10_out, w10, b10); // dec_conv1

    hls::stream<layer12_t> layer12_out("layer12_out");
    #pragma HLS STREAM variable=layer12_out depth=256
    nnet::relu<layer10_t, layer12_t, relu_config12>(layer10_out, layer12_out); // dec_act1

    hls::stream<layer13_t> layer13_out("layer13_out");
    #pragma HLS STREAM variable=layer13_out depth=4096
    nnet::resize_nearest<layer12_t, config13>(layer12_out, layer13_out); // dec_up1

    hls::stream<layer20_t> layer20_out("layer20_out");
    #pragma HLS STREAM variable=layer20_out depth=4356
    nnet::zeropad2d_cl<layer13_t, layer20_t, config20>(layer13_out, layer20_out); // zp2d_dec_out_conv

    hls::stream<layer14_t> layer14_out("layer14_out");
    #pragma HLS STREAM variable=layer14_out depth=4096
    nnet::conv_2d_cl<layer20_t, layer14_t, config14>(layer20_out, layer14_out, w14, b14); // dec_out_conv

    nnet::relu<layer14_t, result_t, relu_config16>(layer14_out, layer16_out); // dec_out_act

}
