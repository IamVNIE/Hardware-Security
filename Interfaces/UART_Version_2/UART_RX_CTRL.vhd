----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Vinayaka Jyothi
-- 
-- Create Date:    12:22:17 11/13/2016 
-- Design Name: 
-- Module Name:    UART_RX_CTRL - Behavioral 
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

----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX_CTRL is
		 port ( UART_RX	: in   STD_LOGIC;
				  CLK			: in   STD_LOGIC;
				  DATA		: out  STD_LOGIC_VECTOR (7 downto 0);
				  READ_DATA	: out  STD_LOGIC := '0';
				  RESET_READ: in   STD_LOGIC);
end UART_RX_CTRL;

architecture behavioral of UART_RX_CTRL is
    
    constant FREQ : integer := 100000000;  -- 100MHz Nexys4 CLK
    constant BAUD : integer := 9600;       
	 
    signal   count   : integer := 0;
    constant sample_0: integer := 3 * FREQ/(BAUD*2)-1;
    constant sample_1: integer := 5 * FREQ/(BAUD*2)-1;
    constant sample_2: integer := 7 * FREQ/(BAUD*2)-1;
    constant sample_3: integer := 9 * FREQ/(BAUD*2)-1;
    constant sample_4: integer := 11 * FREQ/(BAUD*2)-1;
    constant sample_5: integer := 13 * FREQ/(BAUD*2)-1;
    constant sample_6: integer := 15 * FREQ/(BAUD*2)-1;
    constant sample_7: integer := 17 * FREQ/(BAUD*2)-1;
    constant stop_bit: integer := 19 * FREQ/(BAUD*2)-1;
    
    signal byte: std_logic_vector(7 downto 0) := (others => '0');
    
begin
    rx_state_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            
            if (RESET_READ = '1') then
                READ_DATA <= '0';
            end if;
            
            case count is 
                when sample_0 => byte <= UART_RX & byte(7 downto 1);
                when sample_1 => byte <= UART_RX & byte(7 downto 1);
                when sample_2 => byte <= UART_RX & byte(7 downto 1);
                when sample_3 => byte <= UART_RX & byte(7 downto 1);
                when sample_4 => byte <= UART_RX & byte(7 downto 1);
                when sample_5 => byte <= UART_RX & byte(7 downto 1);
                when sample_6 => byte <= UART_RX & byte(7 downto 1);
                when sample_7 => byte <= UART_RX & byte(7 downto 1);
                when stop_bit =>  
											  if UART_RX = '1' then 
													DATA <= byte;
													READ_DATA <= '1';
											  end if;
                when others => null;
            end case;
            
            if count = stop_bit then
                count <= 0;
            elsif count = 0 then
                if UART_RX = '0' then
                    count <= count + 1;   
                end if;
            else
                count <= count + 1;   
            end if;
        end if;
    end process;
end behavioral;
