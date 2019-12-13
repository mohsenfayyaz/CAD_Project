`timescale 1ns/1ns 

module adderDoubleTB();
  reg clk=0, rst=1;
  reg   [63:0] a, b;
  wire   [63:0] z;
  reg a_stb, b_stb, z_ack;
  wire a_ack, b_ack, z_stb;
  
  always #10 clk=~clk;  // 25MHz
  
  double_adder double_adder_39759952(
    .clk(clk),
    .rst(rst),
    .input_a(a),
    .input_a_stb(a_stb),
    .input_a_ack(a_ack),
    .input_b(b),
    .input_b_stb(b_stb),
    .input_b_ack(b_ack),
    .output_z(z),
    .output_z_stb(z_stb),
    .output_z_ack(z_ack));
  initial begin
    a = 0;
    b = 0;
    rst = 1;
    #1000
    rst = 0;
   //  85.85858585
    a = 64'b0100000001010101011101101111001100010010000100001010001110111100;
   //  58.588558855885
    b = 64'b0100000001001101010010110101010111100101100001101110011000001100;
   //       0100000001100010000011100100111100000010011010100000101101100001
   // 1.44447144705884994664302212186E2
    a_stb = 1;
    b_stb = 1;
    #2000;
    $stop;  
  end
endmodule
