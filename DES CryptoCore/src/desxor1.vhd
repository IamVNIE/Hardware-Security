library ieee;
use ieee.std_logic_1164.all;
entity desxor1 is port
(
e : in std_logic_vector(1 TO 48);
b1x,b2x,b3x,b4x,b5x,b6x,b7x,b8x
: out std_logic_vector (1 TO 6);
k : in std_logic_vector (1 TO 48)
);
end desxor1;
architecture behavior of desxor1 is
signal XX : std_logic_vector( 1 to 48);
begin
XX<=k xor e;
b1x<=XX(1 to 6);
b2x<=XX(7 to 12);
b3x<=XX(13 to 18);
b4x<=XX(19 to 24);
b5x<=XX(25 to 30);
b6x<=XX(31 to 36);
b7x<=XX(37 to 42);
b8x<=XX(43 to 48);
end behavior;
