library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Circuit17 is
    Port ( TE,ROSEL: in STD_LOGIC;
			  G1 : in  STD_LOGIC;
           G2 : in  STD_LOGIC;
           G3 : in  STD_LOGIC;
           G6 : in  STD_LOGIC;
           G7 : in  STD_LOGIC;
           G22 : out  STD_LOGIC;
           G23 : out  STD_LOGIC;
			  GEX: out STD_LOGIC);
end Circuit17;

architecture Behavioral of Circuit17 is
signal delay1,delay2  : std_logic;
signal G10,G11,G16,G19,G6t: STD_LOGIC;
signal sel1,G23t: std_logic;
attribute KEEP : string;
attribute KEEP of G10 : signal is "true";
attribute KEEP of G11 : signal is "true";
attribute KEEP of G16 : signal is "true";
attribute KEEP of G19 : signal is "true";
attribute KEEP of G6t : signal is "true";
--attribute KEEP of delay1 : signal is "true";
--attribute KEEP of delay2 : signal is "true";
attribute KEEP of G23t : signal is "true";

attribute INIT : string;
attribute INIT of G10_lut            : label is "7";
attribute INIT of G11_lut            : label is "7";
attribute INIT of G16_lut            : label is "7";
attribute INIT of G19_lut            : label is "7";
attribute INIT of G22_lut            : label is "7";
attribute INIT of G23_lut            : label is "7";
--attribute INIT of tr1_lut            : label is "3";
--attribute INIT of tr2_lut            : label is "3";

attribute LOC : string;
attribute LOC of G10_lut            : label is "SLICE_X18Y14";
attribute LOC of G11_lut            : label is "SLICE_X19Y14";
attribute LOC of G16_lut            : label is "SLICE_X20Y14";
attribute LOC of G19_lut            : label is "SLICE_X21Y14";
attribute LOC of G22_lut            : label is "SLICE_X22Y14";
attribute LOC of G23_lut            : label is "SLICE_X23Y14";
--attribute LOC of tr2_lut         : label is "SLICE_X23Y14";
--attribute LOC of tr1_lut         : label is "SLICE_X22Y14";

begin

sel1<= TE;

------- MUX BEFORE G10 (INPUT TO G10gat)---
process(sel1)
Begin
Case sel1 is
when '0' => G6t<= G6;
when '1' => G6t<= G23t;
When others=> G6t <= G6;
end case;
end process; 
--------------------------
G10_lut: LUT2
    generic map (INIT => X"7") 
	 port map( I0 => G1,I1 => G3,O => G10 );
G11_lut: LUT2
    generic map (INIT => X"7")
	 port map( I0 => G3,I1 => G6t,O => G11 );
G16_lut: LUT2
    generic map (INIT => X"7") 
	 port map( I0 => G2,I1 => G11,O => G16 );
G19_lut: LUT2
    generic map (INIT => X"7") 
	 port map( I0 => G11,I1 => G7,O => G19 );
G22_lut: LUT2
    generic map (INIT => X"7") 
	 port map( I0 => G16,I1 => G10,O => G22 );
G23_lut: LUT2
    generic map (INIT => X"7") 
	 port map( I0 => G19,I1 => G16,O => G23t );

----  TROJAN (INVERTER GATE) ----
--Tr1_lut: LUT2
--    generic map (INIT => X"3") 
--	 port map( I0 => TE,I1 => G23t,O => delay1);

--Tr2_lut: LUT2
--    generic map (INIT => X"3") 
--	 port map( I0 => TE,I1 => delay1,O => delay2 );

-----------------------------------	 
G23<= G23t;
GEX<= G23t;

end Behavioral;
