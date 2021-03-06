module single_packer(z_s, z_m, z_e, z);
  output reg[31:0] z;
  input[23:0] z_m;
  input[9:0] z_e;
  input z_s;
  
  always @(*) begin
        //if overflow occurs, return inf
        if ($signed(z_e) > 127) begin
          z[22 : 0] = 0;
          z[30 : 23] = 255;
          z[31] = z_s;
        end
        else if ($signed(z_e) == -126 && z_m[23] == 0) begin
          z[30 : 23] = 0;
          z[22 : 0] = z_m[22:0];
          z[31] = z_s;
        end else begin
          z[22 : 0] = z_m[22:0];
          z[30 : 23] = z_e[7:0] + 127;
          z[31] = z_s;
        end
    end
      
  function [31:0] single_pack_function;
    input z_s;
    input[9:0] z_e;
    input[23:0] z_m;
    begin
      //if overflow occurs, return inf
        if ($signed(z_e) > 127) begin
         single_pack_function[22 : 0] = 0;
         single_pack_function[30 : 23] = 255;
         single_pack_function[31] = z_s;
        end
        else if ($signed(z_e) == -126 && z_m[23] == 0) begin
          single_pack_function[30 : 23] = 0;
          single_pack_function[22 : 0] = z_m[22:0];
          single_pack_function[31] = z_s;
        end else begin
          single_pack_function[22 : 0] = z_m[22:0];
          single_pack_function[30 : 23] = z_e[7:0] + 127;
          single_pack_function[31] = z_s;
        end
    end
  endfunction
endmodule