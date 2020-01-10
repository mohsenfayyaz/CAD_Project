//IEEE Floating Point Unit (Main module)
//Copyright (C) Hossein Entezari 2020
//2020-01-01

module Main(
        input_as,
        input_bs,
        input_ad,
        input_bd,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        process,
        clk,
        rst,
        output_zs,
        output_zd,
        output_z_stb,
        input_a_ack,
        input_b_ack);
  
  input clk;
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

  wire input_a_stb_single_divS, input_a_stb_single_sqrtS, input_a_stb_double_divS, input_a_stb_double_sqrtS, output_zS;

  wire input_a_stb_single_div, output_z_stb_single_div, input_a_ack_single_div, input_b_ack_single_div;
  wire[31:0] output_z_single_div;
  assign input_a_stb_single_div = input_a_stb & input_a_stb_single_divS;
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

  wire input_a_stb_double_sqrt, output_z_stb_double_sqrt, input_a_ack_double_sqrt;
  wire[31:0] output_z_double_sqrt;/////////////////////////
  assign input_a_stb_double_sqrt = input_a_stb & input_a_stb_double_sqrtS;
  sqrt double_sqrt_instance(
        .input_a(input_as),
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
        .output_zS);

  assign output_zs = (output_zS == 1'b0) ? output_z_single_div : output_z_single_sqrt;
  assign output_zd = (output_zS == 1'b0) ? output_z_double_div : output_z_double_sqrt;
  assign input_a_ack = &({input_a_ack_single_div, input_a_ack_single_sqrt, input_a_ack_double_div, input_a_ack_double_sqrt});
  assign input_b_ack = |({input_b_ack_single_div, input_b_ack_double_div});
  assign output_z_stb = |({output_z_stb_single_div, output_z_stb_single_sqrt, output_z_stb_double_div, output_z_stb_double_sqrt});
endmodule

module Main_controllerUnit(
        process,
        clk,
        rst,
        input_a_stb,
        output_z_stb,
        input_a_stb_single_divS,
        input_a_stb_single_sqrtS,
        input_a_stb_double_divS,
        input_a_stb_double_sqrtS,
        output_zS);

  input[1:0] process;
  input clk;
  input rst;
  input input_a_stb;
  input output_z_stb;

  output reg input_a_stb_single_divS;
  output reg input_a_stb_single_sqrtS;
  output reg input_a_stb_double_divS;
  output reg input_a_stb_double_sqrtS;
  output output_zS;

  reg[2:0] ps, ns;
  reg[1:0] process_tmp;
  parameter idle=0, fetch=1, wait_single_div=2, wait_single_sqrt=3, wait_double_div=4, wait_double_sqrt=5, wait_z_stb=6;

  assign output_zS = process_tmp[0];

  always@(posedge clk, posedge rst) begin
        if(rst == 1'b1) process_tmp <= 2'b0;
        else if(ps == idle) process_tmp <= process;
        else process_tmp <= process_tmp;
  end

  always@(posedge clk, posedge rst) begin
        if(rst == 1'b1) {ps, ns} <= 6'b0;
        else ps <= ns;
  end

  always@(ps) begin
        input_a_stb_single_divS = 1'b0;
        input_a_stb_single_sqrtS = 1'b0;
        input_a_stb_double_divS = 1'b0;
        input_a_stb_double_sqrtS = 1'b0;

        case(ps)
        idle: begin

        end
        fetch: begin

        end
        wait_single_div: input_a_stb_single_divS = 1'b1;
        wait_single_sqrt: input_a_stb_single_sqrtS = 1'b1;
        wait_double_div: input_a_stb_double_divS = 1'b1;
        wait_double_sqrt: input_a_stb_double_sqrtS = 1'b1;
        default: begin

        end
        endcase
  end

  always@(ps, input_a_stb, process, output_z_stb) begin
        case(ps)
        idle: begin
              if(input_a_stb == 1'b1) ns = fetch;
              else ns = ps;
        end
        fetch: begin
              if(process_tmp == 2'b00)      ns = wait_single_div;
              else if(process_tmp == 2'b01) ns = wait_single_sqrt;
              else if(process_tmp == 2'b10) ns = wait_double_div;
              else if(process_tmp == 2'b11) ns = wait_double_sqrt;
        end
        wait_single_div: begin
              if(output_z_stb == 1'b1) ns = wait_z_stb;
              else ns = ps;
        end
        wait_single_sqrt: begin
              if(output_z_stb == 1'b1) ns = wait_z_stb;
              else ns = ps;
        end
        wait_double_div: begin
              if(output_z_stb == 1'b1) ns = wait_z_stb;
              else ns = ps;
        end
        wait_double_sqrt: begin
              if(output_z_stb == 1'b1) ns = wait_z_stb;
              else ns = ps;
        end
        wait_z_stb: begin
              if(output_z_stb == 1'b0) ns = idle;
              else ns = ps;
        end
        default: begin
        //
        end
        endcase
  end

endmodule

module Main_TB();
  reg clk=0, rst=1;
  reg[31:0] as, bs;
  reg[63:0] ad, bd;
  wire[31:0] zs;
  wire[63:0] zd;
  reg a_stb, b_stb, z_ack;
  wire a_ack, b_ack, z_stb, ready;
  reg[1:0] process;

  always #10 clk = ~clk;
  Main main(
        .input_as(as),
        .input_bs(bs),
        .input_ad(ad),
        .input_bd(bd),
        .input_a_stb(a_stb),
        .input_b_stb(b_stb),
        .output_z_ack(z_ack),
        .process(process),
        .clk(clk),
        .rst(rst),
        .output_zs(zs),
        .output_zd(zd),
        .output_z_stb(z_stb),
        .input_a_ack(a_ack),
        .input_b_ack(b_ack));

  initial begin
  as = 0;
  a_stb = 0;
  bs = 0;
  b_stb = 0;
  rst = 1;
  z_ack = 0;
  #850 rst = 0;
  process = 2'b00;
  repeat(85) begin
    #100 z_ack = 0;
    as = $random;
    a_stb = 1;
    bs = $random;
    b_stb = 1;
    
    while(!a_ack)
      #1 a_stb = 1;
    while(a_ack)
      #1 a_stb = 1;
    a_stb = 0;

    while(!b_ack)
      #1 b_stb = 1;
    while(b_ack)
      #1 b_stb = 1;
    b_stb = 0;

    while(!z_stb)
      #580;
    #85 z_ack = 1;
    #850;
  end

  process = 2'b10;
    repeat(85) begin
      #100 z_ack = 0;
      ad = $random;
      a_stb = 1;
      bd = $random;
      b_stb = 1;

      while(!a_ack)
        #1 a_stb = 1;
      while(a_ack)
        #1 a_stb = 1;
      a_stb = 0;

      while(!b_ack)
        #1 b_stb = 1;
      while(b_ack)
        #1 b_stb = 1;
      b_stb = 0;

      while(!z_stb)
        #580;
      #85 z_ack = 1;
      #850;
    end

  process = 2'b01;
    repeat(85) begin
      #100 z_ack = 0;
      as = $random;
      a_stb = 1;

      while(!a_ack)
        #1 a_stb = 1;
      while(a_ack)
        #1 a_stb = 1;
      a_stb = 0;

      while(!z_stb)
        #580;
      #85 z_ack = 1;
      #850;
    end
    #850;
    $stop;
    end
endmodule