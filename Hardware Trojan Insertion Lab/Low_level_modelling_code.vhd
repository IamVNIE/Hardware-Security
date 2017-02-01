----------------------------------------------------------------------------------
-- Company: VNIE ENTITIES
-- Engineer: Vinayaka Jyothi
-- 
-- Create Date:    15:20:34 05/28/2013 
-- Design Name: Ring_Oscillator_Manual_Placement_Design
-- Module Name:    RO_Design_File - Behavioral 
-- Project Name: FPGA Trojan Detection
-- Target Devices: 90nm Devices, 65nm-Virtex 5, 28nm-Virtex 7
-- Tool versions: 
-- Description: This file describes a 5 stage ring oscillator in single slice.
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
--use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Right_RO_Design_File is
generic (SLICE_NUM1: string := "SLICE_X10Y0";
			SLICE_NUM2: string := "SLICE_X11Y0";
			OSC_SLICE_NUM: string := "SLICE_X11Y1"
			);
port(   osc_out : out std_logic;
            reset : in std_logic   );
end Right_RO_Design_File;

architecture Behavioral of Right_RO_Design_File is
--------------------------- 7 STAGE RING OSCILLATOR -----------------
---------------------- Remove 1 slice also for 4 inv------

signal ring_delay1      : std_logic;
signal ring_delay2      : std_logic;
signal ring_delay3      : std_logic;
signal ring_delay4      : std_logic;
signal ring_invert      : std_logic;
signal ring_delay5      : std_logic;
signal ring_delay6      : std_logic;
signal ring_delay7      : std_logic;
signal ring_delay1_f      : std_logic;
signal ring_delay2_f      : std_logic;
signal ring_delay3_f      : std_logic;
signal ring_delay4_f      : std_logic;
signal ring_invert_F      : std_logic;
signal ring_delay5_f      : std_logic;
signal ring_delay6_f      : std_logic;
signal ring_delay7_f      : std_logic;

--
-- Attributes to stop delay logic from being optimised.
--
attribute S : string;
attribute S of ring_invert : signal is "true";
attribute S of ring_delay1 : signal is "true";
attribute S of ring_delay2 : signal is "true";
attribute S of ring_delay3 : signal is "true";
attribute S of ring_delay4 : signal is "true";
attribute S of ring_delay5 : signal is "true";
attribute S of ring_delay6 : signal is "true";
attribute S of ring_delay7 : signal is "true";

------------------ MAPPING LUT's---------------------------------->>>
attribute LOC : string;
attribute LOC of invert_lut            : label is SLICE_NUM1;
attribute LOC of delay1_lut            : label is SLICE_NUM1;
attribute LOC of delay2_lut            : label is SLICE_NUM1;
attribute LOC of delay3_lut            : label is SLICE_NUM1;
attribute LOC of delay4_lut            : label is SLICE_NUM2;
attribute LOC of delay5_lut            : label is SLICE_NUM2;
attribute LOC of delay6_lut            : label is SLICE_NUM2;
attribute LOC of delay7_lut            : label is SLICE_NUM2;
attribute LOC of osc_out_lut            : label is OSC_SLICE_NUM;
---- 
attribute lock_pins: string;
attribute lock_pins of invert_lut: label is "all";
attribute lock_pins of delay1_lut: label is "all";
attribute lock_pins of delay2_lut: label is "all";
attribute lock_pins of delay3_lut: label is "all";
attribute lock_pins of delay4_lut: label is "all";
attribute lock_pins of delay5_lut: label is "all";
attribute lock_pins of delay6_lut: label is "all";
attribute lock_pins of delay7_lut: label is "all";
attribute lock_pins of osc_out_lut: label is "all";

attribute bel : string;
attribute bel of invert_lut: label is "D6LUT";
attribute bel of delay1_lut: label is "C6LUT";
attribute bel of delay2_lut: label is "B6LUT";
attribute bel of delay3_lut: label is "A6LUT";
attribute bel of delay4_lut: label is "D6LUT";
attribute bel of delay5_lut: label is "C6LUT";
attribute bel of delay6_lut: label is "B6LUT";
attribute bel of delay7_lut: label is "A6LUT";
attribute bel of osc_out_lut: label is "D6LUT";

attribute syn_keep : boolean;
attribute KEEP : string;

attribute syn_keep of ring_delay1 : signal is true;
attribute syn_keep of ring_delay2 : signal is true;
attribute syn_keep of ring_delay3 : signal is true;
attribute syn_keep of ring_delay4 : signal is true;
attribute syn_keep of ring_delay5 : signal is true;
attribute syn_keep of ring_delay6 : signal is true;
attribute syn_keep of ring_delay7 : signal is true;
attribute syn_keep of ring_invert : signal is true;

attribute KEEP of ring_delay1 : signal is "TRUE";
attribute KEEP of ring_delay2 : signal is "TRUE";
attribute KEEP of ring_delay3 : signal is "TRUE";
attribute KEEP of ring_delay4 : signal is "TRUE";
attribute KEEP of ring_delay5 : signal is "TRUE";
attribute KEEP of ring_delay6 : signal is "TRUE";
attribute KEEP of ring_delay7 : signal is "TRUE";
attribute KEEP of ring_invert : signal is "TRUE";



begin


  osc_out_lut : LUT6
    generic map(
      INIT => X"0000FFFF0000FFFF"
    )
    port map (
      I0 => '1',
      I1 => '1',
      I2 => '1',
      I3 => '1',
      I5 => '1',
      I4 => ring_delay4_f,
      O => osc_out
    );
	 
  invert_lut : LUT6
    generic map(
      INIT => X"BBBBBBBBBBBBBBBB"
    )
    port map (
      I0 => reset,
      I1 => ring_delay7,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_invert_f
    );
	 
  delay1_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_invert,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay1_f
    );
  delay2_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay1,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay2_f
    );
  delay3_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay2,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay3_f
    );
	 
	   delay4_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay3,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay4_f
    );
  delay5_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay4,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay5_f
    );
  delay6_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay5,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay6_f
    );
  delay7_lut : LUT6
    generic map(
      INIT => X"4444444444444444"
    )
    port map (
      I0 => '0',
      I1 => ring_delay6,
      I2 => '1',
      I3 => '1',
      I4 => '1',
      I5 => '1',
      O => ring_delay7_f
    );

	LDCE_inst : LDCE
	port map (
		Q => ring_invert, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_invert_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);


	LDCE_inst2 : LDCE
	port map (
		Q => ring_delay1, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay1_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);

	LDCE_inst3 : LDCE
	port map (
		Q => ring_delay2, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay2_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);

	LDCE_inst4 : LDCE
	port map (
		Q => ring_delay3, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay3_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);
	LDCE_inst5 : LDCE
	port map (
		Q => ring_delay4, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay4_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);

	LDCE_inst6 : LDCE
	port map (
		Q => ring_delay5, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay5_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);

	LDCE_inst7 : LDCE
	port map (
		Q => ring_delay6, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay6_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);


	LDCE_inst8 : LDCE
	port map (
		Q => ring_delay7, -- Data output
		CLR => '0', -- Asynchronous clear/reset input
		D => ring_delay7_f, -- Data input
		G => '1', -- Gate input
		GE => '1' -- Gate enable input
	);

end Behavioral;