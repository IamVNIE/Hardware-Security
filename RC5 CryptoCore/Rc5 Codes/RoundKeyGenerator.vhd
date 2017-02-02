Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_unsigned.all;
Use Work.RC5_Pkg.all;

Entity rc5_rnd_key Is
	Port
	(
		clr		:	in std_logic;
		clk		:	in std_logic;
		key_vld	:	in std_logic;
		key_in	:	in Std_logic_vector (127 downto 0);
		skey	:	out rom;
		key_rdy	:	out std_logic
	);
End rc5_rnd_key;

Architecture rtl of rc5_rnd_key Is
	signal a 		:	Std_logic_vector (31 downto 0);
	signal a_circ	:	Std_logic_vector (31 downto 0);
	signal a_reg	:	Std_logic_vector (31 downto 0);
	
	signal b		:	Std_logic_vector (31 downto 0);
	signal b_reg	: 	Std_logic_vector (31 downto 0);
	signal temp		:	Std_logic_vector (31 downto 0);
	signal b_circ	:	Std_logic_vector (31 downto 0);
	
	signal s		:	rom;
	signal L		:	L_rom;
	
	signal i_cnt	:	Std_logic_vector (26 downto 0);
	signal j_cnt	:	Std_logic_vector (3 downto 0);
	signal r_cnt	:	Std_logic_vector (77 downto 0);
	
Type StateType is (														--Type for state machine
	ST_idle,
	ST_key_in,
	ST_key_exp,
	ST_ready
	);
Signal state	:	StateType;											--Signal type of state machine

Begin
	a <= s(conv_integer(i_cnt)) + a_reg + b_reg;
	a_circ <= a (28 downto 0) & a (31 downto 29);
	
	b <= L(conv_integer(j_cnt)) + a_circ + b_reg;
	temp <= a_circ + b_reg;
	with temp (4 downto 0) select
		b_circ <= b(30 downto 0) & b(31) when "00001",
			b(29 downto 0) & b(31 downto 30) when "00010",
			b(28 downto 0) & b(31 downto 29) when "00011",
			b(27 downto 0) & b(31 downto 28) when "00100",
			b(26 downto 0) & b(31 downto 27) when "00101",
			b(25 downto 0) & b(31 downto 26) when "00110",
			b(24 downto 0) & b(31 downto 25) when "00111",
			b(23 downto 0) & b(31 downto 24) when "01000",
			b(22 downto 0) & b(31 downto 23) when "01001",
			b(21 downto 0) & b(31 downto 22) when "01010",
			b(20 downto 0) & b(31 downto 21) when "01011",
			b(19 downto 0) & b(31 downto 20) when "01100",
			b(18 downto 0) & b(31 downto 19) when "01101",
			b(17 downto 0) & b(31 downto 18) when "01110",
			b(16 downto 0) & b(31 downto 17) when "01111",
			b(15 downto 0) & b(31 downto 16) when "10000",
			b(14 downto 0) & b(31 downto 15) when "10001",
			b(13 downto 0) & b(31 downto 14) when "10010",
			b(12 downto 0) & b(31 downto 13) when "10011",
			b(11 downto 0) & b(31 downto 12) when "10100",
			b(10 downto 0) & b(31 downto 11) when "10101",
			b(9 downto 0) & b(31 downto 10) when "10110",
			b(8 downto 0) & b(31 downto 9) when "10111",
			b(7 downto 0) & b(31 downto 8) when "11000",
			b(6 downto 0) & b(31 downto 7) when "11001",
			b(5 downto 0) & b(31 downto 6) when "11010",
			b(4 downto 0) & b(31 downto 5) when "11011",
			b(3 downto 0) & b(31 downto 4) when "11100",
			b(2 downto 0) & b(31 downto 3) when "11101",
			b(1 downto 0) & b(31 downto 2) when "11110",
			b(0) & b(31 downto 1) when "11111",
			b when others;
	
	Process	(clr, clk) Begin
		If (clr = '0') then
			state <= ST_idle;
		Elsif (clk'event and clk = '1') then
			Case state is
				When ST_idle => If (key_vld = '1') then state <= ST_key_in; end if;
				When ST_key_in => state <= ST_key_exp;
				When ST_key_exp => If (r_cnt = "1001101") then state <= ST_ready; end if;
				When ST_ready => state <= ST_idle;
			End Case;
		End if;
	End Process;

	Process (clr, clk) Begin
		If (clr = '0') then
			a_reg <= (others => '0');
		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then
				a_reg <= a_circ;
			End if;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then
			b_reg <= (others => '0');
		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then
				b_reg <= b_circ;
			End if;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then 
			i_cnt <= (others => '0');
		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then
				If (i_cnt = "11001") then
					i_cnt <= (others => '0');
				Else
					i_cnt <= i_cnt+1;
				End if;
			End If;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then
			j_cnt <= (others => '0');
		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then
				If (j_cnt = "00011") then
					j_cnt <= (others => '0');
				Else
					j_cnt <= j_cnt+1;
				End If;
			End if;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then
			r_cnt <= (others => '0');
		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then r_cnt <= r_cnt + '1'; End If;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then
			s(0) <= X"b7e15163"; s(1) <= X"5618cb1c";s(2) <= X"f45044d5";s(3) <= X"9287be8e";s(4) <= X"30bf3847";s(5) <= X"cef6b200";s(6) <= X"6d2e2bb9";s(7) <= X"0b65a572";s(8) <= X"a99d1f2b";s(9) <= X"47d498e4";s(10) <= X"e60c129d";s(11) <= X"84438c56";s(12) <= X"227b060f";s(13) <= X"c0b27fc8";s(14) <= X"5ee9f981";s(15) <= X"fd21733a";s(16) <= X"9b58ecf3";s(17) <= X"399066ac";s(18) <= X"d7c7e065";s(19) <= X"75ff5a1e";s(20) <= X"1436d3d7";s(21) <= X"b26e4d90";s(22) <= X"50a5c749";s(23) <= X"eedd4102";s(24) <= X"8d14babb";s(25) <= X"2b4c3474";

		Elsif (clk'event and clk = '1') then
			If (state = ST_key_exp) then 
				s(conv_integer(i_cnt)) <= a_circ;
			End if;
		End if;
	End Process;
	
	Process (clr, clk) Begin
		If (clr = '0') then
			L(0) <= (Others => '0');
			L(1) <= (Others => '0');
			L(2) <= (Others => '0');
			L(3) <= (Others => '0');
		Elsif (clk'event and clk = '1') then 
			If (state = ST_key_in) then
				L(0) <= key_in(31 downto 0);
				L(1) <= key_in(63 downto 32);
				L(2) <= key_in(95 downto 64);
				L(3) <= key_in(127 downto 96);
			Elsif (state = ST_key_exp) then
				L(conv_integer(j_cnt)) <= b_circ;
			End if;
		End if;
	End Process;
	
skey <= s;
	With state Select
		key_rdy <= '1' when ST_ready, 
					'0' when others;

End rtl;
