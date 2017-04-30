----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    19:52:49 04/24/2017
-- Design Name:
-- Module Name:    puf_top - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity puf_top is
port(
	sw : in  STD_LOGIC_VECTOR (9 downto 0);
--	challenge_input: in STD_LOGIC_VECTOR(19 DOWNTO 0);
		rst : in std_logic;
		SSEG_AN : out  STD_LOGIC_VECTOR (7 downto 0);
		SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0);
		clk : in std_logic;
		tick : in  STD_LOGIC;
		LED : out STD_LOGIC_VECTOR(15 DOWNTO 0);
      tock : in  STD_LOGIC
--	  unique_sig: out STD_LOGIC_VECTOR(27 DOWNTO 0)
	  );
end puf_top;

architecture Behavioral of puf_top is

component RO_GENIE is
port(	ENABLE : in  std_logic;
			RO_OSC_OUT: out  std_logic
			);
end component;

signal enable: std_logic;
signal RO_1_out: std_logic;
signal RO_2_out: std_logic;
signal RO_3_out: std_logic;
signal RO_4_out: std_logic;
signal RO_5_out: std_logic;
signal RO_6_out: std_logic;
signal RO_7_out: std_logic;
signal RO_8_out: std_logic;
signal ro_out, clkb : std_logic_vector(7 downto 0);
signal count1, count2, count3, count4, count5, count6, count7, count8 : std_logic_vector(5 downto 0);
signal challenge_input:STD_LOGIC_VECTOR(19 DOWNTO 0);
signal unique_sig:  STD_LOGIC_VECTOR(27 DOWNTO 0);

component benes8
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (19 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component Hex2LED 
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 

type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;

constant CNTR_MAX : std_logic_vector(23 downto 0) := x"030D40"; --100,000,000 = clk cycles per second
constant VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9

constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms
signal Cntr : std_logic_vector(26 downto 0) := (others => '0');
signal hexval: std_logic_vector(31 downto 0):=x"0123ABCD";
signal clk_cntr_reg : std_logic_vector (4 downto 0) := (others=>'0'); 
signal Valb : std_logic_vector(3 downto 0) := (others => '0');



begin
	RO_1: RO_GENIE port map(enable, RO_1_out);
	RO_2: RO_GENIE port map(enable, RO_2_out);
	RO_3: RO_GENIE port map(enable, RO_3_out);
	RO_4: RO_GENIE port map(enable, RO_4_out);
	RO_5: RO_GENIE port map(enable, RO_5_out);
	RO_6: RO_GENIE port map(enable, RO_6_out);
	RO_7: RO_GENIE port map(enable, RO_7_out);
	RO_8: RO_GENIE port map(enable, RO_8_out);

	ro_out <= RO_8_out & RO_7_out & RO_6_out & RO_5_out & RO_4_out & RO_3_out & RO_2_out & RO_1_out;

	beneins : benes8 port map (a => ro_out, sel => challenge_input, b => clkb);
	
	process(tick, tock, clk, sw)
	begin

	if (clk'event and clk = '1') then 
			if(rst = '1') then challenge_input <= x"00000"; enable <='0';
			else
				enable <= '1';
				if(tick = '1') then challenge_input(9 downto 0) <= sw; end if;
				if(tock = '1') then challenge_input(19 downto 10) <= sw; end if;
			end if;
	end if;
	
	end process;
	process(clkb, rst)
	begin
	if (clkb(0)'event and clkb(0) = '1') then
			if(rst = '1') then count1 <= "000000";
			else count1 <= count1 + '1';
			end if;
	end if;

	if (clkb(1)'event and clkb(1) = '1') then
			if(rst = '1') then count2 <= "000000";
			else count2 <= count2 + '1';
			end if;
	end if;

	if (clkb(2)'event and clkb(2) = '1') then
			if(rst = '1') then count3 <= "000000";
			else count3 <= count3 + '1';
			end if;
	end if;

	if (clkb(3)'event and clkb(3) = '1') then
			if(rst = '1') then count4 <= "000000";
			else count4 <= count4 + '1';
			end if;
	end if;

	if (clkb(4)'event and clkb(4) = '1') then
			if(rst = '1') then count5 <= "000000";
			else count5 <= count5 + '1';
			end if;
	end if;

	if (clkb(5)'event and clkb(5) = '1') then
			if(rst = '1') then count6 <= "000000";
			else count6 <= count6 + '1';
			end if;
	end if;

	if (clkb(6)'event and clkb(6) = '1') then
			if(rst = '1') then count7 <= "000000";
			else count7 <= count7 + '1';
			end if;
	end if;

	if (clkb(7)'event and clkb(7) = '1') then
			if(rst = '1') then count8 <= "000000";
			else count8 <= count8 + '1';
			end if;
	end if;

	end process;

process (count1, count2, count3, count4, count5, count6, count7, count8)
begin

if(count1 >= count2) then
  unique_sig(0) <= '1';
else
  unique_sig(0) <= '0';
end if;

if(count1 >= count3) then
  unique_sig(1) <= '1';
else
  unique_sig(1) <= '0';
end if;

if(count1 >= count4) then
  unique_sig(2) <= '1';
else
  unique_sig(2) <= '0';
end if;

if(count1 >= count5) then
  unique_sig(3) <= '1';
else
  unique_sig(3) <= '0';
end if;

if(count1 >= count6) then
  unique_sig(4) <= '1';
else
  unique_sig(4) <= '0';
end if;

if(count1 >= count7) then
  unique_sig(5) <= '1';
else
  unique_sig(5) <= '0';
end if;

if(count1 >= count8) then
  unique_sig(6) <= '1';
else
  unique_sig(6) <= '0';
end if;

if(count2 >= count3) then
  unique_sig(7) <= '1';
else
  unique_sig(7) <= '0';
end if;

if(count2 >= count4) then
  unique_sig(8) <= '1';
else
  unique_sig(8) <= '0';
end if;

if(count2 >= count5) then
  unique_sig(9) <= '1';
else
  unique_sig(9) <= '0';
end if;

if(count2 >= count6) then
  unique_sig(10) <= '1';
else
  unique_sig(10) <= '0';
end if;

if(count2 >= count7) then
  unique_sig(11) <= '1';
else
  unique_sig(11) <= '0';
end if;

if(count2 >= count8) then
  unique_sig(12) <= '1';
else
  unique_sig(12) <= '0';
end if;

if(count3 >= count4) then
  unique_sig(13) <= '1';
else
  unique_sig(13) <= '0';
end if;

if(count3 >= count5) then
  unique_sig(14) <= '1';
else
  unique_sig(14) <= '0';
end if;

if(count3 >= count6) then
  unique_sig(15) <= '1';
else
  unique_sig(15) <= '0';
end if;

if(count3 >= count7) then
  unique_sig(16) <= '1';
else
  unique_sig(17) <= '0';
end if;

if(count3 >= count8) then
  unique_sig(17) <= '1';
else
  unique_sig(17) <= '0';
end if;

if(count4 >= count5) then
  unique_sig(18) <= '1';
else
  unique_sig(18) <= '0';
end if;

if(count4 >= count6) then
  unique_sig(19) <= '1';
else
  unique_sig(19) <= '0';
end if;

if(count4 >= count7) then
  unique_sig(20) <= '1';
else
  unique_sig(20) <= '0';
end if;

if(count4 >= count8) then
  unique_sig(21) <= '1';
else
  unique_sig(21) <= '0';
end if;

if(count5 >= count6) then
  unique_sig(22) <= '1';
else
  unique_sig(22) <= '0';
end if;

if(count5 >= count7) then
  unique_sig(23) <= '1';
else
  unique_sig(23) <= '0';
end if;

if(count5 >= count8) then
  unique_sig(24) <= '1';
else
  unique_sig(24) <= '0';
end if;

if(count6 >= count7) then
  unique_sig(25) <= '1';
else
  unique_sig(25) <= '0';
end if;

if(count6 >= count8) then
  unique_sig(26) <= '1';
else
  unique_sig(26) <= '0';
end if;

if(count7 >= count8) then
  unique_sig(27) <= '1';
else
  unique_sig(27) <= '0';
end if;

end process;

LED <= unique_sig(15 downto 0) when (tock ='1' or tick = '1');

HexVal <= "0000" & unique_sig when (tock ='1' or tick = '1');

timer_counter_process : process (clk)
begin
	if (rising_edge(clk)) then
		if ((Cntr = CNTR_MAX) or rst = '1') then
			Cntr <= (others => '0');
		else
			Cntr <= Cntr + 1;
		end if;
	end if;
end process;


--This process increments the digit being displayed on the 
--7-segment display every second.

timer_inc_process : process (clk)
begin
	if (rising_edge(clk)) then
		if (rst = '1') then
			Valb <= (others => '0');
		elsif (Cntr = CNTR_MAX) then
			if (Valb = VAL_MAX) then
				Valb <= (others => '0');
			else
				Valb <= Valb + 1;
			end if;
		end if;
	end if;
end process;

--This select statement selects the 7-segment diplay anode. 
with Valb select
	SSEG_AN <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Valb select
	SSEG_CA <= NAME(0) when "0001",
				  NAME(1) when "0010",
				  NAME(2)when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;


CONV1: Hex2LED port map (CLK => clk, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => clk, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => clk, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => clk, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => clk, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => clk, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => clk, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => clk, X => HexVal(3 downto 0), Y => NAME(7));





end Behavioral;