//IEEE Floating Point Square Root (Double Precision)
//Copyright (C) Mohsen Fayyaz 2020 "mohsenfayyaz.ir"
//2020-01-10
//
`include "defines.v"

module double_sqrt(
        input_a,
        input_a_stb,
        output_z_ack,
        clk,
        rst,
        output_z,
        output_z_stb,
        input_a_ack);

  input     clk;
  input     rst;

  input     [63:0] input_a;
  input     input_a_stb;
  output    input_a_ack;

  output    [63:0] output_z;
  output    output_z_stb;
  input     output_z_ack;

  reg       s_output_z_stb;
  reg       [63:0] s_output_z;
  reg       s_input_a_ack;

  reg       [3:0] state;
  parameter get_a         = 4'd0,
            //get_b         = 4'd1,
            unpack        = 4'd2,
            special_cases = 4'd3,
            normalise_a   = 4'd4,
            //normalise_b   = 4'd5,
            sqrt_0      = 4'd6,
            sqrt_1      = 4'd7,
            sqrt_2      = 4'd8,
            sqrt_3      = 4'd9,
            normalise_1   = 4'd10,
            normalise_2   = 4'd11,
            round         = 4'd12,
            pack          = 4'd13,
            put_z         = 4'd14;
  
  reg       [63:0] a, b, z;
  reg       [52:0] a_m, b_m, z_m;
  reg       [12:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       [6:0] count;
  
  reg   [63:0] divider_a, divider_b;
  wire  [63:0] divider_z;
  reg divider_a_stb, divider_b_stb, divider_z_ack;
  wire divider_a_ack, divider_b_ack, divider_z_stb;
  double_divider divider_0(
    .clk(clk),
    .rst(rst),
    .input_a(divider_a),
    .input_a_stb(divider_a_stb),
    .input_a_ack(divider_a_ack),
    .input_b(divider_b),
    .input_b_stb(divider_b_stb),
    .input_b_ack(divider_b_ack),
    .output_z(divider_z),
    .output_z_stb(divider_z_stb),
    .output_z_ack(divider_z_ack));
  
  reg   [63:0] adder_a, adder_b;
  wire   [63:0] adder_z;
  reg adder_a_stb, adder_b_stb, adder_z_ack;
  wire adder_a_ack, adder_b_ack, adder_z_stb;
  double_adder adder_0(
    .clk(clk),
    .rst(rst),
    .input_a(adder_a),
    .input_a_stb(adder_a_stb),
    .input_a_ack(adder_a_ack),
    .input_b(adder_b),
    .input_b_stb(adder_b_stb),
    .input_b_ack(adder_b_ack),
    .output_z(adder_z),
    .output_z_stb(adder_z_stb),
    .output_z_ack(adder_z_ack));
    
  function [63:0] divide_exponent_function;
    input[63:0] in;
    divide_exponent_function = {in[63], ((in[62:52]-1023) >> 1) + 1023, in[51:0]};
  endfunction

  reg[63:0] sqrt_n, sqrt_n_new;
  always @(posedge clk)
  begin

    case(state)

      get_a:
      begin
        s_input_a_ack <= 1;
        if (s_input_a_ack && input_a_stb) begin
          a <= input_a;
          s_input_a_ack <= 0;
          state <= unpack;
        end
      end

      unpack:
      begin
        a_m <= a[51 : 0];
        a_e <= a[62 : 52] - 1023;
        a_s <= a[63];
        state <= special_cases;
      end

      special_cases:
      begin
        //if a is less than 0 return NaN 
        if (a_s == 1) begin
          z[63] <= 1;
          z[62:52] <= 2047;
          z[51] <= 1;
          z[50:0] <= 0;
          state <= put_z;
        //if a is NaN or b is NaN return NaN 
        end else if (a_e == 1024 && a_m != 0) begin
          z[63] <= 1;
          z[62:52] <= 2047;
          z[51] <= 1;
          z[50:0] <= 0;
          state <= put_z;
        //if a is inf return inf
        end else if (a_e == 1024) begin
          z[63] <= 0;
          z[62:52] <= 2047;
          z[51:0] <= 0;
          state <= put_z;
        //if a is zero return zero
        end else if (($signed(a_e) == -1023) && (a_m == 0)) begin
          z[63] <= 0;
          z[62:52] <= 0;
          z[51:0] <= 0;
          state <= put_z;
        end else begin
          //Denormalised Number
          if ($signed(a_e) == -1023) begin
            a_e <= -1022;
          end else begin
            a_m[52] <= 1;
          end
          state <= normalise_a;
        end
      end

      normalise_a:
      begin
        if (a_m[52]) begin
          state <= sqrt_0;
        end else begin
          a_m <= a_m << 1;
          a_e <= a_e - 1;
        end
      end

      sqrt_0:
      begin
        z_s <= a_s;
        z_e <= a_e >> 1; // a_e/2
        sqrt_n <= divide_exponent_function(a);  // a with half power of 2 as X0
        //sqrt_n <= a;
        count <= 0;
        
        state <= sqrt_1;
      end

      sqrt_1:  // a/x_n
      begin
        divider_a <= a;
        divider_b <= sqrt_n;
        divider_a_stb <= 1;
        divider_b_stb <= 1;
        divider_z_ack <= 0;
        if(divider_z_stb) 
        begin
          //$display("%b/%b = %b", a, sqrt_n, divider_z);
          state <= sqrt_2;
          sqrt_n_new <= divider_z;
          divider_z_ack <= 1;
          divider_a_stb <= 0;
          divider_b_stb <= 0;
        end
      end

      sqrt_2:  // 1/2(x+a/x)
      begin
        adder_a <= sqrt_n_new;
        adder_b <= sqrt_n;
        adder_a_stb <= 1;
        adder_b_stb <= 1;
        adder_z_ack <= 0;
        if(adder_z_stb)
        begin
          //$display("%b+%b = %b", sqrt_n_new, sqrt_n, {adder_z[63], adder_z[62:52] - 1, adder_z[51:0]});
          //$display("%b+%b/2 = %b", sqrt_n_new, sqrt_n, adder_z);
          adder_a_stb <= 0;
          adder_b_stb <= 0;
          adder_z_ack <= 1;
          if(`DEBUGGING)
            s_output_z <= sqrt_n;  //Show results before finsihing calculation
          
          if(count == `DOUBLE_SQRT_MAX_LOOP || sqrt_n == {adder_z[63], adder_z[62:52] - 1, adder_z[51:0]})  // -1 will divide by 2 // 1/2(x+a/x)
          begin
            z <= {adder_z[63], adder_z[62:52] - 1, adder_z[51:0]};
            state <= put_z;
          end else begin
            state <= sqrt_1;
            count <= count + 1;
            sqrt_n <= {adder_z[63], adder_z[62:52] - 1, adder_z[51:0]};  // 1/2(x+a/x)
          end
        end
      end

      put_z:
      begin
        s_output_z_stb <= 1;
        s_output_z <= z;
        if (s_output_z_stb && output_z_ack) begin
          s_output_z_stb <= 0;
          state <= get_a;
        end
      end

    endcase

    if (rst == 1) begin
      state <= get_a;
      s_input_a_ack <= 0;
      s_output_z_stb <= 0;
    end

  end
  assign input_a_ack = s_input_a_ack;
  assign output_z_stb = s_output_z_stb;
  assign output_z = s_output_z;

endmodule




