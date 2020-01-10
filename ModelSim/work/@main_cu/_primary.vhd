library verilog;
use verilog.vl_types.all;
entity Main_cu is
    generic(
        idle            : integer := 0;
        fetch           : integer := 1;
        wait_single_div : integer := 2;
        wait_single_sqrt: integer := 3;
        wait_double_div : integer := 4;
        wait_double_sqrt: integer := 5
    );
    port(
        \process\       : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        input_a_stb     : in     vl_logic;
        output_z_stb    : in     vl_logic;
        input_a_stb_single_divS: out    vl_logic;
        input_a_stb_single_sqrtS: out    vl_logic;
        input_a_stb_double_divS: out    vl_logic;
        input_a_stb_double_sqrtS: out    vl_logic;
        output_zS       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of idle : constant is 1;
    attribute mti_svvh_generic_type of fetch : constant is 1;
    attribute mti_svvh_generic_type of wait_single_div : constant is 1;
    attribute mti_svvh_generic_type of wait_single_sqrt : constant is 1;
    attribute mti_svvh_generic_type of wait_double_div : constant is 1;
    attribute mti_svvh_generic_type of wait_double_sqrt : constant is 1;
end Main_cu;
