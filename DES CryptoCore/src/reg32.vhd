library ieee ;
use ieee.std_logic_1164.all;
entity reg32 is
port(
a : in std_logic_vector (1 to 32);
q : out std_logic_vector (1 to 32);
reset : in std_logic;
clk : in std_logic
);
end reg32;
architecture synth of reg32 is
signal memory : std_logic_vector (1 to 32) ;
begin
process(clk,reset)
begin
if(reset = '1') then
memory <= (others => '0');
elsif(clk = '1' and clk'event) then
memory <= a;
end if;
end process;
q <= memory;
end synth;
