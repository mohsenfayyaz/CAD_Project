//IEEE Floating Point Divider (Double Precision)
//Copyright (C) Mohsen Fayyaz 2020 "mohsenfayyaz.ir"
//2020-01-10
//
`include "defines.v"

module double_divider_newton(
        input_a,
        input_b,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        clk,
        rst,
        output_z,
        output_z_stb,
        input_a_ack,
        input_b_ack);

  input     clk;
  input     rst;

  input     [63:0] input_a;
  input     input_a_stb;
  output    input_a_ack;

  input     [63:0] input_b;
  input     input_b_stb;
  output    input_b_ack;

  output    [63:0] output_z;
  output    output_z_stb;
  input     output_z_ack;

  reg       s_output_z_stb;
  reg       [63:0] s_output_z;
  reg       s_input_a_ack;
  reg       s_input_b_ack;

  reg       [3:0] state;
  parameter get_a         = 4'd0,
            get_b         = 4'd1,
            unpack        = 4'd2,
            special_cases = 4'd3,
            normalise_a   = 4'd4,
            normalise_b   = 4'd5,
            divide_0      = 4'd6,
            divide_1      = 4'd7,
            divide_2      = 4'd8,
            divide_3      = 4'd9,
            divide_4      = 4'd10,
            divide_5      = 4'd11,
            round         = 4'd12,
            pack          = 4'd13,
            put_z         = 4'd14;

  reg       [63:0] a, b, z;
  reg       [52:0] a_m, b_m, z_m;
  reg       [12:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, round_bit, sticky;
  reg       [108:0] quotient, divisor, dividend, remainder;
  reg       [6:0] count;
  
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
    
  reg   [63:0] multiplier_a, multiplier_b;
  wire   [63:0] multiplier_z;
  reg multiplier_a_stb, multiplier_b_stb, multiplier_z_ack;
  wire multiplier_a_ack, multiplier_b_ack, multiplier_z_stb;
  double_multiplier multiplier_0(
    .clk(clk),
    .rst(rst),
    .input_a(multiplier_a),
    .input_a_stb(multiplier_a_stb),
    .input_a_ack(multiplier_a_ack),
    .input_b(multiplier_b),
    .input_b_stb(multiplier_b_stb),
    .input_b_ack(multiplier_b_ack),
    .output_z(multiplier_z),
    .output_z_stb(multiplier_z_stb),
    .output_z_ack(multiplier_z_ack));
  
  function [63:0] abs_invert_exponent_function;
    input[63:0] in;
    abs_invert_exponent_function = {1'b0, 2046 - in[62:52] - 1, in[51:0]};  // and a minus 1 so that the approximation becomes less than real division to converge
  endfunction
  
  reg[63:0] x_n, x_n_new;
  
  always @(posedge clk)
  begin

    case(state)

      get_a:
      begin
        s_input_a_ack <= 1;
        if (s_input_a_ack && input_a_stb) begin
          a <= input_a;
          s_input_a_ack <= 0;
          state <= get_b;
        end
      end

      get_b:
      begin
        s_input_b_ack <= 1;
        if (s_input_b_ack && input_b_stb) begin
          b <= input_b;
          s_input_b_ack <= 0;
          state <= unpack;
        end
      end

      unpack:
      begin
        a_m <= a[51 : 0];
        b_m <= b[51 : 0];
        a_e <= a[62 : 52] - 1023;
        b_e <= b[62 : 52] - 1023;
        a_s <= a[63];
        b_s <= b[63];
        state <= special_cases;
      end

      special_cases:
      begin
        //if a is NaN or b is NaN return NaN 
        if ((a_e == 1024 && a_m != 0) || (b_e == 1024 && b_m != 0)) begin
          z[63] <= 1;
          z[62:52] <= 2047;
          z[51] <= 1;
          z[50:0] <= 0;
          state <= put_z;
          //if a is inf and b is inf return NaN 
        end else if ((a_e == 1024) && (b_e == 1024)) begin
          z[63] <= 1;
          z[62:52] <= 2047;
          z[51] <= 1;
          z[50:0] <= 0;
          state <= put_z;
        //if a is inf return inf
        end else if (a_e == 1024) begin
          z[63] <= a_s ^ b_s;
          z[62:52] <= 2047;
          z[51:0] <= 0;
          state <= put_z;
           //if b is zero return NaN
          if ($signed(b_e == -1023) && (b_m == 0)) begin
            z[63] <= 1;
            z[62:52] <= 2047;
            z[51] <= 1;
            z[50:0] <= 0;
            state <= put_z;
          end
        //if b is inf return zero
        end else if (b_e == 1024) begin
          z[63] <= a_s ^ b_s;
          z[62:52] <= 0;
          z[51:0] <= 0;
          state <= put_z;
        //if a is zero return zero
        end else if (($signed(a_e) == -1023) && (a_m == 0)) begin
          z[63] <= a_s ^ b_s;
          z[62:52] <= 0;
          z[51:0] <= 0;
          state <= put_z;
           //if b is zero return NaN
          if (($signed(b_e) == -1023) && (b_m == 0)) begin
            z[63] <= 1;
            z[62:52] <= 2047;
            z[51] <= 1;
            z[50:0] <= 0;
            state <= put_z;
          end
        //if b is zero return inf
        end else if (($signed(b_e) == -1023) && (b_m == 0)) begin
          z[63] <= a_s ^ b_s;
          z[62:52] <= 2047;
          z[51:0] <= 0;
          state <= put_z;
        end else begin
          //Denormalised Number
          if ($signed(a_e) == -1023) begin
            a_e <= -1022;
          end else begin
            a_m[52] <= 1;
          end
          //Denormalised Number
          if ($signed(b_e) == -1023) begin
            b_e <= -1022;
          end else begin
            b_m[52] <= 1;
          end
          state <= divide_0;
        end
      end
      
      divide_0:
      begin
        z_s <= a_s ^ b_s;
        z_e <= a_e - b_e;

        x_n <= abs_invert_exponent_function(b);  // b with inverted power of 2 as X0
        b <= {1'b0, b[62:0]};  // abs of b
        count <= 0;
        
        state <= divide_1;
      end

      divide_1:  // (D=b) * Xi
      begin
        multiplier_a <= b;
        multiplier_b <= x_n;
        multiplier_a_stb <= 1;
        multiplier_b_stb <= 1;
        multiplier_z_ack <= 0;
        if(multiplier_z_stb)
        begin
          state <= divide_2;
          x_n_new <= multiplier_z;
          //$display("->x_n %b", x_n);
          //$display("->b %b", b);
          //$display("->x_n_new_multiply %b", multiplier_z);
          multiplier_z_ack <= 1;
          multiplier_a_stb <= 0;
          multiplier_b_stb <= 0;
        end
      end

      divide_2:  // 2 - (DXi=x_n_new)
      begin
        adder_a <= `FLOATING_POINT_DOUBLE_2;
        adder_b <= {1'b1, x_n_new[62:0]};  // minus
        adder_a_stb <= 1;
        adder_b_stb <= 1;
        adder_z_ack <= 0;
        if(adder_z_stb) 
        begin
          state <= divide_3;
          x_n_new <= adder_z;
          //$display("->x_n_new_adder %b", adder_z);
          adder_z_ack <= 1;
          adder_a_stb <= 0;
          adder_b_stb <= 0;
        end
      end

      divide_3:  // Xi * (2-DXi = x_n_new)
      begin
        multiplier_a <= x_n;
        multiplier_b <= x_n_new;
        multiplier_a_stb <= 1;
        multiplier_b_stb <= 1;
        multiplier_z_ack <= 0;
        if(multiplier_z_stb) 
        begin
          state <= divide_4;
          x_n_new <= multiplier_z;
          multiplier_z_ack <= 1;
          multiplier_a_stb <= 0;
          multiplier_b_stb <= 0;
          
          if(`DEBUGGING) 
            s_output_z <= x_n;  //Show results before finsihing calculation
        end
      end
      
      divide_4: // Wait for multiplier to acknowledge
      begin
        if(!multiplier_z_stb)
          if(count == `DOUBLE_DIVIDER_MAX_LOOP || x_n == x_n_new)
            begin
              state <= divide_5;
            end else begin
              state <= divide_1;
              count <= count + 1;
              x_n <= x_n_new;
          end
      end
      
      divide_5:  // (N=a) * ((1/D)=x_n_new)
      begin
        multiplier_a <= a;
        multiplier_b <= x_n_new;
        multiplier_a_stb <= 1;
        multiplier_b_stb <= 1;
        multiplier_z_ack <= 0;
        if(multiplier_z_stb) 
        begin
          state <= put_z;
          z <= {a_s ^ b_s, multiplier_z[62:0]};  // Correct the sign because we used abs(b) for 1/b
          multiplier_z_ack <= 1;
          multiplier_a_stb <= 0;
          multiplier_b_stb <= 0;
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
      s_input_b_ack <= 0;
      s_output_z_stb <= 0;
    end

  end
  assign input_a_ack = s_input_a_ack;
  assign input_b_ack = s_input_b_ack;
  assign output_z_stb = s_output_z_stb;
  assign output_z = s_output_z;

endmodule

