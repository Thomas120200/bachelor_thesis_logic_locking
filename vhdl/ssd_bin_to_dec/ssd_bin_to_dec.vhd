

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ssd_array_t.all;

-- ssd_bin_to_dec takes as input 9 bits, interprets them as a unsigned binary number
-- and outputs the seven segment display encoding of the corresponding decimal number. It uses a clocked version
-- of the double dabble algorithm.

entity ssd_bin_to_dec is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		ssd : out ssd_array_t(0 to 7);
		bin : in std_logic_vector(8 downto 0)
	);
end entity;

architecture arch of ssd_bin_to_dec is

	-- converts the BCD encoding of a decimal digit to its corresponding seven segment display encoding
	function bcd_to_ssd(bcd : std_logic_vector) return std_logic_vector is
		variable ret : std_logic_vector(6 downto 0);
	begin
		case bcd is
			-- zero
			when "0000" => ret := "1000000";
			-- one
			when "0001" => ret := "1111001";
			-- two
			when "0010" => ret := "0100100";
			-- three
			when "0011" => ret := "0110000";
			-- four
			when "0100" => ret := "0011001";
			-- five
			when "0101" => ret := "0010010";
			-- six
			when "0110" => ret := "0000010";
			-- seven
			when "0111" => ret := "1111000";
			-- eight
			when "1000" => ret := "0000000";
			-- nine
			when "1001" => ret := "0010000";
			-- error
			when others => ret := "0111111";
		end case;
		return ret;	
	end function;
	
	-- states of the FSM
	type state_t is (PAUSE, SHIFT, CHECK, INC, UPDATE);
	
	-- registers
	signal state, next_state : state_t; -- state register
	signal cnt, next_cnt : integer; -- counter register, used in PAUSE and for SHIFTING
	signal scratch_reg, next_scratch_reg : unsigned(20 downto 0); -- contains binary and bcd string
	signal bcd_reg, next_bcd_reg : std_logic_vector(11 downto 0); -- contains the current bcd string
	
begin

	-- extract the SSD encoding of the calculated BCD string
	-- only three digits are non-zero, as the maximum decimal number is 2^9-1=511
	ssd(0) <= bcd_to_ssd(bcd_reg(3 downto 0));
	ssd(1) <= bcd_to_ssd(bcd_reg(7 downto 4));
	ssd(2) <= bcd_to_ssd(bcd_reg(11 downto 8));
	ssd(3) <= bcd_to_ssd("0000");
	ssd(4) <= bcd_to_ssd("0000");
	ssd(5) <= bcd_to_ssd("0000");
	ssd(6) <= bcd_to_ssd("0000");
	ssd(7) <= bcd_to_ssd("0000");

	
	-- the double dabble algorithm converts a binary number to its corresponding
	-- BCD bitstring
	double_dabble : process(state, next_state, cnt) is
	begin
		next_state <= state;
		next_scratch_reg <= scratch_reg;
		next_bcd_reg <= bcd_reg;
		next_cnt <= cnt;
		
		case state is 
		
			when PAUSE =>
				-- make pause in order to not exceed the maximum refresh frequency of the SSD
				if cnt > 500000 then
					next_scratch_reg <= (others => '0');
					next_scratch_reg(8 downto 0) <= unsigned(bin); -- load current binary number into scratch register
					next_state <= SHIFT;
					next_cnt <= 0;
				else
					next_cnt <= cnt + 1;
				end if;
				
			when SHIFT =>
				-- left shift by 1
				next_scratch_reg(20 downto 1) <= scratch_reg(19 downto 0);
				next_scratch_reg(0) <= '0';
				
				-- finish after 9 shifts
				if cnt < 8 then
					next_state <= CHECK;
				else
					next_state <= UPDATE;
					next_cnt <= 0;
				end if;
				
			when CHECK =>
				-- if any of the BCD digits is greate than 4, add 3
				if scratch_reg(20 downto 17) > 4 then
					next_scratch_reg(20 downto 17) <= scratch_reg(20 downto 17) + 3;
				end if;
				if scratch_reg(16 downto 13) > 4 then
					next_scratch_reg(16 downto 13) <= scratch_reg(16 downto 13) + 3;
				end if;
				if scratch_reg(12 downto 9) > 4 then
					next_scratch_reg(12 downto 9) <= scratch_reg(12 downto 9) + 3;
				end if;
				
				next_state <= INC;
				
			when INC =>
				-- increment counter
				next_cnt <= cnt + 1;
				next_state <= SHIFT;
				
			when UPDATE =>
				-- update bcd register with last caluclated bcd string
				next_bcd_reg <= std_logic_vector(scratch_reg(20 downto 9));
				next_state <= PAUSE;
				
		end case;
	end process;
				

	
	sync : process(clk, res_n) is
	begin
		if res_n = '0' then
			-- low active reset
			state <= PAUSE;
			cnt <= 0;
			bcd_reg <= (others => '0');
		elsif rising_edge(clk) then
			state <= next_state;
			cnt <= next_cnt;
			scratch_reg <= next_scratch_reg;
			bcd_reg <= next_bcd_reg;
		end if;
	end process;
	

end architecture;