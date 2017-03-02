library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Dec2LED is
    Port ( CLK: in STD_LOGIC; X : in  STD_LOGIC_VECTOR (3 downto 0);
           Y : out  STD_LOGIC_VECTOR (7 downto 0));
end Dec2LED;

architecture Behavioral of Dec2LED is
begin
process (CLK)
begin
case X is
when "0000" => Y <= "11000000";
when "0001" => Y <= "11111001";
when "0010" => Y <= "10100100";
when "0011" => Y <= "10110000";
when "0100" => Y <= "10011001";
when "0101" => Y <= "10010010";
when "0110" => Y <= "10000010";
when "0111" => Y <= "11111000";
when "1000" => Y <= "10000000";
when "1001" => Y <= "10010000";
when "1010" => Y <= "10001000"; 
when "1011" => Y <= "10000011"; 
when "1100" => Y <= "11000110"; 
when "1101" => Y <= "10100001"; 
when "1110" => Y <= "10000110"; 
when others => Y <= "10001110"; 
end case;
end process;
end Behavioral;

