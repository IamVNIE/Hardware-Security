----------------------------------------------------------------------------------
-- Company: VNIE ENTITIES
-- Engineer: Vinayaka Jyothi
-- 
-- Create Date:    18:42:34 04/19/2017 
-- Design Name: Variable_Chain_Ring_Oscillator_Generator
-- Module Name:    RO_GENIE - Structural 
-- Project Name: FPGA Trojan Detection
-- Target Devices: Any FPGA Device
-- Tool versions: ISE, Vivado
-- Description: This file allows to describe a N-stage ring oscillator. 
-- 				 User can change the value of RO_ChainLength in Line 30.
--					 RO needs odd number of elements. RO_ChainLength should be odd.
--					 ENABLE=1 to activate RO--> you get oscillations else RO is deactivated 		
--
-- Dependencies: None
--
-- Revision: 
-- 			Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity RO_GENIE is
	generic (RO_ChainLength: integer := 5
				);
	port(	ENABLE : in  std_logic;
			RO_OSC_OUT: out  std_logic
			);
end RO_GENIE;

architecture structure of RO_GENIE is
  signal RO_PATH_INV : std_logic_vector(RO_ChainLength-1 downto 0);
-- The following attributes stop delay/inverter logic chain from being optimised
-- Keeps the nodes being absorbed/collapsed and allows creating a combinational loop  
  ATTRIBUTE KEEP: BOOLEAN;
  ATTRIBUTE SYN_KEEP: BOOLEAN;
  ATTRIBUTE KEEP of RO_PATH_INV: signal is TRUE;
  ATTRIBUTE SYN_KEEP of RO_PATH_INV: signal is TRUE;
  
begin

--This line raises an error if the user specifies a RO with even number of inverting elements. Will not generate any hardware
assert RO_ChainLength mod 2 = 1 report "The number of inverting elements should be an odd number.. Change RO_ChainLength!" severity failure;

gen_ring_osc:
		for i in 2 to RO_ChainLength generate
				RO_PATH_INV(i-1) <= not RO_PATH_INV(i-2);
		end generate;
-- NAND GATES ACTS AS INVERTER WHEN '1'; So when ENABLE=1, you get oscillations else RO chain is broken and no oscillations are produced 		
RO_PATH_INV(0) <= RO_PATH_INV(RO_ChainLength-1) nand enable;  

 RO_OSC_OUT <= RO_PATH_INV(RO_ChainLength-2);

end structure;