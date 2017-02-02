Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_unsigned.all;
Use Work.RC5_Pkg.all;

Entity rc5_enc Is
	Port
	(
		clr		:	in std_logic;
		clk		:	in std_logic;
		
		din		:	in std_logic_vector(63 downto 0);
		di_vld	:	in std_logic;
		
		key_rdy	:	in std_logic;
		skey	:	in rom;
		
		dout	:	out std_logic_vector(63 downto 0);
		do_rdy	:	out std_logic
	);
End rc5_enc;

Architecture rtl of rc5_enc is
	signal i_cnt	:	Std_logic_vector(3 downto 0);						--Signals
	
	signal ab_xor	:	Std_logic_vector(31 downto 0);
	signal a_rot	:	Std_logic_vector(31 downto 0);
	signal a		:	Std_logic_vector(31 downto 0);
	signal a_pre	:	Std_logic_vector(31 downto 0);
	signal a_reg	:	Std_logic_vector(31 downto 0);
	
	signal ba_xor	:	Std_logic_vector(31 downto 0);
	signal b_rot	:	Std_logic_vector(31 downto 0);
	signal b		:	Std_logic_vector(31 downto 0);
	signal b_pre	:	Std_logic_vector(31 downto 0);
	signal b_reg	:	Std_logic_vector(31 downto 0);
			
--RC5 State Machine
Type StateType is 														--Type for state machine
	(
		ST_idle,
		ST_pre_round,
		ST_round_op,
		ST_ready
	);
Signal state_en	:	StateType;											--Signal type of state machine

Begin
	ab_xor <= a_reg XOR b_reg;											--A_reg _reg XOR
	With b_reg(4 downto 0) Select										--Rotate left XOR result 
		a_rot <= ab_xor(30 downto 0) & ab_xor(31) when "00001",
			ab_xor(29 downto 0) & ab_xor(31 downto 30) when "00010",
			ab_xor(28 downto 0) & ab_xor(31 downto 29) when "00011",
			ab_xor(27 downto 0) & ab_xor(31 downto 28) when "00100",
			ab_xor(26 downto 0) & ab_xor(31 downto 27) when "00101",
			ab_xor(25 downto 0) & ab_xor(31 downto 26) when "00110",
			ab_xor(24 downto 0) & ab_xor(31 downto 25) when "00111",
			ab_xor(23 downto 0) & ab_xor(31 downto 24) when "01000",
			ab_xor(22 downto 0) & ab_xor(31 downto 23) when "01001",
			ab_xor(21 downto 0) & ab_xor(31 downto 22) when "01010",
			ab_xor(20 downto 0) & ab_xor(31 downto 21) when "01011",
			ab_xor(19 downto 0) & ab_xor(31 downto 20) when "01100",
			ab_xor(18 downto 0) & ab_xor(31 downto 19) when "01101",
			ab_xor(17 downto 0) & ab_xor(31 downto 18) when "01110",
			ab_xor(16 downto 0) & ab_xor(31 downto 17) when "01111",
			ab_xor(15 downto 0) & ab_xor(31 downto 16) when "10000",
			ab_xor(14 downto 0) & ab_xor(31 downto 15) when "10001",
			ab_xor(13 downto 0) & ab_xor(31 downto 14) when "10010",
			ab_xor(12 downto 0) & ab_xor(31 downto 13) when "10011",
			ab_xor(11 downto 0) & ab_xor(31 downto 12) when "10100",
			ab_xor(10 downto 0) & ab_xor(31 downto 11) when "10101",
			ab_xor(9 downto 0) & ab_xor(31 downto 10) when "10110",
			ab_xor(8 downto 0) & ab_xor(31 downto 9) when "10111",
			ab_xor(7 downto 0) & ab_xor(31 downto 8) when "11000",
			ab_xor(6 downto 0) & ab_xor(31 downto 7) when "11001",
			ab_xor(5 downto 0) & ab_xor(31 downto 6) when "11010",
			ab_xor(4 downto 0) & ab_xor(31 downto 5) when "11011",
			ab_xor(3 downto 0) & ab_xor(31 downto 4) when "11100",
			ab_xor(2 downto 0) & ab_xor(31 downto 3) when "11101",
			ab_xor(1 downto 0) & ab_xor(31 downto 2) when "11110",
			ab_xor(0) & ab_xor(31 downto 1) when "11111",
			ab_xor when others;
	a_pre <= din(63 downto 32) + skey(0);								--A_pre output after add din and skey
	a <= a_rot + skey(CONV_INTEGER(i_cnt & '0'));						--A output after add left rotate and skey

	ba_xor <= b_reg XOR a;												--B_reg XOR with A
	with a(4 downto 0) Select											--Rotate left result of XOR
		b_rot <= ba_xor(30 downto 0) & ba_xor(31) when "00001",
			ba_xor(29 downto 0) & ba_xor(31 downto 30) when "00010",
			ba_xor(28 downto 0) & ba_xor(31 downto 29) when "00011",
			ba_xor(27 downto 0) & ba_xor(31 downto 28) when "00100",
			ba_xor(26 downto 0) & ba_xor(31 downto 27) when "00101",
			ba_xor(25 downto 0) & ba_xor(31 downto 26) when "00110",
			ba_xor(24 downto 0) & ba_xor(31 downto 25) when "00111",
			ba_xor(23 downto 0) & ba_xor(31 downto 24) when "01000",
			ba_xor(22 downto 0) & ba_xor(31 downto 23) when "01001",
			ba_xor(21 downto 0) & ba_xor(31 downto 22) when "01010",
			ba_xor(20 downto 0) & ba_xor(31 downto 21) when "01011",
			ba_xor(19 downto 0) & ba_xor(31 downto 20) when "01100",
			ba_xor(18 downto 0) & ba_xor(31 downto 19) when "01101",
			ba_xor(17 downto 0) & ba_xor(31 downto 18) when "01110",
			ba_xor(16 downto 0) & ba_xor(31 downto 17) when "01111",
			ba_xor(15 downto 0) & ba_xor(31 downto 16) when "10000",
			ba_xor(14 downto 0) & ba_xor(31 downto 15) when "10001",
			ba_xor(13 downto 0) & ba_xor(31 downto 14) when "10010",
			ba_xor(12 downto 0) & ba_xor(31 downto 13) when "10011",
			ba_xor(11 downto 0) & ba_xor(31 downto 12) when "10100",
			ba_xor(10 downto 0) & ba_xor(31 downto 11) when "10101",
			ba_xor(9 downto 0) & ba_xor(31 downto 10) when "10110",
			ba_xor(8 downto 0) & ba_xor(31 downto 9) when "10111",
			ba_xor(7 downto 0) & ba_xor(31 downto 8) when "11000",
			ba_xor(6 downto 0) & ba_xor(31 downto 7) when "11001",
			ba_xor(5 downto 0) & ba_xor(31 downto 6) when "11010",
			ba_xor(4 downto 0) & ba_xor(31 downto 5) when "11011",
			ba_xor(3 downto 0) & ba_xor(31 downto 4) when "11100",
			ba_xor(2 downto 0) & ba_xor(31 downto 3) when "11101",
			ba_xor(1 downto 0) & ba_xor(31 downto 2) when "11110",
			ba_xor(0) & ba_xor(31 downto 1) when "11111",
			ba_xor when others;
	b_pre <= din(31 downto 0) + skey(1);								--B output when add din and skey 1
	b <= b_rot + skey(CONV_INTEGER(i_cnt & '1'));						--B output when add left rotate and skey
	
--Register A															--Register A
	Process(clr, clk) Begin
		If(clr='0') Then
			a_reg <= (Others => '0');
		elsif(clk'Event and clk='1') Then
			If (state_en=ST_pre_round) Then 
				a_reg <= a_pre;
			Elsif (state_en=ST_round_op) Then
				a_reg <= a;
			End if;
		End If;
	End Process;
	
--Register B															--Register B
	Process(clr, clk) Begin
		If(clr='0') Then
			b_reg <= (Others => '0');
		Elsif(clk'Event and clk='1') Then	
			If (state_en=ST_pre_round) Then
				b_reg <= b_pre;
			Elsif (state_en=ST_round_op) Then
				b_reg <= b;
			End if;
		End If;
	End Process;

Process (clr, clk)														--State Machine
    Begin
        If (clr='0') Then
            state_en <= ST_idle;
        Elsif (clk'Event And clk = '1') Then
            Case state_en is
                When ST_idle => If (di_vld='1' and key_rdy='1') Then state_en <= ST_pre_round; End If;
                When ST_pre_round => state_en <= ST_round_op;
                When ST_round_op => If (i_cnt="1100") Then state_en <= ST_ready; End If;
                When ST_ready => state_en <= ST_idle;
             End Case;
        End If;
End Process;
	
Process(clr, clk) Begin													--Round Counter
	If(clr='0') Then	
		i_cnt <= "0001";
	Elsif(clk'Event And clk='1') Then
		If (state_en = ST_round_op) Then
			If(i_cnt="1100") Then
				i_cnt <= "0001";
			Else
				i_cnt <= i_cnt + '1';
			End If;
		End If;
	End If;
End Process;

	dout <= a_reg & b_reg;
		With state_en Select
			do_rdy <=	'1' When ST_ready,
						'0' When Others;
	
End rtl;