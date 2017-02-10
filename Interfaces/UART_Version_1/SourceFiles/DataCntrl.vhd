-------------------------------------------------------------------------
-- main.vhd
-------------------------------------------------------------------------
-- Author:  Dan Pederson
--          Copyright 2004 Digilent, Inc.
-------------------------------------------------------------------------
-- Description:  	This file tests the included UART component by 
--					sending data in serial form through the UART to
--					change it to parallel form, and then sending the
--					resultant data back through the UART to determine if
--					the signal is corrupted or not.  When the serial 
--					information is converted into parallel information, 
--					the data byte is displayed on the 8 LEDs on the 
--					system board.  
--
--					NOTE:  Not all mapped signals are used in this test.
--					The signals were mapped to ease the modification of
--					test program.			
-------------------------------------------------------------------------
-- Revision History:
--  	07/30/04 (DanP) Created
--		05/26/05 (DanP) Modified for Pegasus board/Updated commenting style
--		06/07/05	(DanP) LED scancode display added
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-------------------------------------------------------------------------
--
--Title:	Main entity
--
--Inputs:	3	:	RXD
--					CLK
--					RST
--
--Outputs:	1	:	TXD
--					LEDS					
--
--Description:	This describes the main entity that tests the included
--				UART component.   The LEDS signals are used to 
--				display the data byte on the LEDs, so it is set equal to 
--				the dbOutSig. Technically, the dbOutSig is the scan code 
--				backwards, which explains why the LEDs are mapped 
--				backwards to the dbOutSig.
--
-------------------------------------------------------------------------
entity DataCntrl is
	Port ( 	TXD		: out std_logic := '1';
		 	RXD		: in std_logic 	:= '1';
		  	CLK		: in std_logic;
			LEDS	: out std_logic_vector(7 downto 0) := "11111111";
		  	RST		: in std_logic	:= '0');
end DataCntrl;

architecture Behavioral of DataCntrl is

-------------------------------------------------------------------------
-- Local Component, Type, and Signal declarations.								
-------------------------------------------------------------------------

-------------------------------------------------------------------------
--
--Title:	Component Declarations
--
--Description:	This component is the UART that is to be tested.  
--				The UART code can be found in the included 
--				RS232RefComp.vhd file.
--
-------------------------------------------------------------------------
component RS232RefComp
   Port (  	TXD 	: out	std_logic	:= '1';
		 	RXD 	: in	std_logic;					
  		 	CLK 	: in	std_logic;							
			DBIN 	: in	std_logic_vector (7 downto 0);
			DBOUT 	: out	std_logic_vector (7 downto 0);
			RDA		: inout	std_logic;							
			TBE		: inout	std_logic 	:= '1';				
			RD		: in	std_logic;							
			WR		: in	std_logic;							
			PE		: out	std_logic;							
			FE		: out	std_logic;							
			OE		: out	std_logic;											
			RST		: in	std_logic	:= '0');				
end component;	
-------------------------------------------------------------------------
--
--Title:	Type Declarations
--
--Description:	There is one state machine used in this program, called 
--				the mainState state machine.  This state machine controls 
--				the flow of data around the UART; allowing for data to be
--				changed from serial to parallel, and then back to serial.
--
-------------------------------------------------------------------------
	type mainState is (
		stReceive,
		stSend);
-------------------------------------------------------------------------
--
--Title:  Local Signal Declarations
--
--Description:	The signals used by this entity are described below:
--
--				-dbInSig 	:  	This signal is the parallel data input  
--								for the UART
--				-dbOutSig	:	This signal is the parallel data output 
--								for the UART
--      		-rdaSig		:	This signal will get the RDA signal from 
--								the UART
--			 	-tbeSig		:	This signal will get the TBE signal from 
--								the UART
-- 				-rdSig		:	This signal is the RD signal for the UART
-- 				-wrSig		:	This signal is the WR signal for the UART
-- 				-peSig		:	This signal will get the PE signal from 
--								the UART
-- 				-feSig		:	This signal will get the FE signal from 
--								the UART
-- 				-oeSig		:	This signal will get the OE signal from 
--								the UART
--
--				The following signals are used by the main state machine
--				for state control:
--				
--				-stCur, stNext	
--	
-------------------------------------------------------------------------
	signal dbInSig	:	std_logic_vector(7 downto 0);
	signal dbOutSig	:	std_logic_vector(7 downto 0);
	signal rdaSig	:	std_logic;
	signal tbeSig	:	std_logic;
	signal rdSig	:	std_logic;
	signal wrSig	:	std_logic;
	signal peSig	:	std_logic;
	signal feSig	:	std_logic;
	signal oeSig	:	std_logic;
	
	signal stCur	:	mainState := stReceive;
	signal stNext	:	mainState;

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin

------------------------------------------------------------------------
--
--Title:	LED definitions
--
--Description:	This series of definitions allows the scan code to be
--				displayed on the LEDs on the FPGA system board.  Because the
--				dbOutSig is the scan code backwards, the LEDs must be
--				defined backwards from the dbOutSig.
--
------------------------------------------------------------------------
	LEDS(7) <= dbOutSig(0);
	LEDS(6) <= dbOutSig(1);
	LEDS(5) <= dbOutSig(2);
	LEDS(4) <= dbOutSig(3);
	LEDS(3) <= dbOutSig(4);
	LEDS(2) <= dbOutSig(5);
	LEDS(1) <= dbOutSig(6);
	LEDS(0) <= dbOutSig(7);
-------------------------------------------------------------------------
--
--Title:		RS232RefComp map
--
--Description:	This maps the signals and ports in main to the 
--				RS232RefComp.  The TXD, RXD, CLK, and RST of main are
--				directly tied to the TXD, RXD, CLK, and RST of the 
--				RS232RefComp.  The remaining RS232RefComp ports are 
--				mapped to internal signals in main.
--
-------------------------------------------------------------------------
	UART: RS232RefComp port map (	TXD 	=> TXD,
									RXD 	=> RXD,
									CLK 	=> CLK,
									DBIN 	=> dbInSig,
									DBOUT	=> dbOutSig,
									RDA		=> rdaSig,
									TBE		=> tbeSig,	
									RD		=> rdSig,
									WR		=> wrSig,
									PE		=> peSig,
									FE		=> feSig,
									OE		=> oeSig,
									RST 	=> RST);
-------------------------------------------------------------------------
--
--Title: Main State Machine controller 
--
--Description:	This process takes care of the Main state machine 
--				movement.  It causes the next state to be evaluated on 
--				each rising edge of CLK.  If the RST signal is strobed, 
--				the state is changed to the default starting state, which 
--				is stReceive.
--
-------------------------------------------------------------------------
	process (CLK, RST)
		begin
			if (CLK = '1' and CLK'Event) then
				if RST = '1' then
					stCur <= stReceive;
				else
					stCur <= stNext;
				end if;
			end if;
		end process;
-------------------------------------------------------------------------
--
--Title: Main State Machine 
--
--Description:	This process defines the next state logic for the Main
--				state machine.  The main state machine controls the data
--				flow for this testing program in order to send and 
--				receive data.
--
-------------------------------------------------------------------------
	process (stCur, rdaSig, dboutsig)
		begin
			case stCur is
-------------------------------------------------------------------------
--
--Title: stReceive state 
--
--Description:	This state waits for the UART to receive data.  While in
--				this state, the rdSig and wrSig are held low to keep the
--				UART from transmitting any data.  Once the rdaSig is set
--				high, data has been received, and is safe to transmit. At
--				this time, the stSend state is loaded, and the dbOutSig 
--				is copied to the dbInSig in order to transmit the newly
--				acquired parallel information.
--
-------------------------------------------------------------------------	
				when stReceive =>
					rdSig <= '0';
					wrSig <= '0';

					if rdaSig = '1' then
						dbInSig <= dbOutSig;
						stNext <= stSend;
					else
						stNext <= stReceive;
					end if;			
-------------------------------------------------------------------------
--
--Title: stSend state 
--
--Description:	This state tells the UART to send the parallel 
--				information found in dbInSig.  It does this by strobing 
--				both the rdSig and wrSig signals high.  Once these 
--				signals have been strobed high, the stReceive state is 
--				loaded.
--
-------------------------------------------------------------------------
				when stSend =>
					rdSig <= '1'; 
					wrSig <= '1';

					stNext <= stReceive;
			end case;
		end process;
end Behavioral;