library verilog;
use verilog.vl_types.all;
entity single_packer is
    port(
        z_s             : in     vl_logic;
        z_m             : in     vl_logic_vector(23 downto 0);
        z_e             : in     vl_logic_vector(9 downto 0);
        z               : out    vl_logic_vector(31 downto 0)
    );
end single_packer;
