
library ieee;
use ieee.std_logic_1164.all;

package ssd_array_t is
  type ssd_array_t is array (natural range <>) of std_logic_vector(6 downto 0);
end package;

package body ssd_array_t is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use work.ssd_array_t.all;

-- This design is a demonstration of the logic locking technique SFLL-HD (stripped functionality logic locking - Hamming distance).
-- SFLL-HD strips the functionality of the original circuit by introducing errors. It uses a seperate restore unit 
-- to restore the introduced errors upon application of the correct key. 
-- The switches 17,...,9 are interpreted as key inputs, whereas the switches 8,...,0 are the user inputs. Upon application of 
-- the correct key the design will output the decimal representation of the users inputs on the seven segment displays.
-- If a incorrect key is applied the result on the SSD will be erroneous for a large number of inputs. The error rate
-- can be influenced by specifying the Hamming distance.

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
		ledr : out std_logic_vector(17 downto 0)

	);
end entity;

architecture arch of top is

	constant SYNC_STAGES : integer := 2;
	constant WIDTH : integer := 400;
	constant HEIGHT : integer := 240;
	constant RESET_VALUE : std_logic := '1';
	
	-- specify the secret key
	constant SECRET : std_logic_vector(8 downto 0) := "001111011";
	
	-- specify the Hamming distance
	constant HD : natural := 4;
	
	-- outputs of the orignal circuit
	signal hex0_unlocked : std_logic_vector(6 downto 0);
	signal hex1_unlocked : std_logic_vector(6 downto 0);
	signal hex2_unlocked : std_logic_vector(6 downto 0);
	signal hex3_unlocked : std_logic_vector(6 downto 0);
	signal hex4_unlocked : std_logic_vector(6 downto 0);
	signal hex5_unlocked : std_logic_vector(6 downto 0);
	signal hex6_unlocked : std_logic_vector(6 downto 0);
	signal hex7_unlocked : std_logic_vector(6 downto 0);

	-- mask for the original circuit to introduce erros
	signal hex0_fsc_mask : std_logic_vector(6 downto 0);
	signal hex1_fsc_mask : std_logic_vector(6 downto 0);
	signal hex2_fsc_mask : std_logic_vector(6 downto 0);
	signal hex3_fsc_mask : std_logic_vector(6 downto 0);
	signal hex4_fsc_mask : std_logic_vector(6 downto 0);
	signal hex5_fsc_mask : std_logic_vector(6 downto 0);
	signal hex6_fsc_mask : std_logic_vector(6 downto 0);
	signal hex7_fsc_mask : std_logic_vector(6 downto 0);
	
	-- outputs of the FSC (= mask applied to original outputs)
	signal hex0_fsc : std_logic_vector(6 downto 0);
	signal hex1_fsc : std_logic_vector(6 downto 0);
	signal hex2_fsc : std_logic_vector(6 downto 0);
	signal hex3_fsc : std_logic_vector(6 downto 0);
	signal hex4_fsc : std_logic_vector(6 downto 0);
	signal hex5_fsc : std_logic_vector(6 downto 0);
	signal hex6_fsc : std_logic_vector(6 downto 0);
	signal hex7_fsc : std_logic_vector(6 downto 0);
	
	-- outputs of the restore unit
	signal hex0_ru_mask : std_logic_vector(6 downto 0);
	signal hex1_ru_mask : std_logic_vector(6 downto 0);
	signal hex2_ru_mask : std_logic_vector(6 downto 0);
	signal hex3_ru_mask : std_logic_vector(6 downto 0);
	signal hex4_ru_mask : std_logic_vector(6 downto 0);
	signal hex5_ru_mask : std_logic_vector(6 downto 0);
	signal hex6_ru_mask : std_logic_vector(6 downto 0);
	signal hex7_ru_mask : std_logic_vector(6 downto 0);
	
	-- logic locked signals (= mask of restore unit applied to outputs of FSC)
	signal hex0_locked : std_logic_vector(6 downto 0);
	signal hex1_locked : std_logic_vector(6 downto 0);
	signal hex2_locked : std_logic_vector(6 downto 0);
	signal hex3_locked : std_logic_vector(6 downto 0);
	signal hex4_locked : std_logic_vector(6 downto 0);
	signal hex5_locked : std_logic_vector(6 downto 0);
	signal hex6_locked : std_logic_vector(6 downto 0);
	signal hex7_locked : std_logic_vector(6 downto 0);

		
	component pll
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			c1		: OUT STD_LOGIC 
		);
	end component;
	
	component ssd_bin_to_dec is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		ssd : out ssd_array_t(0 to 7);
		bin: in std_logic_vector(8 downto 0)
	);
	end component;

	component restore_unit is
	generic (
		HD : natural);
	port (
		mask : out ssd_array_t(0 to 7);
		bin : in std_logic_vector(8 downto 0);
		key : in std_logic_vector(8 downto 0)
	);
	end component;
	
	signal res_n : std_logic;	

begin

	
	-- ssd_bin_to_dec takes as input the switches 0,...,8, interprets it as a unsigned binary number
	-- and outputs the seven segment display encoding of the corresponding decimal number. It uses a clocked version
	-- of the double dabble algorithm.
	ssd_bin_to_dec_inst : ssd_bin_to_dec
	port map(
		clk => clk,
		res_n => res_n,
		ssd(0) => hex0_unlocked,
		ssd(1) => hex1_unlocked,
		ssd(2) => hex2_unlocked,
		ssd(3) => hex3_unlocked,
		ssd(4) => hex4_unlocked,
		ssd(5) => hex5_unlocked,
		ssd(6) => hex6_unlocked,
		ssd(7) => hex7_unlocked,
		bin => switches(8 downto 0)
	);
	
	-- this instance of the restore unit strips the functionality of the original circuit. Therefore
	-- it takes as an input the switches 0,...,8 and the hardcoded secret key. If the hamming distance
	-- equals the specified one, it will output a mask signal for each output of the original circuit.

	fsc_mask : restore_unit
	generic map(
		HD => HD
	)
	port map(
		mask(0) => hex0_fsc_mask,
		mask(1) => hex1_fsc_mask,
		mask(2) => hex2_fsc_mask,
		mask(3) => hex3_fsc_mask,
		mask(4) => hex4_fsc_mask,
		mask(5) => hex5_fsc_mask,
		mask(6) => hex6_fsc_mask,
		mask(7) => hex7_fsc_mask,
		bin => switches(8 downto 0),
		key => SECRET	
	);
	
	-- XORing the mask outputs with the original outputs delivers the outputs of the FSC.
	
	hex0_fsc <= hex0_unlocked xor hex0_fsc_mask;
	hex1_fsc <= hex1_unlocked xor hex1_fsc_mask;
	hex2_fsc <= hex2_unlocked xor hex2_fsc_mask;
	hex3_fsc <= hex3_unlocked xor hex3_fsc_mask;
	hex4_fsc <= hex4_unlocked xor hex4_fsc_mask;
	hex5_fsc <= hex5_unlocked xor hex5_fsc_mask;
	hex6_fsc <= hex6_unlocked xor hex6_fsc_mask;
	hex7_fsc <= hex7_unlocked xor hex7_fsc_mask;
	
	
	-- The restore unit (RU) takes as inputs the switches 0,...,8 and the keyinputs represented by switches 9,...,17. If the
	-- hamming distance equals the specified one the RU will output the same mask-signals that introduced the errors 
	-- in the FSC signals.
	restore_unit_inst : restore_unit
	generic map(
		HD => HD
	)
	port map(
		mask(0) => hex0_ru_mask,
		mask(1) => hex1_ru_mask,
		mask(2) => hex2_ru_mask,
		mask(3) => hex3_ru_mask,
		mask(4) => hex4_ru_mask,
		mask(5) => hex5_ru_mask,
		mask(6) => hex6_ru_mask,
		mask(7) => hex7_ru_mask,
		bin => switches(8 downto 0),
		key => switches(17 downto 9)	
	);	
	
	-- XORing the outputs of the RU with the corresponding outputs of the FSC finally locks the outputs. 
	-- Upon application of the correct key the errors introduced in the FSC and those introduced by the RU
	-- will cancel each other whereas a wrong key will lead to additional errors in the output.
	hex0_locked <= hex0_fsc xor hex0_ru_mask;
	hex1_locked <= hex1_fsc xor hex1_ru_mask;
	hex2_locked <= hex2_fsc xor hex2_ru_mask;
	hex3_locked <= hex3_fsc xor hex3_ru_mask;
	hex4_locked <= hex4_fsc xor hex4_ru_mask;
	hex5_locked <= hex5_fsc xor hex5_ru_mask;
	hex6_locked <= hex6_fsc xor hex6_ru_mask;
	hex7_locked <= hex7_fsc xor hex7_ru_mask;
	

	-- Use the locked signals as outputs to the seven segment display.
	hex0 <= hex0_locked;
	hex1 <= hex1_locked;
	hex2 <= hex2_locked;
	hex3 <= hex3_locked;
	hex4 <= hex4_locked;
	hex5 <= hex5_locked;
	hex6 <= hex6_locked;
	hex7 <= hex7_locked;
	
	--indicate key press by lighting green leds
	ledg(0) <= not keys(0);
	ledg(1) <= not keys(1);
	ledg(2) <= not keys(2);
	ledg(3) <= not keys(3);
	ledg(4) <= '0';
	ledg(5) <= '0';
	ledg(6) <= '0';
	ledg(7) <= '0';
	ledg(8) <= '0';
	
	-- indicate switches in on-position with red leds
	ledr <= switches;
	
	--put the reset on key 0
	res_n <= keys(0);
	
	pll_inst : pll
	port map(
		inclk0	=> clk
	);

end architecture;
