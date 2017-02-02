Library IEEE;
Use IEEE.std_logic_1164.All;
Use IEEE.std_logic_arith.All;
Use IEEE.std_logic_unsigned.All;
Use Work.RC5_pkg.All;

Entity rc5_Struct is 
	Port
		(
			clr			: in std_logic;
			clk			: in std_logic;
			
			enc			: in std_logic;
			
			key_vld		: in std_logic;
			key			: in std_logic_vector (127 downto 0);
			
			data_vld	: in std_logic;
			din			: in std_logic_vector (63 downto 0);
			
			dout		: out std_logic_vector (63 downto 0);
			data_rdy	: out std_logic
		);
End rc5_Struct;

--Architecture
Architecture struct of rc5_Struct is 

--Key Expansion Module
	Component rc5_rnd_key 
		Port
		(
		clr		:	in std_logic;
		clk		:	in std_logic;
		key_vld	:	in std_logic;
		key_in	:	in Std_logic_vector (127 downto 0);
		skey	:	out rom;
		key_rdy	:	out std_logic
		);
	End Component;
	
--Encryption Module
	Component rc5_enc
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
	End Component;
	
--Decryption Module
	Component rc5_dec
		Port 
		(
		clr		:	In std_logic;
		clk		:	In std_logic;
		
		din		:	In std_logic_vector(63 downto 0);
		din_vld	:	In std_logic;
		
		key_rdy	:	In std_logic;
		skey	: 	In rom;
		
		dout	:	Out std_logic_vector(63 downto 0);
		dout_rdy :	Out	std_logic
		);
	End Component;

--Signals
		Signal skey		: rom;
		Signal key_rdy	: std_logic;
		Signal dout_enc	: std_logic_vector (63 downto 0);
		Signal dout_dec	: std_logic_vector (63 downto 0);
		Signal enc_rdy	: std_logic;
		Signal dec_rdy	: std_logic;
		Signal i_cnt	: std_logic_vector (3 downto 0);
	
Begin	
		
--Port Maps
	U1 : rc5_rnd_key Port Map (clr => clr, clk => clk, key_in => key, key_vld => key_vld, skey => skey, key_rdy => key_rdy);
	U2 : rc5_enc Port Map (clr => clr, clk => clk, din => din, di_vld => key_rdy, skey => skey, dout => dout_enc, do_rdy => enc_rdy, key_rdy => key_rdy);
	U3 : rc5_dec Port Map (clr => clr, clk => clk, din => din, din_vld => key_rdy, skey => skey, dout => dout_dec, dout_rdy => dec_rdy, key_rdy => key_rdy);
	
--Select
	With enc select
		dout <= dout_enc when '1',
				dout_dec when others;
	With enc select
		data_rdy <= enc_rdy when '1',
					dec_rdy when others;

--End structure
End struct;

	