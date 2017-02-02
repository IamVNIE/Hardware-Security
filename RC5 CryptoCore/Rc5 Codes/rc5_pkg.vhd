Library IEEE;
Use		IEEE.std_logic_1164.all;

Package rc5_pkg Is
--S Rom array
	Type rom Is Array (0 to 25) of std_logic_vector (31 downto 0);

--L Rom array	
	Type L_rom Is Array (0 to 3) of std_logic_vector (31 downto 0);

--Type for RC5 State Machine
	Type StateType IS
		(
			ST_idle,
			ST_pre_round,
			ST_round_op,
			ST_ready
		);
	Signal state	:	StateType;
	
End rc5_pkg;