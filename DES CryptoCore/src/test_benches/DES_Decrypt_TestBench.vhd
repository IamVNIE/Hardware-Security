--******************************************************************************
-- Copyright (c) 2016 Vinayaka Jyothi 
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
-- Create Date:   20:45:11 02/14/2017
-- Design Name:   
-- Module Name:   DES_DECRYPT Testbench.vhd
-- Project Name:  DES_Fully_Pipelined
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- 
-- Dependencies: DES_Fully_Pipelined Design and txt_util.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
--------------------------------------------------------------------------------
LIBRARY ieee;
Use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use work.txt_util.all;
  
ENTITY DES_Decrypt_testBench IS
END DES_Decrypt_testBench;
 
ARCHITECTURE behavior OF DES_Decrypt_testBench IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DES_CRYPTO_CORE --desCryptoCore
    PORT(
         reset : IN  std_logic;
         EN : IN  std_logic;
         clk : IN  std_logic;
         DES_IN : IN  std_logic_vector(63 downto 0);
         USER_KEY : IN  std_logic_vector(63 downto 0);
         DES_OUT : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    
	 COMPONENT DES IS
        PORT(
        PT : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
        KIN: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
        CT: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
        RST: IN STD_LOGIC;
        CLK: IN STD_LOGIC;
				TEST_MODE: IN STD_LOGIC;
				SCAN_OUT : OUT STD_LOGIC);
		END COMPONENT;


   --Inputs
   signal reset : std_logic := '0';
   signal EN : std_logic := '0';
   signal clk : std_logic := '0';
   signal DES_IN : std_logic_vector(63 downto 0) := (others => '0');
   signal USER_KEY : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal DES_OUT : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	signal ERROR,ERRORD: integer :=0;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DES_CRYPTO_CORE PORT MAP (
          reset => reset,
          EN => EN,
          clk => clk,
          DES_IN => DES_IN,
          USER_KEY => USER_KEY,
          DES_OUT => DES_OUT
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

readcmd: process
	file CryptoCore_TestVectors: TEXT; 
		variable file_line: Line;
		variable test_vector_key_in: std_logic_vector (63 downto 0); 
		variable test_vector_din: std_logic_vector (63 downto 0);
		variable test_vector_expected_dout : std_logic_vector (63 downto 0);
		 
	Begin
		reset	<= '1';
		USER_KEY	<= (others => '0');
		DES_IN	<= (others => '0');
		En	<= '0';
		
		wait for 100*clk_period;
			reset <= '0';
		wait until rising_edge (clk);
		reset	<= '0';
		wait for 100*clk_period;
			reset <= '0';
		wait until rising_edge (clk);
		
		print ("DES Test#1 has begun.");
			
		FILE_OPEN (CryptoCore_TestVectors, "../src/test_vectors/DES_TV_Triplets_NBS.txt", READ_MODE); --In case of problems, use absolute path
		
		loop
			If endfile (CryptoCore_TestVectors) then
				exit;
			End If;
		
			readline (CryptoCore_TestVectors, file_line);
			hread (file_line, test_vector_key_in);
			hread (file_line, test_vector_expected_dout);
			hread (file_line, test_vector_din);
			
			USER_KEY <= test_vector_key_in;
--			din_vld_T <= '1';   --# When Designs have din and key valid use this
--			Key_vld <= '1';
			DES_IN <= test_vector_din;
			wait until rising_edge (clk);
			
--			din_vld_T <= '0';
--			wait until dout_rdy_T = '1';  --# When Designs have dout use this to get the result
			wait for 20*clk_period;
			wait until rising_edge (clk);
			If DES_OUT /= test_vector_expected_dout then
				print ("***ERROR: test vector failed to compare"); ERROR<=ERROR+1;
				print ((" Expected PT: ") & hstr (test_vector_expected_dout (63 downto 0)) & (" Received PT: ") & hstr (DES_OUT (63 downto 0)));
			End If;
		End loop;																	
		
		print ("Test#1 completed");
		
		print ("");
		print ("");
		
		if ERROR=0 then
			print ("All tests complete- PASS");
		else
			print (("All tests complete 4 Decrypt - FAIL --> Total ERRORS=") &  integer'image(ERROR));
		end if;		
		wait;
		
	end process;
	
	
END;
