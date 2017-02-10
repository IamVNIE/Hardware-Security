----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:34:48 11/23/2016 
-- Design Name: 
-- Module Name:    SERIAL_PORT - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SERIAL_PORT  is
		 port (CLK				: in std_logic;
				 UART_RXD		: in std_logic;
				 UART_TXD		: out std_logic;
				 IM_WRITE_EN	: in 	std_logic;
				 reset			: in std_logic;
				 IM_WR_EN_from_UART	: out 	std_logic;
				 MEM_ADDRESS	: out std_logic_vector(31 downto 0);
				 LED_1			: out std_logic;
				 LED_2			: out std_logic;
				 count_sig			: out std_logic_vector(2 downto 0);
				 Ins_Data		: out std_logic_vector(31 downto 0));
end SERIAL_PORT;

architecture behaviour of SERIAL_PORT  is
  
    component UART_RX_CTRL is
				  port ( UART_RX	: in   STD_LOGIC;
						   CLK			: in   STD_LOGIC;
						   DATA		: out  STD_LOGIC_VECTOR (7 downto 0);
						   READ_DATA	: out  STD_LOGIC := '0';
						   RESET_READ: in   STD_LOGIC);
	 end component;
    
    component UART_TX_CTRL is
				  Port ( SEND		: in  STD_LOGIC;
						   DATA		: in  STD_LOGIC_VECTOR (7 downto 0);
						   CLK			: in  STD_LOGIC;
						   READY		: out  STD_LOGIC;
						   UART_TX 	: out  STD_LOGIC);
	 end component;
    
    signal uart_data_in: std_logic_vector(7 downto 0);
    signal uart_data_out: std_logic_vector(7 downto 0);

    signal data_available: std_logic;
    signal reset_read: std_logic := '0';

    signal tx_is_ready: std_logic;
    signal send_data: std_logic := '0';

    type SEND_STATE_TYPE is (READY, SENT, WAITING);
    signal SEND_STATE : SEND_STATE_TYPE := READY;

    signal last_six_chars: std_logic_vector(47 downto 0) := (others => '0');
	 signal count : std_logic_vector(2 downto 0) := (others => '0');
    
begin
    
	 count_sig <= count;
	 
    inst_UART_RX_CTRL: UART_RX_CTRL
        port map(	UART_RX => UART_RXD,
						CLK => CLK,
						DATA => uart_data_in,
						READ_DATA => data_available,
						RESET_READ => reset_read);
    
    inst_UART_TX_CTRL: UART_TX_CTRL
        port map(	SEND => send_data,
						CLK => CLK,
						DATA => uart_data_out,
						READY => tx_is_ready,
						UART_TX => UART_TXD);
    
    uart_receive: process(CLK, SEND_STATE, data_available)
    begin
			if (rising_edge(CLK)) then
				if reset = '1' then	last_six_chars(47 downto 0) <= x"000000000000";
											MEM_ADDRESS <= x"00000000";
											count <= "000";
											LED_2 <= '0';
											LED_1 <= '0';
				else
					case SEND_STATE is
						 when READY =>	if (data_available = '1' and tx_is_ready = '1') then
												
												last_six_chars(47 downto 8) <= last_six_chars(39 downto 0);
												last_six_chars(7 downto 0) <= uart_data_in;
												
												count <= count + 1;
												
													if count = "110" then
												 
														LED_2 <= '1';
															if (last_six_chars(47 downto 40) = x"04") then --write
																if IM_WRITE_EN = '1' then
																	LED_1 <= '1';
																	IM_WR_EN_from_UART <= '1';
																	MEM_ADDRESS <= x"000000" & last_six_chars(39 downto 32);
																	Ins_Data <= last_six_chars(31 downto 0);
		--														else
		--															IM_WR_EN_from_UART <= '0';
		--															MEM_ADDRESS <= x"000000FF";
		--															Ins_Data <= x"00000000";
																end if;
															else
																	IM_WR_EN_from_UART <= '0';
																	MEM_ADDRESS <= x"000000FF";
																	Ins_Data <= x"00000000";
															end if;
															
															count <= "000";
															uart_data_out <= x"01";
															send_data <= '1'; 
															
															--count_output <= count;  
														else 
															IM_WR_EN_from_UART <= '0';
															--count <= count + 1; 
															send_data <= '0'; 
															LED_2 <= '0';
															LED_1 <= '0';
															--count_output <= count; 
														end if;
															
												SEND_STATE <= SENT;
											end if;
						 
						 when SENT =>	reset_read <= '1';
											send_data <= '0';
											SEND_STATE <= WAITING;
						 
						 when WAITING =>	if (data_available = '0') then
													reset_read <= '0';
													SEND_STATE <= READY;
												end if;
					end case;
				end if;
			end if;
    end process;
    
end architecture;
