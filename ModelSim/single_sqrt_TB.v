`timescale 1ns/1ns 

module sqrtTB();
  reg clk=0, rst=1;
  reg   [31:0] a;
  wire   [31:0] z;
  reg a_stb, z_ack;
  wire a_ack, z_stb;
  
  always #10 clk=~clk;  // 25MHz
  
  sqrt sqrt_UUT(
    .clk(clk),
    .rst(rst),
    .input_a(a),
    .input_a_stb(a_stb),
    .input_a_ack(a_ack),
    .output_z(z),
    .output_z_stb(z_stb),
    .output_z_ack(z_ack));
  initial begin
    a = 0;
    rst = 1;
    #1000
    rst = 0;
    a = 32'b01000001110010000000000000000000;
    a_stb = 1;
    #100;
    a_stb = 0;
    #800000;
    $stop;  
  end
endmodule


