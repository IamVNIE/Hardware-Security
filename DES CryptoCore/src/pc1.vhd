library ieee;
use ieee.std_logic_1164.all;
entity pc1 is port
(
key : in std_logic_vector(1 TO 64);
c0x,d0x : out std_logic_vector(1 TO 28)
);
end pc1;
architecture behavior of pc1 is
signal XX : std_logic_vector(1 to 56);
begin
XX(1)<=key(57); XX(2)<=key(49); XX(3)<=key(41); XX(4)<=key(33); XX(5)<=key(25); XX(6)<=key(17);
XX(7)<=key(9); XX(8)<=key(1); XX(9)<=key(58); XX(10)<=key(50); XX(11)<=key(42); XX(12)<=key(34); 
XX(13)<=key(26); XX(14)<=key(18); XX(15)<=key(10); XX(16)<=key(2); XX(17)<=key(59); XX(18)<=key(51);
XX(19)<=key(43); XX(20)<=key(35); XX(21)<=key(27); XX(22)<=key(19); XX(23)<=key(11); XX(24)<=key(3);
XX(25)<=key(60); XX(26)<=key(52); XX(27)<=key(44); XX(28)<=key(36); XX(29)<=key(63); XX(30)<=key(55);
XX(31)<=key(47); XX(32)<=key(39); XX(33)<=key(31); XX(34)<=key(23); XX(35)<=key(15); XX(36)<=key(7); 
XX(37)<=key(62); XX(38)<=key(54); XX(39)<=key(46); XX(40)<=key(38); XX(41)<=key(30); XX(42)<=key(22);
XX(43)<=key(14); XX(44)<=key(6); XX(45)<=key(61); XX(46)<=key(53); XX(47)<=key(45); XX(48)<=key(37);
XX(49)<=key(29); XX(50)<=key(21); XX(51)<=key(13); XX(52)<=key(5);XX(53)<=key(28); XX(54)<=key(20); 
XX(55)<=key(12); XX(56)<=key(4);
c0x<=XX(1 to 28); d0x<=XX(29 to 56);
end behavior;
