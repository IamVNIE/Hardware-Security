------------------------------------------
--------------PACKET----------------------
----MSB--- EN G1 G2 G3 G6 G7 ---LSB-------
------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DISPLAY_UNIT is 
generic (N: integer := 20; M: integer:= 5);--- N = No of Bits in Test vector + 1 (For Enable)
                                          --- M = No of Bits Reuired to count the N
port(
TXD : out std_logic := '1';RXD: in std_logic := '1';
st_indicator: OUT std_logic_vector(2 downto 0);
--DU : in STD_LOGIC;  EN : in STD_LOGIC;
ROC : in STD_LOGIC;REF : in STD_LOGIC;
--G1,G2,G3,G6: in STD_LOGIC; 
LEDS: out std_logic_vector(7 downto 0) := "11111111";
clk : in std_logic; OUTDIGIT: out STD_LOGIC_VECTOR (7 downto 0);
seg_out: out std_logic_vector(6 downto 0);
dis: out std_logic_vector(7 downto 0);
ANODE : out STD_LOGIC_VECTOR (3 downto 0);RST: in std_logic	:= '0'
);
end DISPLAY_UNIT;
architecture behavior of DISPLAY_UNIT is

component Dec2LED 
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 
signal DIGIT : STD_LOGIC_VECTOR(7 downto 0) :="00000000";
type arr is array(0 to 15) of std_logic_vector(7 downto 0);
signal NAME: arr;
type ARR2 is array(0 to 3) of std_logic_vector(7 downto 0);
signal TMPDGT: ARR2;
signal TEMP: STD_LOGIC_VECTOR(3 downto 0) :="0111";
signal CLKM : STD_LOGIC :='0';
signal Z : integer :=0;
signal G : integer :=30;
signal NAMEA : integer :=3;
signal NAMEB : integer :=2;
signal NAMEC : integer :=1;
signal NAMED : integer :=0;
signal pt1:STD_LOGIC_VECTOR(32 downto 0);

COMPONENT Circuit17
	PORT(
		TE,ROSEL : IN std_logic;
		G1 : IN std_logic;
		G2 : IN std_logic;
		G3 : IN std_logic;
		G6 : IN std_logic;
		G7 : IN std_logic;          
		G22 : OUT std_logic;
		G23 : OUT std_logic;
		GEX: OUT std_logic
		);
END COMPONENT;

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

COMPONENT HEX2ASC
	PORT(
		VAL : IN std_logic_vector(3 downto 0);
		CLK : IN std_logic;          
		Y : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
component ascii_hex
	Port ( clk : in std_logic; ascii : in std_logic_vector(7 downto 0);hex : inout std_logic_vector(3 downto 0) 
           
           );
end component;

	type StateType is (Idle, cnt, receive,Decide, send1, send2,
	                   stInput,stOutput,Test_vector,DisplayI );

	signal dbInSig	:	std_logic_vector(7 downto 0);
	signal dbOutSig, dbOutSig2, dbOutSig3:  std_logic_vector(7 downto 0);
	signal hex0, hex1, hex2, hex3, hex4, hex5 : std_logic_vector(3 downto 0);
	signal rdaSig	:	std_logic;
	signal tbeSig	:	std_logic;
	signal rdSig	:	std_logic;
	signal wrSig	:	std_logic;
	signal peSig	:	std_logic;
	signal feSig	:	std_logic;
	signal oeSig	:	std_logic;
	signal state	:	StateType;
   signal RST_TEMP:	Std_logic;
   signal reg_in  :  std_logic_vector(7 downto 0);
	signal count   :  std_logic_vector(3 downto 0);
	signal ro		:  std_logic_vector(63 downto 0);
   signal St_indic:  std_logic_vector(2 downto 0);
	signal Rflag   :  std_logic_vector(M-1 downto 0);
	Signal Shift_Length:  std_logic_vector(M-1 downto 0);
	signal tv   	:  std_logic_vector(N-1 downto 0);
	signal i_cntx: std_logic_vector(2 downto 0);
	signal big_counter: std_logic_vector(31 downto 0);
	signal temps: std_logic_vector (3 downto 0);
   
signal osc,out1,GEX : std_logic;
signal G1,G2,G3,G6,G7,EN,D: std_logic;
--signal G1,G2,G3,G6,G7,DU,EN,D: std_logic;
signal ROSEL,DU: std_logic:='1';
signal countR,count_RO,count_RO_t,count1: std_logic_vector(31 downto 0);
signal packet: std_logic_vector(N-1 downto 0);

begin
st_indicator<=St_indic;
PROCESS(clk)  BEGIN
IF(clk'EVENT AND clk='1') THEN
	    big_counter<=big_counter+'1';    

END IF;
END PROCESS;  
i_cntx <= big_counter(13 downto 11); 

with temps select
seg_out <= "0000001" when "0000",
			  "1001111" when "0001",
			  "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110001" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111",
			  "1111110" when others;
			  

with i_cntx select
 dis<= "11111110" when "000",
		"11111101" when "001",
		"11111011" when "010",
		"11110111" when "011",
		"11101111" when "100",
		"11011111" when "101",
		"10111111" when "110",
		"01111111" when "111",
		"11111111" when others;
		

with i_cntx select
temps <= dbOutSig(3 downto 0) when "000",
dbOutSig(7 downto 4) when "001",
dbOutSig2(3 downto 0) when "010",
dbOutSig2(7 downto 4) when "011",
dbOutSig3(3 downto 0) when "100",
dbOutSig3(7 downto 4) when "101",
--dbOutSig2(11 downto 8) when "110",
x"0" when others;	




Shift_Length<= std_logic_vector( to_unsigned( N,M ));
--	LEDS(7) <= Count_RO_t(0);
--	LEDS(6) <= Count_RO_t(1);
--	LEDS(5) <= Count_RO_t(2);
--	LEDS(4) <= Count_RO_t(3);
--	LEDS(3) <= Count_RO_t(4);
--	LEDS(2) <= Count_RO_t(5);
--	LEDS(1) <= Count_RO_t(6);
--	LEDS(0) <= OSC;
	G7<=Packet(N-6);
	G6<=Packet(N-5);
	G3<=Packet(N-4);
	G2<=Packet(N-3);
	G1<=Packet(N-2);
	EN<=Packet(N-1);

   LEDS(7) <= G7;
	LEDS(6) <= G6;
	LEDS(5) <= G3;
	LEDS(4) <= G2;
	LEDS(3) <= G1;
	LEDS(2) <= Du;
	LEDS(1) <= En;
	LEDS(0) <= OSC;
   
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


--------------RO1------------------
RO2: Circuit17 PORT MAP(EN,ROSEL,G1,G2,G3,G6,G7,GEX,out1,osc);
-------------REFERENCE COUNT-------
process(clk,en)
Begin
if en ='0' then 
countR <= (others=>'0');
elsif clk='1' and clk'event then
if countR<x"40000000" then
countR <= countR +'1';
end if;
end if;
end process;
-------------RO COUNT-------------
process(osc,en,countR,clk)
Begin
if en ='0' then 
count_RO_t <= (others=>'0');
elsif osc='1' and osc'event then
if countR<x"40000000" then
count_RO_t <= count_RO_t +'1';
elsif countR=x"40000000" then
count_RO<= count_RO_t;
count1<= countR;
end if;
end if;
end process;
----------------------------------
-----------------------------CONVERSION TO ASCII----------------------------
--D1: HEX2ASC PORT MAP(count_RO(31 DOWNTO 28),CLK,RO(63 downto 56));
--D2: HEX2ASC PORT MAP(count_RO(27 DOWNTO 24),CLK,RO(55 downto 48));
--D3: HEX2ASC PORT MAP(count_RO(23 DOWNTO 20),CLK,RO(47 downto 40));
--D4: HEX2ASC PORT MAP(count_RO(19 DOWNTO 16),CLK,RO(39 downto 32));
--D5: HEX2ASC PORT MAP(count_RO(15 DOWNTO 12),CLK,RO(31 downto 24));
--D6: HEX2ASC PORT MAP(count_RO(11 DOWNTO 8),CLK,RO(23 downto 16));
--D7: HEX2ASC PORT MAP(count_RO(7 DOWNTO 4),CLK,RO(15 downto 8));
--D8: HEX2ASC PORT MAP(count_RO(3 DOWNTO 0),CLK,RO(7 downto 0));
----------------------------------------------------------------------------
H1: ascii_hex port map(clk=>clk, ascii=>dbOutSig, hex=>hex0);

--H1: ascii_hex PORT MAP(CLK,RO(63 downto 56),count_RO(31 DOWNTO 28));
--H2: ascii_hex PORT MAP(CLK,RO(55 downto 48),count_RO(27 DOWNTO 24));
--H3: ascii_hex PORT MAP(CLK,RO(47 downto 40),count_RO(23 DOWNTO 20));
--H4: ascii_hex PORT MAP(CLK,RO(39 downto 32),count_RO(19 DOWNTO 16));
--H5: ascii_hex PORT MAP(CLK,RO(31 downto 24),count_RO(15 DOWNTO 12));
--H6: ascii_hex PORT MAP(CLK,RO(23 downto 16),count_RO(11 DOWNTO 8));
--H7: ascii_hex PORT MAP(CLK,RO(15 downto 8),count_RO(7 DOWNTO 4));
--H8: ascii_hex PORT MAP(CLK,RO(7 downto 0),count_RO(3 DOWNTO 0));


process(clk, rst)
    begin

	if(rst = '1')then
	   state <= idle;
	   rdSig <= '0';
	   wrSig <= '0';
	   RST_TEMP <='1';
           reg_in <= (others =>'0');
           dbInSig <= (others =>'0');
           count  <= "1111";
           Rflag<=(Others=>'0');
			  tv<=(Others=>'0');

	elsif(clk'event and clk = '1')then
	   
	   case state is
		
		  when idle     => rdSig <= '0';
	                     wrSig <= '0';
					       	     RST_TEMP <='0';
                        Rflag<=(Others=>'0');
								count<= "0000";
								St_indic<= "111";
				               if(rdaSig = '1')then
				                 state <= receive;
				               end if;

		when receive  => reg_in <= dbOutSig;
							         state <= decide;
		
          when decide => St_indic<="100";
				if (dbOutSig = x"49") then 
       		state <= StInput;
				elsif	(dbOutSig<=x"69") then
				state <= StInput;
				elsif (dbOutSig = x"4F") then 
 				state <= StOutput;
				elsif (dbOutSig<=x"6F") then
				state <= StOutput;
				
				else
				state<= Idle;
          	End if;
					

		  when StInput =>
		   St_indic<="000"; 
		    rdsig <= '0';
			 wrsig <= '0';
			 if (rdaSig = '1') then
			 state<= test_vector;
			 end if;
			
        when test_vector =>
--            if (dboutsig > x"2F" and dboutsig < x"3A") then
--                tv<=tv(N-5 downto 0) & hex0;
--                Rflag<= Rflag +'1';
--                state<= displayI;
--            elsif (dboutsig > x"60" and dboutsig < x"67") then
--                tv<=tv(N-5 downto 0) & hex0;
--                Rflag<= Rflag +'1';
--                state<= displayI;
				if dboutsig = x"30" then
             tv<=tv(N-2 downto 0) & '0';
             Rflag<= Rflag +'1';
             state<= displayI;
  				elsif dboutsig = x"31" then
             tv<=tv(N-2 downto 0) & '1';
             Rflag<= Rflag +'1';
             state<= displayI;
            elsif (dboutsig = x"72") then
                tv<=(Others=>'0');
                state<= Idle ;
            elsif (dboutsig = x"52") then
                tv<=(Others=>'0');
                state<= Idle;
            elsif (dbOutSig = x"4F") then 
                state <= StOutput;
            elsif (dbOutSig<=x"6F") then
                state <= StOutput;
            else 
                tv<= tv;
                state<= idle;
            end if;
          state<= displayI;
			 St_indic<="110";
       
		 When displayI =>
		 St_indic<="001"; 
          wrsig<='1'; rdsig<='1';
          dbInsig<=dbOutsig;
          If Rflag =Shift_length then
          	state<= Idle;
          else
            state <= StInput;
          end if;  				

				 
		  when stoutput   => 
		  
		  if count = "0001" then
		  dbInSig <=x"20";
		  ELSif count = "1010" then
		  dbInSig <=x"0A";
		  elsif count = "0010" then
		  dbInSig <=ro (63 downto 56);
		  elsif count = "0011" then
		  dbInSig <=ro (55 downto 48);
			elsif count = "0100" then
		  dbInSig <=ro (47 downto 40);
			elsif count = "0101" then
		  dbInSig <=ro (39 downto 32);
			elsif count = "0110" then
		  dbInSig <=ro (31 downto 24);
			elsif count = "0111" then
		  dbInSig <=ro (23 downto 16);
			elsif count = "1000" then
		  dbInSig <=ro (15 downto 8);
			elsif count = "1001" then
		  dbInSig <=ro (7 downto 0);
		  end if;

							         rdsig<='0'; wrsig<='0';
              							  
											  if TBEsig='1' then
											   state <= send1;
												end if;

      when send1    => rdSig <= '1'; 
							         wrSig <= '1';
                       state  <= cnt;
      
		when cnt   => count <= count +'1';		
                    state<= send2;  
						  
      when send2    => if (count > "1010") then
							           state  <= idle;
                             		rdsig<= '0';
                                 wrsig<='0'; 											
							         else
							       --    count  <= "0000";
							           state  <= stOutput;
				               end if;
	    end case;
         end if;
end process;
Packet <=TV(N-1 Downto 0);
HCONV1: HEX2ASC port map (CLK => CLK, VAL =>packet(3 downto 0), Y =>ro(7 downto 0));
HCONV2: HEX2ASC port map (CLK => CLK, VAL =>packet(7 downto 4), Y =>ro(15 downto 8));
HCONV3: HEX2ASC port map (CLK => CLK, VAL =>packet(11 downto 8), Y =>ro(23 downto 16));
HCONV4: HEX2ASC port map (CLK => CLK, VAL =>packet(15 downto 12), Y =>ro(31 downto 24));

--Packet <= '0' & hex0 & hex1 ;



-----INTERFACING TO FPGA-------
----- 7 SEGMENT CLOCK----------
process (CLK)
begin
if CLK'event and CLK='1' then
if Z=200000 then
CLKM <= '1';
elsif Z=400000 then
CLKM <= '0';
Z <= 0;
end if;
if Z /=400000  then
Z <= Z+1;
end if;
end if;
end process;
NAME(14)<= "11111111";
NAME(13)<= "11111111";
NAME(12)<= "11111111";
NAME(15)<= "11111111";

process(ROC,REF,EN,DU,countR,count_RO)
begin
 if REF='1' and DU='1' then
	pt1(32 downto 1)<= countr;
		NAME(0)<= "10101111";
		NAME(1)<= "10000110";
		NAME(2)<= "10001110";
		NAME(3)<= "10111111";
 elsif ROC='1' then
	  pt1(32 downto 1)<= count_RO;
	  NAME(0)<= "10101111";
	  NAME(1)<= "11000000";
	  NAME(2)<= "11000110";
	  NAME(3)<= "10111111";
 else 
     pt1(32 downto 1)<= "00000000000000000000000000000" & GEX & out1 & osc; 
	  NAME(0)<= "10111111";
	  NAME(1)<= "10111111";
	  NAME(2)<= "10111111";
	  NAME(3)<= "10111111";
 end if;
 end process;
CONV1: Dec2LED port map (CLK => CLK, X => pt1(32 downto 29), Y => NAME(4));
CONV2: Dec2LED port map (CLK => CLK, X => pt1(28 downto 25), Y => NAME(5));
CONV3: Dec2LED port map (CLK => CLK, X => pt1(24 downto 21), Y => NAME(6));
CONV4: Dec2LED port map (CLK => CLK, X => pt1(20 downto 17), Y => NAME(7));
CONV5: Dec2LED port map (CLK => CLK, X => pt1(16 downto 13), Y => NAME(8));
CONV6: Dec2LED port map (CLK => CLK, X => pt1(12 downto 9), Y => NAME(9));
CONV7: Dec2LED port map (CLK => CLK, X => pt1(8 downto 5), Y => NAME(10));
CONV8: Dec2LED port map (CLK => CLK, X => pt1(4 downto 1), Y => NAME(11));

process (CLKM) 
begin
if CLKM'event and CLKM='1' then
 if DU='1' then
  if G=60 then
   TMPDGT(0) <= NAME(NAMEA);
    if NAMEA=15 then
     NAMEA <= 0;
    else
     NAMEA <= NAMEA + 1;
    end if;
   TMPDGT(1) <= NAME(NAMEB);
    if NAMEB=15 then
     NAMEB <= 0;
    else
     NAMEB <= NAMEB + 1;
    end if;
   TMPDGT(2) <= NAME(NAMEC);
    if NAMEC=15 then
     NAMEC <= 0;
    else
     NAMEC <= NAMEC + 1;
    end if;
  TMPDGT(3) <= NAME(NAMED);
    if NAMED=15 then
      NAMED <= 0;
    else
      NAMED <= NAMED + 1;
    end if;
   G <= 0;
  else
   G <= G + 1;
 end if;
end if;
end if;
end process;

process (CLKM)
begin
if CLKM'event and CLKM='1' then  
if DU='1' then  
if TEMP="0111" then
TEMP <= "1110";
DIGIT <= TMPDGT(0);
elsif TEMP="1110" then
TEMP <= "1101";
DIGIT <= TMPDGT(1);
elsif TEMP="1101" then
TEMP <= "1011";
DIGIT <= TMPDGT(2);
else 
TEMP <= "0111";
DIGIT <= TMPDGT(3);
end if;
end if;
end if;
end process;
ANODE <= TEMP;
OUTDIGIT <= DIGIT;


end behavior;