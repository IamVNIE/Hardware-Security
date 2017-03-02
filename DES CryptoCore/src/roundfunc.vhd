----------------------------------------------------------------------------------
-- Company: Hardware Security
-- Designer: Vinayaka Jyothi
-- 
-- Create Date:    18:42:44 11/28/2016 
-- Design Name: DES Round Function
-- Module Name:  des_roundfunc - Structural
-- Project Name: DES Crypto Core
-- Target Devices: ANY FPGAs
-- Tool versions: ISE, Vivado
-- Description: Implements round function of DES - Complete Structural Modelling
--				The final outputs are swap left and right 32 bits using registers 
--				User may want to just without using registers
-- 		
-- Dependencies: Modules :-> XP- Expansion; DESXOR1,DESXOR2 - XOR; S1..S8 - S-Boxes; 
--							 PP - Permutation; REG32 - 32 bit register
--				 Files	 :-> xp.vhd,desxor1.vhd,desxor2.vhd, s1.vhd...s8.vhd,pp.vhd
--						     reg32.vhd		
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments:    
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity roundfunc is port
(
clk : in std_logic;
reset : in std_logic;
li,ri : in std_logic_vector(1 to 32);  --- Left and right 32 bits in 
k : in std_logic_vector(1 to 48);  -- Round key 
lo,ro : out std_logic_vector(1 to 32) --Left and right 32 bits out (After swapping)
);
end roundfunc;
architecture behaviour of roundfunc is
signal xp_to_xor : std_logic_vector(1 to 48);
signal b1x,b2x,b3x,b4x,b5x,b6x,b7x,b8x: std_logic_vector(1 to 6);
signal so1x,so2x,so3x,so4x,so5x,so6x,so7x,so8x: std_logic_vector(1 to 4);
signal ppo,r_toreg32,l_toreg32 : std_logic_vector(1 to 32);

begin
xpension: entity work.xp port map ( ri=>ri,e=>xp_to_xor );
des_xor1: entity work.desxor1 port map ( e=>xp_to_xor,k=>k,b1x=>b1x, b2x=>b2x, b3x=>b3x, b4x=>b4x, b5x=>b5x, b6x=>b6x,b7x=>b7x, b8x=>b8x);
s1a: entity work.s1 port map ( clk=>clk, b=>b1x, so=>so1x);
s2a: entity work.s2 port map ( clk=>clk, b=>b2x, so=>so2x);
s3a: entity work.s3 port map ( clk=>clk, b=>b3x, so=>so3x);
s4a: entity work.s4 port map ( clk=>clk, b=>b4x, so=>so4x);
s5a: entity work.s5 port map ( clk=>clk, b=>b5x, so=>so5x);
s6a: entity work.s6 port map ( clk=>clk, b=>b6x, so=>so6x);
s7a: entity work.s7 port map ( clk=>clk, b=>b7x, so=>so7x);
s8a: entity work.s8 port map ( clk=>clk, b=>b8x, so=>so8x);
pperm: entity work.pp port map ( so1x=>so1x, so2x=>so2x, so3x=>so3x, so4x=>so4x, so5x=>so5x, so6x=>so6x, so7x=>so7x, so8x=>so8x,
											ppo=>ppo );
des_xor2: entity work.desxor2 port map ( d=>ppo,l=>li, q=>r_toreg32 );
l_toreg32<=ri;
register32_left: entity work.reg32 port map ( a=>l_toreg32, q=>lo,reset=>reset, clk=>clk );
register32_right: entity work.reg32 port map ( a=>r_toreg32, q=>ro,reset=>reset, clk=>clk );
end;

