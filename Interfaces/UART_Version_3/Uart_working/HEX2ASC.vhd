library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HEX2ASC is
Port (VAL	:IN STD_LOGIC_VECTOR(3 downto 0);
		CLK	:IN STD_LOGIC;
      Y  	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end HEX2ASC;

architecture Behavioral of HEX2ASC is

begin

PROCESS(CLK)
BEGIN
CASE VAL IS
when "0000" => Y <= X"30";
when "0001" => Y <= X"31";
when "0010" => Y <= X"32";
when "0011" => Y <= X"33";
when "0100" => Y <= X"34";
when "0101" => Y <= X"35";
when "0110" => Y <= X"36";
when "0111" => Y <= X"37";
when "1000" => Y <= X"38";
when "1001" => Y <= X"39";
when "1010" => Y <= X"41"; 
when "1011" => Y <= X"42"; 
when "1100" => Y <= X"43"; 
when "1101" => Y <= X"44"; 
when "1110" => Y <= X"45";
when "1111" => Y <= X"46"; 
when others => Y <= X"2D"; 
end case;
end process;


end Behavioral;

