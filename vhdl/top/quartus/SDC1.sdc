# Clock constraints
create_clock -name "clk" -period 20.000ns [get_ports {clk}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

set_false_path -from [get_clocks {clk}] -to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}];

set_false_path -from [get_clocks {clk}] -to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[1]}];