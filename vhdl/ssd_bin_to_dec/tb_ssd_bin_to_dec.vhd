library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ssd_array_t.all;

entity ssd_bin_to_dec_tb is
end entity;

architecture bench of ssd_bin_to_dec_tb is

	component ssd_bin_to_dec is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		ssd : out ssd_array_t(0 to 7);
		bin: in std_logic_vector(8 downto 0)
	);
	end component;

	signal clk : std_logic;
	signal res_n : std_logic;
	signal hex0 : std_logic_vector(6 downto 0);
	signal hex1 : std_logic_vector(6 downto 0);
	signal hex2 : std_logic_vector(6 downto 0);
	signal hex3 : std_logic_vector(6 downto 0);
	signal hex4 : std_logic_vector(6 downto 0);
	signal hex5 : std_logic_vector(6 downto 0);
	signal hex6 : std_logic_vector(6 downto 0);
	signal hex7 : std_logic_vector(6 downto 0);
	signal bin : std_logic_vector(8 downto 0);

	constant CLK_PERIOD : time := 20 ns;
	signal stop_clock : boolean := false;

	

	
begin

	dut : ssd_bin_to_dec
	port map(
		clk => clk,
		res_n => res_n,
		ssd(0) => hex0,
		ssd(1) => hex1,
		ssd(2) => hex2,
		ssd(3) => hex3,
		ssd(4) => hex4,
		ssd(5) => hex5,
		ssd(6) => hex6,
		ssd(7) => hex7,
		bin => bin
	);

	stimulus : process
	begin
		res_n <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		res_n <= '1';
		wait until rising_edge(clk);
		bin <= "111111111";
		wait for 5 us;
		
		stop_clock <= true;
		wait;
	end process;

	generate_clk : process
	begin
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;

end architecture;

