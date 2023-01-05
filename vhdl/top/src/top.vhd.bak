

library ieee;
use ieee.std_logic_1164.all;

-- import all required packages
use work.display_switch_pkg.all;
use work.dbg_port_pkg.all;


entity top is
	port (
		--50 MHz clock input
		clk      : in  std_logic;

		-- push buttons and switches (not used except for keys(0))
		keys     : in std_logic_vector(3 downto 0);
		switches : in std_logic_vector(17 downto 0);

		--Seven segment displays
		hex0 : out std_logic_vector(6 downto 0);
		hex1 : out std_logic_vector(6 downto 0);
		hex2 : out std_logic_vector(6 downto 0);
		hex3 : out std_logic_vector(6 downto 0);
		hex4 : out std_logic_vector(6 downto 0);
		hex5 : out std_logic_vector(6 downto 0);
		hex6 : out std_logic_vector(6 downto 0);
		hex7 : out std_logic_vector(6 downto 0);

		-- the LEDs (green and red)
		ledg : out std_logic_vector(8 downto 0);
		ledr : out std_logic_vector(17 downto 0);

		-- LCD interface
		nclk    : out std_logic;
		hd      : out std_logic;
		vd      : out std_logic;
		den     : out std_logic;
		r       : out std_logic_vector(7 downto 0);
		g       : out std_logic_vector(7 downto 0);
		b       : out std_logic_vector(7 downto 0);
		grest   : out std_logic;

		sclk    : out std_logic;
		sda     : inout std_logic;
		scen    : out std_logic;

		-- UART
		rx : in std_logic;
		tx : out std_logic;

		-- emulated NES controller interface
		emulated_nes_clk     : in std_logic;
		emulated_nes_latch   : in std_logic;
		emulated_nes_data    : out std_logic;
		
		-- NES controller interface
		nes_clk     : out std_logic;
		nes_latch   : out std_logic;
		nes_data    : in std_logic;

		--interface to SRAM
		sram_dq : inout std_logic_vector(15 downto 0);
		sram_addr : out std_logic_vector(19 downto 0);
		sram_ub_n : out std_logic;
		sram_lb_n : out std_logic;
		sram_we_n : out std_logic;
		sram_ce_n : out std_logic;
		sram_oe_n : out std_logic;

		-- audio interface
		wm8731_xck     : out std_logic;
		wm8731_sdat : inout std_logic;
		wm8731_sclk : inout std_logic;
		wm8731_dacdat  : out std_logic;
		wm8731_daclrck : out std_logic;
		wm8731_bclk    : out std_logic;

		--auxiliary outputs for the oscilloscope 
		osci_ch2 : out std_logic;
		osci_ch3 : out std_logic;
		osci_ch4 : out std_logic;

		-- interface to ADV7123
		vga_r : out std_logic_vector(7 downto 0);
		vga_g : out std_logic_vector(7 downto 0);
		vga_b : out std_logic_vector(7 downto 0);
		vga_clk : out std_logic;
		vga_sync_n : out std_logic;
		vga_blank_n : out std_logic
	);
end entity;



architecture arch of top is

	signal dbg_switches : std_logic_vector(17 downto 0);
	signal dbg_keys : std_logic_vector(3 downto 0);

	signal dbg_ledr : std_logic_vector(ledr'range);
	signal dbg_ledg : std_logic_vector(ledg'range);
	
	signal dbg_hex0 : std_logic_vector(6 downto 0);
	signal dbg_hex1 : std_logic_vector(6 downto 0);
	signal dbg_hex2 : std_logic_vector(6 downto 0);
	signal dbg_hex3 : std_logic_vector(6 downto 0);
	signal dbg_hex4 : std_logic_vector(6 downto 0);
	signal dbg_hex5 : std_logic_vector(6 downto 0);
	signal dbg_hex6 : std_logic_vector(6 downto 0);
	signal dbg_hex7 : std_logic_vector(6 downto 0);
	
	signal dsc : std_logic; -- display switch control signal

	signal dbg_gfx_instr_wr : std_logic;
	signal dbg_gfx_instr : std_logic_vector(7 downto 0);
	signal dbg_gfx_instr_full : std_logic;
	signal dbg_gfx_data_wr : std_logic;
	signal dbg_gfx_data : std_logic_vector(15 downto 0);
	signal dbg_gfx_data_full : std_logic;
	
	signal game_gfx_instr_wr : std_logic;
	signal game_gfx_instr : std_logic_vector(7 downto 0);
	signal game_gfx_instr_full : std_logic;
	signal game_gfx_data_wr : std_logic;
	signal game_gfx_data : std_logic_vector(15 downto 0);
	signal game_gfx_data_full : std_logic;
	signal game_gfx_frame_sync : std_logic;
	
	signal lcd_gfx_instr_wr : std_logic;
	signal lcd_gfx_instr : std_logic_vector(7 downto 0);
	signal lcd_gfx_instr_full : std_logic;
	signal lcd_gfx_data_wr : std_logic;
	signal lcd_gfx_data : std_logic_vector(15 downto 0);
	signal lcd_gfx_data_full : std_logic;
	signal lcd_gfx_frame_sync : std_logic;
	
	signal vbs_gfx_instr_wr : std_logic;
	signal vbs_gfx_instr : std_logic_vector(7 downto 0);
	signal vbs_gfx_instr_full : std_logic;
	signal vbs_gfx_data_wr : std_logic;
	signal vbs_gfx_data : std_logic_vector(15 downto 0);
	signal vbs_gfx_data_full : std_logic;
	signal vbs_gfx_frame_sync : std_logic;
	
	signal dbg_nes_buttons : nes_buttons_t;

begin
	-- these outputs are connected the channels 2, 3 and 4 on the remote hosts
	-- that feature a an oscilloscope. You can use assign signals to these 
	-- outputs, if you want to investigate them on the scope.
	osci_ch2 <= '0';
	osci_ch3 <= '0';
	osci_ch4 <= '0';

	dbg_ledr <= ledr;
	dbg_ledg <= ledg;
	
	dbg_hex0 <= hex0;
	dbg_hex1 <= hex1;
	dbg_hex2 <= hex2;
	dbg_hex3 <= hex3;
	dbg_hex4 <= hex4;
	dbg_hex5 <= hex5;
	dbg_hex6 <= hex6;
	dbg_hex7 <= hex7;
	
	dbg_port_inst : dbg_port
	port map (
		clk                 => clk,
		res_n               => keys(0),
		rx                  => rx,
		tx                  => tx,
		switches            => dbg_switches,
		keys                => dbg_keys,
		ledr                => dbg_ledr,
		ledg                => dbg_ledg,
		gfx_instr           => dbg_gfx_instr,
		gfx_instr_wr        => dbg_gfx_instr_wr,
		gfx_instr_full      => dbg_gfx_instr_full,
		gfx_data            => dbg_gfx_data,
		gfx_data_wr         => dbg_gfx_data_wr,
		gfx_data_full       => dbg_gfx_data_full,
		nes_buttons         => dbg_nes_buttons,
		nes_clk             => emulated_nes_clk,
		nes_data            => emulated_nes_data,
		nes_latch           => emulated_nes_latch,
		dsc                 => dsc,
		hex0 => dbg_hex0,
		hex1 => dbg_hex1,
		hex2 => dbg_hex2,
		hex3 => dbg_hex3,
		hex4 => dbg_hex4,
		hex5 => dbg_hex5,
		hex6 => dbg_hex6,
		hex7 => dbg_hex7
	);
	
	display_switch_inst : display_switch
	port map (
		control              => dsc,
		in_a_gfx_instr       => dbg_gfx_instr,
		in_a_gfx_instr_wr    => dbg_gfx_instr_wr,
		in_a_gfx_instr_full  => dbg_gfx_instr_full,
		in_a_gfx_data        => dbg_gfx_data,
		in_a_gfx_data_wr     => dbg_gfx_data_wr,
		in_a_gfx_data_full   => dbg_gfx_data_full,
		in_a_gfx_frame_sync  => open,
		in_b_gfx_instr       => game_gfx_instr,
		in_b_gfx_instr_wr    => game_gfx_instr_wr,
		in_b_gfx_instr_full  => game_gfx_instr_full,
		in_b_gfx_data        => game_gfx_data,
		in_b_gfx_data_wr     => game_gfx_data_wr,
		in_b_gfx_data_full   => game_gfx_data_full,
		in_b_gfx_frame_sync  => game_gfx_frame_sync,
		out_a_gfx_instr      => lcd_gfx_instr,
		out_a_gfx_instr_wr   => lcd_gfx_instr_wr,
		out_a_gfx_instr_full => lcd_gfx_instr_full,
		out_a_gfx_data       => lcd_gfx_data,
		out_a_gfx_data_wr    => lcd_gfx_data_wr,
		out_a_gfx_data_full  => lcd_gfx_data_full,
		out_a_gfx_frame_sync => lcd_gfx_frame_sync,
		out_b_gfx_instr      => vbs_gfx_instr,
		out_b_gfx_instr_wr   => vbs_gfx_instr_wr,
		out_b_gfx_instr_full => vbs_gfx_instr_full,
		out_b_gfx_data       => vbs_gfx_data,
		out_b_gfx_data_wr    => vbs_gfx_data_wr,
		out_b_gfx_data_full  => vbs_gfx_data_full,
		out_b_gfx_frame_sync => vbs_gfx_frame_sync
	);


	-- add your instances here

end architecture;
