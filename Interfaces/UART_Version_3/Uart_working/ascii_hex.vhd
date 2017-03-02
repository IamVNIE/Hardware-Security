----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2016 04:05:30 PM
-- Design Name: 
-- Module Name: ascii_hex - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ascii_hex is
    Port ( clk : in std_logic; ascii : in std_logic_vector(7 downto 0); hex : out std_logic_vector(3 downto 0)
          
          );
end ascii_hex;

architecture Behavioral of ascii_hex is

begin
    process(CLK)
    begin
       -- if (clk'event and clk =  '1') then
            case ascii is
                when x"30" => hex <= "0000";
                when x"31" => hex <= "0001";
                when x"32" => hex <= "0010";
                when x"33" => hex <= "0011";
                when x"34" => hex <= "0100";
                when x"35" => hex <= "0101";
                when x"36" => hex <= "0110";
                when x"37" => hex <= "0111";
                when x"38" => hex <= "1000";
                when x"39" => hex <= "1001";
                when x"61" => hex <= "1010";
                when x"62" => hex <= "1011";
                when x"63" => hex <= "1100";
                when x"64" => hex <= "1101";
                when x"65" => hex <= "1110";
                when x"66" => hex <= "1111";
                when others => hex <= "0000"; 
            end case;
        --end if;
end process;


end Behavioral;
