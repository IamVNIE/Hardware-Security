library ieee;
use ieee.std_logic_1164.all;
entity desxor2 is port
(
d,l : in std_logic_vector(1 to 32);
q : out std_logic_vector(1 to 32)
);
end desxor2;
architecture behaviour of desxor2 is
begin
q<=d xor l;
end;
