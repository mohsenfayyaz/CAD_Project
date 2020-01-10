
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