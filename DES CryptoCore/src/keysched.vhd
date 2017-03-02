--******************************************************************************
-- Copyright (c) 2017 Vinayaka Jyothi 
-- All rights reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining 
-- a copy of this software and associated documentation files (the 
-- "Software"), to deal in the Software without restriction, including 
-- without limitation the rights to use, copy, modify, merge, publish, 
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject 
-- to the following conditions:
--
-- The above copyright notice and this permission notice shall be 
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

--******************************************************************************
--------------------------------------------------------------------------------
-- Company: VNIE ENTITIES
-- Designer: Vinayaka Jyothi
--
-- Create Date:   20:45:11 02/14/2010
-- Design Name:   
-- Project Name:  DES_Fully_Pipelined
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- 
-- Dependencies: DES_Fully_Pipelined 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity keysched is port
(
key : in std_logic_vector(1 to 64);EN,CLK: in std_logic;
k1x,k2x,k3x,k4x,k5x,k6x,k7x,k8x,k9x,k10x,k11x,k12x,k13x,k14x,k15x,k16x
: out std_logic_vector(1 to 48)
);
end keysched;
architecture behaviour of keysched is
signal k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16: std_logic_vector(1 to 48);
signal
c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16 :std_logic_vector(28 downto 1);
signal
d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16 :std_logic_vector(28 downto 1);
component pc1
port (
key : in std_logic_vector(1 TO 64);
c0x,d0x : out std_logic_vector(1 TO 28)
);
end component;
component pc2
port (
c,d : in std_logic_vector(1 TO 28);
k : out std_logic_vector(1 TO 48)
);
end component;

begin
pc_1: pc1 port map ( key=>key, c0x=>c0, d0x=>d0);
C1 	<=	C0(27 DOWNTO 1) & C0(28);
D1	<=	D0(27 DOWNTO 1) & D0(28);
C2	<=  C1(27 DOWNTO 1) & C1(28);
D2	<=  D1(27 DOWNTO 1) & D1(28);
C3	<=  C2(26 DOWNTO 1) & C2(28 DOWNTO 27);
D3	<=  D2(26 DOWNTO 1) & D2(28 DOWNTO 27);
C4	<=  C3(26 DOWNTO 1) & C3(28 DOWNTO 27);
D4	<=  D3(26 DOWNTO 1) & D3(28 DOWNTO 27);
C5	<=  C4(26 DOWNTO 1) & C4(28 DOWNTO 27);
D5	<=  D4(26 DOWNTO 1) & D4(28 DOWNTO 27);
C6	<=  C5(26 DOWNTO 1) & C5(28 DOWNTO 27);
D6	<=  D5(26 DOWNTO 1) & D5(28 DOWNTO 27);
C7	<=  C6(26 DOWNTO 1) & C6(28 DOWNTO 27);
D7	<=  D6(26 DOWNTO 1) & D6(28 DOWNTO 27);
C8 	<=	C7(26 DOWNTO 1) & C7(28 DOWNTO 27);
D8	<=	D7(26 DOWNTO 1) & D7(28 DOWNTO 27);
C9	<=  C8(27 DOWNTO 1) & C8(28);
D9	<=  D8(27 DOWNTO 1) & D8(28);
C10	<=  C9(26 DOWNTO 1) & C9(28 DOWNTO 27);
D10	<=  D9(26 DOWNTO 1) & D9(28 DOWNTO 27);
C11	<=  C10(26 DOWNTO 1) & C10(28 DOWNTO 27);
D11	<=  D10(26 DOWNTO 1) & D10(28 DOWNTO 27);
C12	<=  C11(26 DOWNTO 1) & C11(28 DOWNTO 27);
D12	<=  D11(26 DOWNTO 1) & D11(28 DOWNTO 27);
C13	<=  C12(26 DOWNTO 1) & C12(28 DOWNTO 27);
D13	<=  D12(26 DOWNTO 1) & D12(28 DOWNTO 27);
C14	<=  C13(26 DOWNTO 1) & C13(28 DOWNTO 27);
D14	<=  D13(26 DOWNTO 1) & D13(28 DOWNTO 27);
C15	<=  C14(26 DOWNTO 1) & C14(28 DOWNTO 27);
D15	<=  D14(26 DOWNTO 1) & D14(28 DOWNTO 27);
C16 	<=	C15(27 DOWNTO 1) & C15(28);
D16	<=	D15(27 DOWNTO 1) & D15(28);

pc2x1: pc2 port map ( c=>c1, d=>d1, k=>k1 );
pc2x2: pc2 port map ( c=>c2, d=>d2, k=>k2 );
pc2x3: pc2 port map ( c=>c3, d=>d3, k=>k3 );
pc2x4: pc2 port map ( c=>c4, d=>d4, k=>k4 );
pc2x5: pc2 port map ( c=>c5, d=>d5, k=>k5 );
pc2x6: pc2 port map ( c=>c6, d=>d6, k=>k6 );
pc2x7: pc2 port map ( c=>c7, d=>d7, k=>k7 );
pc2x8: pc2 port map ( c=>c8, d=>d8, k=>k8 );
pc2x9: pc2 port map ( c=>c9, d=>d9, k=>k9 );
pc2x10: pc2 port map ( c=>c10, d=>d10, k=>k10 );
pc2x11: pc2 port map ( c=>c11, d=>d11, k=>k11 );
pc2x12: pc2 port map ( c=>c12, d=>d12, k=>k12 );
pc2x13: pc2 port map ( c=>c13, d=>d13, k=>k13 );
pc2x14: pc2 port map ( c=>c14, d=>d14, k=>k14 );
pc2x15: pc2 port map ( c=>c15, d=>d15, k=>k15 );
pc2x16: pc2 port map ( c=>c16, d=>d16, k=>k16 );

process(EN,KEY,CLK)
begin
if EN='0' then
  k1x<=k16;k2x<=k15;k3x<=k14;k4x<=k13;k5x<=k12;k6x<=k11;k7x<=k10;k8x<=k9;
  k9x<=k8;k10x<=k7;k11x<=k6;k12x<=k5;k13x<=k4;k14x<=k3;k15x<=k2;k16x<=k1;
else
  k1x<=k1;k2x<=k2;k3x<=k3;k4x<=k4;k5x<=k5;k6x<=k6;k7x<=k7;k8x<=k8;
  k9x<=k9;k10x<=k10;k11x<=k11;k12x<=k12;k13x<=k13;k14x<=k14;k15x<=k15;k16x<=k16;
end if;
end process;  
end behaviour;