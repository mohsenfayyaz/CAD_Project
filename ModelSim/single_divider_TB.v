`timescale 1ns/1ns 
`include "defines.v"

module dividerTB();
  reg clk=0, rst=1;
  reg   [31:0] a, b;
  wire   [31:0] z;
  reg a_stb, b_stb, z_ack;
  wire a_ack, b_ack, z_stb;
  integer fd;
  
  always #10 clk=~clk;  // 25MHz
  
  divider_newton divider_0(
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
    fd = $fopen(`SINGLE_DIVIDER_OUTPUT_FILE_NAME,"w");
    
    a = 0;
    b = 0;
    rst = 1;
    #1000
    rst = 0;
    
    repeat(100) begin
    z_ack = 0;
    //a = 32'b01000001110010000000000000000000;
    //a = 32'b00111111011111101101111000000101;
    a = $random;
    a_stb = 1;
    b = $random;
    b_stb = 1;
    #100;
    a_stb = 0;
    b_stb = 0;
    while(!z_stb)
      #500;
    #10000;
    $fwrite(fd, "%b %b %b\n", a, b, z);  //Unsigned Integer
    z_ack = 1;
    # 100;
    
    end
    
    $fclose(fd);  
    $stop;  
  end
endmodule


