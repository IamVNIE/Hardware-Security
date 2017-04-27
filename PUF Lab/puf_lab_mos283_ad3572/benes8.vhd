----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:34:19 04/24/2017 
-- Design Name: 
-- Module Name:    benes8 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity benes8 is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (19 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end benes8;

architecture Behavioral of benes8 is

signal a2, a1, ab, b1, b2 : STD_LOGIC_VECTOR (7 downto 0);

component sw2x2 
port (
    in0: in std_logic;
    in1: in std_logic;
    out0: out std_logic;
    out1: out std_logic;
    sel: in std_logic);
end component;

begin

st2a1 : sw2x2 port map(in0 => a(7), in1 => a(3), out0 => a2(7), out1 => a2(3), sel => sel(19) );
st2a2 : sw2x2 port map(in0 => a(6), in1 => a(2), out0 => a2(6), out1 => a2(2), sel => sel(18) );
st2a3 : sw2x2 port map(in0 => a(5), in1 => a(1), out0 => a2(5), out1 => a2(1), sel => sel(17) );
st2a4 : sw2x2 port map(in0 => a(4), in1 => a(0), out0 => a2(4), out1 => a2(0), sel => sel(16) );

st1a1 : sw2x2 port map(in0 => a2(7), in1 => a2(5), out0 => a1(7), out1 => a1(5), sel => sel(15) );
st1a2 : sw2x2 port map(in0 => a2(6), in1 => a2(4), out0 => a1(6), out1 => a1(4), sel => sel(14) );
st1a3 : sw2x2 port map(in0 => a2(3), in1 => a2(1), out0 => a1(3), out1 => a1(1), sel => sel(13) );
st1a4 : sw2x2 port map(in0 => a2(2), in1 => a2(0), out0 => a1(2), out1 => a1(0), sel => sel(12) );

st01 : sw2x2 port map(in0 => a1(7), in1 => a1(6), out0 => ab(7), out1 => ab(6), sel => sel(11) );
st02 : sw2x2 port map(in0 => a1(5), in1 => a1(4), out0 => ab(5), out1 => ab(4), sel => sel(10) );
st03 : sw2x2 port map(in0 => a1(3), in1 => a1(2), out0 => ab(3), out1 => ab(2), sel => sel(9) );
st04 : sw2x2 port map(in0 => a1(1), in1 => a1(0), out0 => ab(1), out1 => ab(0), sel => sel(8) );

st2b1 : sw2x2 port map(in0 => ab(7), in1 => ab(5), out0 => b1(7), out1 => b1(5), sel => sel(7) );
st2b2 : sw2x2 port map(in0 => ab(6), in1 => ab(4), out0 => b1(6), out1 => b1(4), sel => sel(6) );
st2b3 : sw2x2 port map(in0 => ab(3), in1 => ab(1), out0 => b1(3), out1 => b1(1), sel => sel(5) );
st2b4 : sw2x2 port map(in0 => ab(2), in1 => ab(0), out0 => b1(2), out1 => b1(0), sel => sel(4) );

st1b1 : sw2x2 port map(in0 => b1(7), in1 => b1(3), out0 => b(7), out1 => b(3), sel => sel(3) );
st1b2 : sw2x2 port map(in0 => b1(6), in1 => b1(2), out0 => b(6), out1 => b(2), sel => sel(2) );
st1b3 : sw2x2 port map(in0 => b1(5), in1 => b1(1), out0 => b(5), out1 => b(1), sel => sel(1) );
st1b4 : sw2x2 port map(in0 => b1(4), in1 => b1(0), out0 => b(4), out1 => b(0), sel => sel(0) );

end Behavioral;

