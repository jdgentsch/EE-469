library verilog;
use verilog.vl_types.all;
entity mux4_1 is
    port(
        \out\           : out    vl_logic;
        i00             : in     vl_logic;
        i01             : in     vl_logic;
        i10             : in     vl_logic;
        i11             : in     vl_logic;
        sel0            : in     vl_logic;
        sel1            : in     vl_logic
    );
end mux4_1;
