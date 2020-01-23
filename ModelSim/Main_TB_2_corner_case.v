//IEEE Floating Point Integration Test (Corner Cases Test)
//Copyright (C) Mohsen Fayyaz 2019 "mohsenfayyaz.ir"
//2019-1-15
//
`timescale 1ns/1ns 
`include "defines.v"

module Main_TB_2_corner_case();
  reg clk=0, rst=1;
  reg[31:0] a_single, b_single;
  reg[63:0] a_double, b_double;
  wire[31:0] z_single;
  wire[63:0] z_double;
  reg a_stb, b_stb, z_ack;
  wire a_ack, b_ack, z_stb;
  reg[1:0] process;
  integer i;
  integer fd;
  
  always #10 clk = ~clk;  // 25MHz
  
  Main main(
        .input_as(a_single),
        .input_bs(b_single),
        .input_ad(a_double),
        .input_bd(b_double),
        .input_a_stb(a_stb),
        .input_b_stb(b_stb),
        .output_z_ack(z_ack),
        .process(process),
        .clk(clk),
        .rst(rst),
        .output_zs(z_single),
        .output_zd(z_double),
        .output_z_stb(z_stb),
        .input_a_ack(a_ack),
        .input_b_ack(b_ack));

  reg[31:0] a_single_tests[0:20];
  reg[31:0] b_single_tests[0:20];
  reg[63:0] a_double_tests[0:20];
  reg[63:0] b_double_tests[0:20];
  initial begin
    // <SINGLE CORNER CASES
    // Extremely small normalised numbers
    a_single_tests[0] = 32'b10000000100000000000000000000000;
    b_single_tests[0] = 32'b00000000100000000000000000000001;
    a_single_tests[1] = 32'b00000001100000000000000000000110;
    b_single_tests[1] = 32'b10001101000000000000000000000110;
    // Extremely small denormalised numbers
    a_single_tests[2] = 32'b00000000000000000000000000000001;
    b_single_tests[2] = 32'b10000000000000000000000000000010;
    a_single_tests[3] = 32'b00000000000101000001000000100101;
    b_single_tests[3] = 32'b00000000011111111111111111111111;
    // Extremely large normalised numbers
    a_single_tests[4] = 32'b01111111010101010101010101010111;
    b_single_tests[4] = 32'b11111110111111111111111111111101;
    a_single_tests[5] = 32'b01111111011111111111111111111110;
    b_single_tests[5] = 32'b11111101011011011110101101111110;
    // Mixed Extreme cases
    a_single_tests[6] = 32'b11111110011111011110111111111010;
    b_single_tests[6] = 32'b00000000011000010101011101100010;
    a_single_tests[7] = 32'b00001101101000011000000101000001;
    b_single_tests[7] = 32'b11101011010010011010110100100010;
    // Special Cases
    a_single_tests[8] = 32'b01111111101000011000000101000001; //NAN
    b_single_tests[8] = 32'b00000000011000010101011101100010;
    a_single_tests[9] = 32'b01111111100000000000000000000000; //INF
    b_single_tests[9] = 32'b01111111100000000000000000000000; //INF
    a_single_tests[10] = 32'b01111111010101010101010101010110;
    b_single_tests[10] = 32'b01111111100000000000000000000000; //INF
    a_single_tests[11] = 32'b01111010101110100000011010011111;
    b_single_tests[11] = 32'b00000000000000000000000000000000; //0
    // SINGLE CORNER CASES/>
    
    // <DOUBLE CORNER CASES
    // Extremely small normalised numbers
    a_double_tests[0] = 64'b0000000000010000010000000001000000000100000010001000001010000001;
    b_double_tests[0] = 64'b0000000001000000010110000001000100000100100101100010001000001100;
    a_double_tests[1] = 64'b0000000010000010110100010100011010010101101111101100101001000010;
    b_double_tests[1] = 64'b0000001000000111001100000000010011110100011101101110100001000110;
    // Extremely small denormalised numbers
    a_double_tests[2] = 64'b0000000000000000000000000000000000000000000000000000000000000001;
    b_double_tests[2] = 64'b0000000000000010000000100000010001000100000010011000010001010000;
    a_double_tests[3] = 64'b0000000000000000000000110000110001010100000111011000011101100011;
    b_double_tests[3] = 64'b0000000000000000000000001110000001010100000110010100011101100010;
    // Extremely large normalised numbers
    a_double_tests[4] = 64'b0111111110111111101111111101111101110111101111111111111101110111;
    b_double_tests[4] = 64'b1111111011101111111111111111111111111111111111111111111111111010;
    a_double_tests[5] = 64'b0111111111000101101101101101110100110110101101111111011101010111;
    b_double_tests[5] = 64'b1111111110111111101111111101111101110111101111111111111101110111;
    // Mixed Extreme cases
    a_double_tests[6] = 64'b0111111111000101101101101101110100110110101101111111011101010111;
    b_double_tests[6] = 64'b0000000000000000000000000010101100110001000100101000000000000000;
    a_double_tests[7] = 64'b0000000000000000000000000000000001010100000110010100011101100010;
    b_double_tests[7] = 64'b0111111111000101101101101101110100110110101101111111011101010111;
    // Special Cases
    a_double_tests[8] = 64'b0111111111111101101101101101110001110010100101101111111101010101; //NAN
    b_double_tests[8] = 64'b0111111111000101101101101101110100110110101101111111011101010111;
    a_double_tests[9] = 64'b0111111111110000000000000000000000000000000000000000000000000000; //INF
    b_double_tests[9] = 64'b0111111111110000000000000000000000000000000000000000000000000000; //INF
    a_double_tests[10] = 64'b0000000000000010000000100000010001000100000010011000010001010001;
    b_double_tests[10] = 64'b1111111111110000000000000000000000000000000000000000000000000000; //-INF
    a_double_tests[11] = 64'b0000000000000000000000000000000001010100000110010100011101100010;
    b_double_tests[11] = 64'b0000000000000000000000000000000000000000000000000000000000000000; //0
    // SINGLE CORNER CASES/>
    
    
    process = `PROCESS_SINGLE_DIVIDER;
    fd = $fopen(`SINGLE_DIVIDER_OUTPUT_FILE_NAME,"w");
    {a_single, b_single} = 0;
    rst = 1;
    #1000
    rst = 0;
    for (i = 0; i < 12; i = i + 1) begin
      z_ack = 0;
      a_single = a_single_tests[i];
      a_stb = 1;
      b_single = b_single_tests[i];
      b_stb = 1;
      #100;
      a_stb = 0;
      b_stb = 0;
      while(!z_stb)
        #500;
      #10000;
      $fwrite(fd, "%b %b %b\n", a_single, b_single, z_single);  //Unsigned Integer
      z_ack = 1;
      # 100;
    end
    $fclose(fd);  
    $display("File Created: %s", `SINGLE_DIVIDER_OUTPUT_FILE_NAME);
    
    
    process = `PROCESS_SINGLE_SQRT;
    fd = $fopen(`SINGLE_SQRT_OUTPUT_FILE_NAME,"w");
    {a_single, b_single} = 0;
    #1000
    for (i = 0; i < 12; i = i + 1) begin
      z_ack = 0;
      a_single = a_single_tests[i];
      a_stb = 1;
      #100;
      a_stb = 0;
      while(!z_stb)
        #500;
      #10000;
      $fwrite(fd, "%b %b\n", a_single, z_single);  //Unsigned Integer
      z_ack = 1;
      # 100;
    end
    $fclose(fd);  
    $display("File Created: %s", `SINGLE_SQRT_OUTPUT_FILE_NAME);
    
    
    process = `PROCESS_DOUBLE_DIVIDER;
    fd = $fopen(`DOUBLE_DIVIDER_OUTPUT_FILE_NAME,"w");
    {a_double, b_double} = 0;
    #1000
    for (i = 0; i < 12; i = i + 1) begin
      z_ack = 0;
      a_double = a_double_tests[i];
      a_stb = 1;
      b_double = b_double_tests[i];
      b_stb = 1;
      #100;
      a_stb = 0;
      b_stb = 0;
      while(!z_stb)
        #500;
      #10000;
      $fwrite(fd, "%b %b %b\n", a_double, b_double, z_double);  //Unsigned Integer
      z_ack = 1;
      # 100;
    end
    $fclose(fd);  
    $display("File Created: %s", `DOUBLE_DIVIDER_OUTPUT_FILE_NAME);
    
    
    process = `PROCESS_DOUBLE_SQRT;
    fd = $fopen(`DOUBLE_SQRT_OUTPUT_FILE_NAME,"w");
    {a_double, b_double} = 0;
    #1000
    for (i = 0; i < 12; i = i + 1) begin
      z_ack = 0;
      a_double = a_double_tests[i];
      a_stb = 1;
      #100;
      a_stb = 0;
      while(!z_stb)
        #500;
      #10000;
      $fwrite(fd, "%b %b\n", a_double, z_double);  //Unsigned Integer
      z_ack = 1;
      # 100;
    end
    $fclose(fd);
    $display("File Created: %s", `DOUBLE_SQRT_OUTPUT_FILE_NAME);
    
    
    $stop;
  end

endmodule

