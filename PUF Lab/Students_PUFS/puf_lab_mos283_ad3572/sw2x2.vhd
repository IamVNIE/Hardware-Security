----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:39 04/24/2017 
-- Design Name: 
-- Module Name:    sw2x2 - Behavioral 
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

entity SW2x2 is
port (
    In0: in std_logic;
    In1: in std_logic;
    Out0: out std_logic;
    Out1: out std_logic;
    Sel: in std_logic);
end SW2x2;

architecture Behavioral of SW2x2 is

begin
    Out0 <= In0 when Sel='0' else
            In1 when Sel='1' else
            '0';
    Out1 <= In1 when Sel='0' else
            In0 when Sel='1' else
            '0';

end Behavioral;

