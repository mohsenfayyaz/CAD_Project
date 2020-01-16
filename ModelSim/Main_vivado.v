//IEEE Floating Point Unit (Main module)
//Copyright (C) Hossein Entezari 2020
//2020-01-01
`include "defines.v"

module Main_vivado(
        input_as,  // single
        input_bs,  // single
        input_ad,  // double
        input_bd,  // double
        input_a_stb,
        input_b_stb,
        output_z_ack,
        process,
        fpga_clk,
        rst,
        output_zs,
        output_zd,
        output_z_stb,
        input_a_ack,
        input_b_ack);
  
  input fpga_clk;
  input rst;
  input[1:0] process;
  
  input     [31:0] input_as;
  input     [63:0] input_ad;
  input     input_a_stb;
  output    input_a_ack;
  
  input     [31:0] input_bs;
  input     [63:0] input_bd;
  input     input_b_stb;
  output    input_b_ack;
  
  output    [31:0] output_zs;
  output    [63:0] output_zd;
  output    output_z_stb;
  input     output_z_ack;
   
  wire locked, clk;
  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(fpga_clk));    // input clk_in1
    
  wire input_a_stb_single_divS, input_a_stb_single_sqrtS, input_a_stb_double_divS, input_a_stb_double_sqrtS, output_zS;

  wire input_a_stb_single_div, output_z_stb_single_div, input_a_ack_single_div, input_b_ack_single_div;
  wire[31:0] output_z_single_div;
  assign input_a_stb_single_div = input_a_stb & input_a_stb_single_divS;
  
  
  `ifndef NEWTON_MODE
  divider single_divider_instance(
        .input_a(input_as),
        .input_b(input_bs),
        .input_a_stb(input_a_stb_single_div),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_single_div),
        .output_z_stb(output_z_stb_single_div),
        .input_a_ack(input_a_ack_single_div),
        .input_b_ack(input_b_ack_single_div));
  `else
  divider_newton single_divider_newton_instance(
        .input_a(input_as),
        .input_b(input_bs),
        .input_a_stb(input_a_stb_single_div),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_single_div),
        .output_z_stb(output_z_stb_single_div),
        .input_a_ack(input_a_ack_single_div),
        .input_b_ack(input_b_ack_single_div));
  `endif
  
  wire input_a_stb_single_sqrt, output_z_stb_single_sqrt, input_a_ack_single_sqrt;
  wire[31:0] output_z_single_sqrt;
  assign input_a_stb_single_sqrt = input_a_stb & input_a_stb_single_sqrtS;
  sqrt single_sqrt_instance(
        .input_a(input_as),
        .input_a_stb(input_a_stb_single_sqrt),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_single_sqrt),
        .output_z_stb(output_z_stb_single_sqrt),
        .input_a_ack(input_a_ack_single_sqrt));

  wire input_a_stb_double_div, output_z_stb_double_div, input_a_ack_double_div, input_b_ack_double_div;
  wire[63:0] output_z_double_div;
  assign input_a_stb_double_div = input_a_stb & input_a_stb_double_divS;
  
  `ifndef NEWTON_MODE
  double_divider double_divider_instance(
        .input_a(input_ad),
        .input_b(input_bd),
        .input_a_stb(input_a_stb_double_div),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_double_div),
        .output_z_stb(output_z_stb_double_div),
        .input_a_ack(input_a_ack_double_div),
        .input_b_ack(input_b_ack_double_div));
  `else
    double_divider_newton double_divider_newton_instance(
        .input_a(input_ad),
        .input_b(input_bd),
        .input_a_stb(input_a_stb_double_div),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_double_div),
        .output_z_stb(output_z_stb_double_div),
        .input_a_ack(input_a_ack_double_div),
        .input_b_ack(input_b_ack_double_div));
  `endif

  wire input_a_stb_double_sqrt, output_z_stb_double_sqrt, input_a_ack_double_sqrt;
  wire[63:0] output_z_double_sqrt;/////////////////////////
  assign input_a_stb_double_sqrt = input_a_stb & input_a_stb_double_sqrtS;
  double_sqrt double_sqrt_instance(
        .input_a(input_ad),
        .input_a_stb(input_a_stb_double_sqrt),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst),
        .output_z(output_z_double_sqrt),
        .output_z_stb(output_z_stb_double_sqrt),
        .input_a_ack(input_a_ack_double_sqrt));
  

  Main_controllerUnit Controller_unit_instance(
        .process(process),
        .clk(clk),
        .rst(rst),
        .input_a_stb(input_a_stb),
        .output_z_stb(output_z_stb),
        .input_a_stb_single_divS(input_a_stb_single_divS),
        .input_a_stb_single_sqrtS(input_a_stb_single_sqrtS),
        .input_a_stb_double_divS(input_a_stb_double_divS),
        .input_a_stb_double_sqrtS(input_a_stb_double_sqrtS),
        .output_zS(output_zS));

  assign output_zs = (output_zS == 1'b0) ? output_z_single_div : output_z_single_sqrt;
  assign output_zd = (output_zS == 1'b0) ? output_z_double_div : output_z_double_sqrt;
  assign input_a_ack = &({input_a_ack_single_div, input_a_ack_single_sqrt, input_a_ack_double_div, input_a_ack_double_sqrt});
  assign input_b_ack = |({input_b_ack_single_div, input_b_ack_double_div});
  assign output_z_stb = |({output_z_stb_single_div, output_z_stb_single_sqrt, output_z_stb_double_div, output_z_stb_double_sqrt});
endmodule