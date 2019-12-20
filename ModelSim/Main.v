//IEEE Floating Point Adder (Single Precision)
//IEEE Floating Point Unit (Main module)
//Copyright (C) Hossein Entezari 2019
//2013-12-20

module Main_single(
        input_a,
        input_b,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        process,
        clk,
        rst,
        output_z,
        output_z_stb,
        input_a_ack,
        input_b_ack
);
  input clk;
  input rst;
  input process;
  
  input     [31:0] input_a;
  input     input_a_stb;
  output    input_a_ack;
  
  input     [31:0] input_b;
  input     input_b_stb;
  output    input_b_ack;
  
  output    [31:0] output_z;
  output    output_z_stb;
  input     output_z_ack;

  wire input_a_stbD, input_b_stbD, input_a_ackD, input_b_ackD;
  wire input_a_stbS, input_a_ackS;

  Main_single_DP dp(input_a, input_b, input_a_stbD, input_b_stbD, input_a_stbS, output_z_ack, clk, rst, output_z,
                    output_z_stb, input_a_ackD, input_b_ackD, input_a_ackS);
  Main_single_CU cu(input_a_stb, input_b_stb, output_z_ack, output_z_stb, process, clk, rst, input_a_ack,
                    input_b_ack, input_a_stbD, input_b_stbD, input_a_stbS, input_a_ackD, input_b_ackD,
                    input_a_ackS);  
endmodule


module Main_single_DP(
        input_a,
        input_b,
        input_a_stbD,
        input_b_stbD,
        input_a_stbS,
        output_z_ack,
        clk,
        rst,
        output_z,
        output_z_stb,
        input_a_ackD,
        input_b_ackD,
        input_a_ackS
);
  input clk;
  input rst;
  
  input     [31:0] input_a;
  input     input_a_stbD;
  input     input_a_stbS;
  output    input_a_ackD;
  output    input_a_ackS;
  
  input     [31:0] input_b;
  input     input_b_stbD;
  output    input_b_ackD;
  
  output    [31:0] output_z;
  output    output_z_stb;
  input     output_z_ack;

  wire output_z_stbD, output_z_stbS;
  wire[31:0] output_zD, output_zS;

  divider dividerInstance(input_a,
                          input_b,
                          input_a_stbD,
                          input_b_stbD,
                          output_z_ack, 
                          clk,
                          rst,
                          output_zD,
                          output_z_stbD,
                          input_a_ackD,
                          input_b_ackD);
  
  sqrt sqrtInstance(input_a,
                    input_a_stbS,
                    output_z_ack,
                    clk,
                    rst,
                    output_zS,
                    output_z_stbS,
                    input_a_ackS);
  
  assign output_z = (output_z_stbD == 1'b1)?output_zD : (output_z_stbS == 1'b1)?output_zS: 32'b0;
  assign output_z_stb = output_z_stbD | output_z_stbS;
endmodule

module Main_single_CU(
        input_a_stb,
        input_b_stb,
        output_z_ack,
        output_z_stb,
        process,
        clk,
        rst,
        input_a_ack,
        input_b_ack,
        input_a_stbD,
        input_b_stbD,
        input_a_stbS,
        input_a_ackD,
        input_b_ackD,
        input_a_ackS
);
  input clk;
  input rst;
  input process;
  
  input     input_a_stb;
  output    input_a_ack;

  input     input_b_stb;
  output    input_b_ack;
  
  input     output_z_ack;
  input     output_z_stb;

  output reg  input_a_stbD;
  output reg  input_b_stbD;
  output reg  input_a_stbS;

  input     input_a_ackD;
  input     input_b_ackD;
  input     input_a_ackS;

  reg[2:0] ps, ns;
  parameter idle=0, wait_div=1, wait_sqrt=2, calc_div=3, calc_sqrt=4, wait_ack=5;

  always@(ps) begin
    case(ps):
    input_a_stbD = 1'b0;
    input_b_stbD = 1'b0;
    input_a_stbS = 1'b0;


    idle: begin
    //
    end
    wait_div: begin
      input_a_stbD = 1'b1;
      input_b_stbD = 1'b1;
    end
    wait_sqrt: begin
      input_a_stbS = 1'b1;
    end
    calc_div: begin
    //
    end
    calc_sqrt: begin
    //
    end
    wait_ack: begin
    //
    end
    endcase
  end

  always@(process, input_a_stb, input_b_stb, output_z_ack, input_a_ackD, input_b_ackD, input_a_ackS) begin
    ns = ps;
    case(ps):
    idle: begin
      if({input_a_stb, input_b_stb, process} == 3'b110) ns = wait_div;
      else if({input_a_stb, process} == 2'b11) ns = wait_sqrt;
      else ns = ps;
    end
    wait_div: begin
      if({input_a_ackD, input_b_ackD} == 2'b11) ns = calc_div;
      else ns = ps;
    end
    wait_sqrt: begin
      if({input_a_ackS} == 1'b1) ns = calc_sqrt;
      else ns = ps;
    end
    calc_div: begin
      if(output_z_stb == 1'b1) ns = wait_ack;
      else ns = ps;
    end
    calc_sqrt: begin
      if(output_z_stb == 1'b1) ns = wait_ack;
      else ns = ps;
    end
    wait_ack: begin
      if(output_z_ack == 1'b1) ns = idle;
      else ns = ps;
    end
    endcase
  end

  always@(posedge clk, posedge rst) begin
    if(rst == 1'b1) {clk, rst} <= 2'b0;
    else begin
      ps <= ns;
    end
  end

endmodule