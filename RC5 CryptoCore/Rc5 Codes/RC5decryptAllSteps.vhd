Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_unsigned.all;
Use Work.RC5_Pkg.all;

Entity rc5_dec IS
	Port
	(																			--Ports
		clr		:	In std_logic;
		clk		:	In std_logic;
		
		din		:	In std_logic_vector(63 downto 0);
		din_vld	:	In std_logic;
		
		key_rdy	:	In std_logic;
		skey	: 	In rom;
		
		dout	:	Out std_logic_vector(63 downto 0);
		dout_rdy :	Out	std_logic
	);
End rc5_dec;

Architecture rtl Of rc5_dec IS

--signals																		--Signals
	Signal i_cnt	:	Std_logic_vector(3 downto 0);
	
	Signal ab_key	:	Std_logic_vector(31 downto 0);
	Signal a_rot	:	Std_logic_vector(31 downto 0);
	Signal a 		:	Std_logic_vector(31 downto 0);
	Signal a_reg	:	Std_logic_vector(31 downto 0);
	Signal a_skey0 :	Std_logic_vector(31 downto 0);
	
	Signal ba_key	:	Std_logic_vector(31 downto 0);
	Signal b_rot	:	Std_logic_vector(31 downto 0);
	Signal b 		:	Std_logic_vector(31 downto 0);
	Signal b_reg	:	Std_logic_vector(31 downto 0);
	Signal b_skey1	:	Std_logic_vector(31 downto 0);
	
--Type for state machine
	Type StateType IS
		(
			ST_idle,
			ST_pre_round,
			ST_round_op,
			ST_ready
		);
		
--Signal for state machine
	Signal state_de	:	StateType;

--Architecture
Begin

--Step Pre_B
	b_skey1 <= b_reg - skey(1);											--Subtract skey(1) from din

--Step B (B=((B-S[2*i+1])>>>A) XOR A)
	ba_key <= b_reg - skey(Conv_Integer(i_cnt & '1')); 					--Subtract key from B
	
	With a_reg(4 downto 0) Select 										--rotate B by A
		b_rot <= ba_key (0) & ba_key(31 downto 1) when "00001",
			ba_key(1 downto 0) & ba_key(31 downto 2) when "00010",
			ba_key(2 downto 0) & ba_key(31 downto 3) when "00011",
			ba_key(3 downto 0) & ba_key(31 downto 4) when "00100",
			ba_key(4 downto 0) & ba_key(31 downto 5) when "00101",
			ba_key(5 downto 0) & ba_key(31 downto 6) when "00110",
			ba_key(6 downto 0) & ba_key(31 downto 7) when "00111",
			ba_key(7 downto 0) & ba_key(31 downto 8) when "01000",
			ba_key(8 downto 0) & ba_key(31 downto 9) when "01001",
			ba_key(9 downto 0) & ba_key(31 downto 10) when "01010",
			ba_key(10 downto 0) & ba_key(31 downto 11) when "01011",
			ba_key(11 downto 0) & ba_key(31 downto 12) when "01100",
			ba_key(12 downto 0) & ba_key(31 downto 13) when "01101",
			ba_key(13 downto 0) & ba_key(31 downto 14) when "01110",
			ba_key(14 downto 0) & ba_key(31 downto 15) when "01111",
			ba_key(15 downto 0) & ba_key(31 downto 16) when "10000",
			ba_key(16 downto 0) & ba_key(31 downto 17) when "10001",
			ba_key(17 downto 0) & ba_key(31 downto 18) when "10010",
			ba_key(18 downto 0) & ba_key(31 downto 19) when "10011",
			ba_key(19 downto 0) & ba_key(31 downto 20) when "10100",
			ba_key(20 downto 0) & ba_key(31 downto 21) when "10101",
			ba_key(21 downto 0) & ba_key(31 downto 22) when "10110",
			ba_key(22 downto 0) & ba_key(31 downto 23) when "10111",
			ba_key(23 downto 0) & ba_key(31 downto 24) when "11000",
			ba_key(24 downto 0) & ba_key(31 downto 25) when "11001",
			ba_key(25 downto 0) & ba_key(31 downto 26) when "11010",
			ba_key(26 downto 0) & ba_key(31 downto 27) when "11011",
			ba_key(27 downto 0) & ba_key(31 downto 28) when "11100",
			ba_key(28 downto 0) & ba_key(31 downto 29) when "11101",
			ba_key(29 downto 0) & ba_key(31 downto 30) when "11110",
			ba_key(30 downto 0) & ba_key(31) when "11111",
			ba_key when others;

	b <= b_rot XOR a_reg; 												--XOR with A after rotation

--Step A (A=((A-S[2*i])>>>B) XOR B)
	a_skey0 <= a_reg - skey(0);

	ab_key <= a_reg - skey(Conv_Integer(i_cnt & '0')); 					--subtract key from A
	
		With b(4 downto 0) Select										--Rotate A by result of b
		a_rot <= ab_key (0) & ab_key(31 downto 1) when "00001",
			ab_key(1 downto 0) & ab_key(31 downto 2) when "00010",
			ab_key(2 downto 0) & ab_key(31 downto 3) when "00011",
			ab_key(3 downto 0) & ab_key(31 downto 4) when "00100",
			ab_key(4 downto 0) & ab_key(31 downto 5) when "00101",
			ab_key(5 downto 0) & ab_key(31 downto 6) when "00110",
			ab_key(6 downto 0) & ab_key(31 downto 7) when "00111",
			ab_key(7 downto 0) & ab_key(31 downto 8) when "01000",
			ab_key(8 downto 0) & ab_key(31 downto 9) when "01001",
			ab_key(9 downto 0) & ab_key(31 downto 10) when "01010",
			ab_key(10 downto 0) & ab_key(31 downto 11) when "01011",
			ab_key(11 downto 0) & ab_key(31 downto 12) when "01100",
			ab_key(12 downto 0) & ab_key(31 downto 13) when "01101",
			ab_key(13 downto 0) & ab_key(31 downto 14) when "01110",
			ab_key(14 downto 0) & ab_key(31 downto 15) when "01111",
			ab_key(15 downto 0) & ab_key(31 downto 16) when "10000",
			ab_key(16 downto 0) & ab_key(31 downto 17) when "10001",
			ab_key(17 downto 0) & ab_key(31 downto 18) when "10010",
			ab_key(18 downto 0) & ab_key(31 downto 19) when "10011",
			ab_key(19 downto 0) & ab_key(31 downto 20) when "10100",
			ab_key(20 downto 0) & ab_key(31 downto 21) when "10101",
			ab_key(21 downto 0) & ab_key(31 downto 22) when "10110",
			ab_key(22 downto 0) & ab_key(31 downto 23) when "10111",
			ab_key(23 downto 0) & ab_key(31 downto 24) when "11000",
			ab_key(24 downto 0) & ab_key(31 downto 25) when "11001",
			ab_key(25 downto 0) & ab_key(31 downto 26) when "11010",
			ab_key(26 downto 0) & ab_key(31 downto 27) when "11011",
			ab_key(27 downto 0) & ab_key(31 downto 28) when "11100",
			ab_key(28 downto 0) & ab_key(31 downto 29) when "11101",
			ab_key(29 downto 0) & ab_key(31 downto 30) when "11110",
			ab_key(30 downto 0) & ab_key(31) when "11111",
			ab_key when others;
	
	a <= a_rot XOR b;													--XOR rotated A with result of b

	
--Register A
	Process(clr, clk) Begin
		If(clr='0') Then
			a_reg <= din(63 downto 32);
		elsif(clk'Event and clk='1') Then
			If (state_de = ST_round_op) Then
				a_reg <= a;
			End If;
		End If;
	End Process;
	
--Register B
	Process(clr, clk) Begin
		If(clr='0') Then
			b_reg <= din(31 downto 0);
		Elsif(clk'Event and clk='1') Then	
			If (state_de = ST_round_op) Then
				b_reg <= b;
			End If;
		End If;
	End Process;
	
--State Machine Counter
	Process(clr, clk) Begin
		If(clr='0') Then	
			state_de <= ST_idle;
		Elsif(clk'Event And clk='1') Then
			Case state_de IS
				When ST_idle => If (din_vld = '1' and key_rdy='1') Then state_de <= ST_round_op; End If;
				When ST_round_op => If (i_cnt = "0001") Then state_de <= ST_pre_round; End If;
				When ST_pre_round => state_de <= ST_ready;
				When ST_ready => state_de <= ST_idle;
			End Case;
		End If;
	End Process;
	
--Round Counter
	Process(clr, clk) Begin
		If(clr='0') Then	
			i_cnt <= "1100";
		Elsif(clk'Event And clk='1') Then
			If (state_de = ST_round_op) Then	
				If(i_cnt="0001") Then
					i_cnt <= "1100";
				Else
					i_cnt <= i_cnt - '1';
				End If;
			End If; 
		End If;
	End Process;

--Output	
dout <= a_skey0 & b_skey1;
	With state_de Select
		dout_rdy <= '1' When ST_ready,
					'0' When Others;

End rtl;