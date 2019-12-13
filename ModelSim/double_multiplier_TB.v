`timescale 1ns/1ns 

module multiplierTB();
  reg clk=0, rst=1;
  reg   [63:0] a, b;
  wire   [63:0] z;
  reg a_stb, b_stb, z_ack;
  wire a_ack, b_ack, z_stb;
  
  always #10 clk=~clk;  // 25MHz
  
  double_multiplier double_multiplier_39759952(
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
    a = 32'b00111111110100111110010000100110;
    b = 32'b01000001000010101000001100010010;
    a_stb = 1;
    b_stb = 1;
    #2000;
    $stop;  
  end
endmodule