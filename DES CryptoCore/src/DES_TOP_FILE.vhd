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
----------------------------------------------------------------------------------
-- Company: VNIE ENTITIES
-- Designer: Vinayaka Jyothi
-- 
-- Create Date:    18:42:44 11/28/2016 
-- Design Name: DES Round Function
-- Module Name:  DES_TOP_FILE - Structural
-- Project Name: DES Crypto Core
-- Target Devices: ANY FPGAs
-- Tool versions: ISE, Vivado
-- Description: Implements DES - Complete Structural Modelling
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity DES_CRYPTO_CORE is port
(
	reset : in std_logic; 
	EN : in STD_LOGIC;
	clk : in std_logic; 
	DES_IN: in STD_LOGIC_VECTOR (63 downto 0);
	USER_KEY: in STD_LOGIC_VECTOR (63 downto 0);
	DES_OUT: out STD_LOGIC_VECTOR (63 downto 0)
);
end DES_CRYPTO_CORE;
architecture behavior of DES_CRYPTO_CORE is
--Cypher Text & Key Initialization 
-----------------For Encoding ------------------------------
--signal ct : std_logic_vector(1 TO 64):=x"1234567890abcdef"; 
--signal key : std_logic_vector(1 TO 64):=x"abbcccddddeeeeef"; 
---------------- For Decoding -------------------------------
signal ct : std_logic_vector(1 TO 64); 
signal key : std_logic_vector(1 TO 64); 
signal pt :  std_logic_vector(1 TO 64);

signal pt1:STD_LOGIC_VECTOR(64 downto 0);

signal k1x,k2x,k3x,k4x,k5x,k6x,k7x,k8x,k9x,k10x,k11x,k12x,k13x,k14x,k15x,k16x
: std_logic_vector(1 to 48);
signal
l0xa,l1x,l2x,l3x,l4x,l5x,l6x,l7x,l8x,l9x,l10x,l11x,l12x,l13x,l14x,l15x,l16x
: std_logic_vector(1 to 32);
signal
r0xa,r1x,r2x,r3x,r4x,r5x,r6x,r7x,r8x,r9x,r10x,r11x,r12x,r13x,r14x,r15x,r16x
: std_logic_vector(1 to 32);
component keysched
port (
key : in std_logic_vector(1 to 64);EN,CLK: in std_logic;
k1x,k2x,k3x,k4x,k5x,k6x,k7x,k8x,k9x,k10x,k11x,k12x,k13x,k14x,k15x,k16x
: out std_logic_vector(1 to 48)
);
end component;
component ip
port (
ct : in std_logic_vector(1 TO 64);
l0x : out std_logic_vector(1 TO 32);
r0x : out std_logic_vector(1 TO 32)
);
end component;
component roundfunc
port (
clk : in std_logic;
reset : in std_logic;
li,ri : in std_logic_vector(1 to 32);
k : in std_logic_vector(1 to 48);
lo,ro : out std_logic_vector(1 to 32)
);
end component;

component fp
port (
l,r : in std_logic_vector(1 to 32);
pt : out std_logic_vector(1 to 64)
);
end component;

begin
process(CLK,RESET)
begin
	if reset='1' then
			DES_OUT<=(OTHERS=>'0');
			ct<=(OTHERS=>'0');
			key<=(OTHERS=>'0');
		elsif rising_edge(CLK) then
			DES_OUT<=pt;
			ct<=DES_IN;
			key<=USER_KEY;
	end if;
end process;					

keyscheduling: keysched port map ( key=>key,EN=>EN, CLK=>CLK, 
										k1x=>k1x, k2x=>k2x, k3x=>k3x, k4x=>k4x, 
										k5x=>k5x, k6x=>k6x, k7x=>k7x, k8x=>k8x,
										k9x=>k9x, k10x=>k10x, k11x=>k11x, k12x=>k12x, 
										k13x=>k13x,k14x=>k14x, k15x=>k15x, k16x=>k16x );
iperm: ip port map ( ct=>ct, l0x=>l0xa, r0x=>r0xa );
round1: roundfunc port map ( clk=>clk, reset=>reset, li=>l0xa, ri=>r0xa, k=>k1x, lo=>l1x, ro=>r1x );
round2: roundfunc port map ( clk=>clk, reset=>reset, li=>l1x, ri=>r1x, k=>k2x, lo=>l2x, ro=>r2x );
round3: roundfunc port map ( clk=>clk, reset=>reset, li=>l2x, ri=>r2x, k=>k3x, lo=>l3x, ro=>r3x );
round4: roundfunc port map ( clk=>clk, reset=>reset, li=>l3x, ri=>r3x, k=>k4x, lo=>l4x, ro=>r4x );
round5: roundfunc port map ( clk=>clk, reset=>reset, li=>l4x, ri=>r4x, k=>k5x, lo=>l5x, ro=>r5x );
round6: roundfunc port map ( clk=>clk, reset=>reset, li=>l5x, ri=>r5x, k=>k6x, lo=>l6x, ro=>r6x );
round7: roundfunc port map ( clk=>clk, reset=>reset, li=>l6x, ri=>r6x, k=>k7x, lo=>l7x, ro=>r7x );
round8: roundfunc port map ( clk=>clk, reset=>reset, li=>l7x, ri=>r7x, k=>k8x, lo=>l8x, ro=>r8x );
round9: roundfunc port map ( clk=>clk, reset=>reset, li=>l8x, ri=>r8x, k=>k9x, lo=>l9x, ro=>r9x );
round10: roundfunc port map ( clk=>clk, reset=>reset, li=>l9x, ri=>r9x, k=>k10x, lo=>l10x, ro=>r10x );
round11: roundfunc port map ( clk=>clk, reset=>reset, li=>l10x, ri=>r10x, k=>k11x, lo=>l11x, ro=>r11x );
round12: roundfunc port map ( clk=>clk, reset=>reset, li=>l11x, ri=>r11x, k=>k12x, lo=>l12x, ro=>r12x );
round13: roundfunc port map ( clk=>clk, reset=>reset, li=>l12x, ri=>r12x, k=>k13x, lo=>l13x, ro=>r13x );
round14: roundfunc port map ( clk=>clk, reset=>reset, li=>l13x, ri=>r13x, k=>k14x, lo=>l14x, ro=>r14x );
round15: roundfunc port map ( clk=>clk, reset=>reset, li=>l14x, ri=>r14x, k=>k15x, lo=>l15x, ro=>r15x );
round16: roundfunc port map ( clk=>clk, reset=>reset, li=>l15x, ri=>r15x, k=>k16x, lo=>l16x, ro=>r16x );
fperm: fp port map ( l=>r16x, r=>l16x, pt=>pt );

end behavior;

