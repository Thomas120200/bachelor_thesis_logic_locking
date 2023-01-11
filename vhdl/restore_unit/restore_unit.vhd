

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ssd_array_t.all;

-- The restore unit takes as input two 9-bit vectors and calculates their hamming distance.
-- If the hamming distance equals the specified one it will output 8 mask signals (which where chosen arbitrarily).
-- Otherwise all mask signals are set to (others => '0').

entity restore_unit is
	generic (
		HD : natural);
	port (
		mask : out ssd_array_t(0 to 7);
		bin : in std_logic_vector(8 downto 0);
		key : in std_logic_vector(8 downto 0)
	);
end entity;	



architecture arch of restore_unit is

	-- hamming takes as input two vectors a and b and returns the hamming distance.
	-- length of a and b must be equal
	function hamming(a: std_logic_vector; b: std_logic_vector) return natural is
		variable dist : natural := 0;
	begin
		for i in a'range loop
			if a(i) /= b(i) then 
				dist := dist + 1; 
			end if;
		end loop;
		return dist;
	end function;
	
begin

	calc_mask : process(bin, key) is
	begin
		if hamming(bin, key) = HD then
				-- output arbitrary mask signals to destroy the ssd signals
				mask(0) <= "1111011";
				mask(1) <= "0011010";
				mask(2) <= "0011011";
				mask(3) <= "0100000";
				mask(4) <= "0001000";
				mask(5) <= "1101100";
				mask(6) <= "1111001";
				mask(7) <= "0111010";
			else
				mask(0) <= "0000000";
				mask(1) <= "0000000";
				mask(2) <= "0000000";
				mask(3) <= "0000000";
				mask(4) <= "0000000";
				mask(5) <= "0000000";
				mask(6) <= "0000000";
				mask(7) <= "0000000";
		end if;
	end process;


end architecture;
