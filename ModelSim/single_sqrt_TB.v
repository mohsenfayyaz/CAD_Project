`timescale 1ns/1ns 

module sqrtTB();
  reg clk=0, rst=1;
  reg   [31:0] a;
  wire   [31:0] z;
  reg a_stb, z_ack;
  wire a_ack, z_stb;
  integer fd;
  
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
    fd = $fopen("output.txt","w");
    
    a = 0;
    rst = 1;
    #1000
    rst = 0;
    
    repeat(10) begin
    z_ack = 0;
    //a = 32'b01000001110010000000000000000000;
    //a = 32'b00111111011111101101111000000101;
    a = $random;
    a_stb = 1;
    #100;
    a_stb = 0;
    #500000;
    $fwrite(fd, "%b %b\n", a, z);  //Unsigned Integer
    z_ack = 1;
    # 100;
    
    end
    
    $fclose(fd);  
    $stop;  
  end
endmodule


