# RO_PUF
Sw(0) is used as enable pin
sw(4 downto 1) is used as input (sel) line 
How to operate :
1. keep all the sw low when loading
2. select the RO to be used for comparing sw(4 downto 3) is used for top RO and sw(2 downto 1) as bottom RO.
3. make the enable 1, when the led(0) is one the 32 bit output is displayed on the seven segment display.

our Response Secret key : when sel = "0100" key is x"1C943DAD"