library ieee;
use ieee.std_logic_1164.all;
entity pp is port
(
so1x,so2x,so3x,so4x,so5x,so6x,so7x,so8x
: in std_logic_vector(1 to 4);
ppo : out std_logic_vector(1 to 32)
);
end pp;
architecture behaviour of pp is
signal XX : std_logic_vector(1 to 32);
begin
XX(1 to 4)<=so1x; XX(5 to 8)<=so2x; XX(9 to 12)<=so3x; XX(13 to 16)<=so4x;
XX(17 to 20)<=so5x; XX(21 to 24)<=so6x; XX(25 to 28)<=so7x; XX(29 to 32)<=so8x;

ppo(1)<=XX(16); ppo(2)<=XX(7); ppo(3)<=XX(20); ppo(4)<=XX(21);
ppo(5)<=XX(29); ppo(6)<=XX(12); ppo(7)<=XX(28); ppo(8)<=XX(17);
ppo(9)<=XX(1); ppo(10)<=XX(15); ppo(11)<=XX(23); ppo(12)<=XX(26);
ppo(13)<=XX(5); ppo(14)<=XX(18); ppo(15)<=XX(31); ppo(16)<=XX(10);
ppo(17)<=XX(2); ppo(18)<=XX(8); ppo(19)<=XX(24); ppo(20)<=XX(14);
ppo(21)<=XX(32); ppo(22)<=XX(27); ppo(23)<=XX(3); ppo(24)<=XX(9);
ppo(25)<=XX(19); ppo(26)<=XX(13); ppo(27)<=XX(30); ppo(28)<=XX(6);
ppo(29)<=XX(22); ppo(30)<=XX(11); ppo(31)<=XX(4); ppo(32)<=XX(25);
end;