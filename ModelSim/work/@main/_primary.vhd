library verilog;
use verilog.vl_types.all;
entity Main is
    port(
        input_as        : in     vl_logic_vector(31 downto 0);
        input_bs        : in     vl_logic_vector(31 downto 0);
        input_ad        : in     vl_logic_vector(63 downto 0);
        input_bd        : in     vl_logic_vector(63 downto 0);
        input_a_stb     : in     vl_logic;
        input_b_stb     : in     vl_logic;
        output_z_ack    : in     vl_logic;
        \process\       : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        output_zs       : out    vl_logic_vector(31 downto 0);
        output_zd       : out    vl_logic_vector(63 downto 0);
        output_z_stb    : out    vl_logic;
        input_a_ack     : out    vl_logic;
        input_b_ack     : out    vl_logic
    );
end Main;
