library ieee;
use ieee.std_logic_1164.all;
entity xp is port
(
ri : in std_logic_vector(1 TO 32);
e : out std_logic_vector(1 TO 48));
end xp;
architecture behavior of xp is
begin
e(1)<=ri(32);e(2)<=ri(1); e(3)<=ri(2); e(4)<=ri(3); 		e(5)<=ri(4); e(6)<=ri(5); 
e(7)<=ri(4); e(8)<=ri(5); e(9)<=ri(6); e(10)<=ri(7); 		e(11)<=ri(8);e(12)<=ri(9);
e(13)<=ri(8); e(14)<=ri(9);e(15)<=ri(10); e(16)<=ri(11); e(17)<=ri(12); e(18)<=ri(13); 
e(19)<=ri(12); e(20)<=ri(13); e(21)<=ri(14); e(22)<=ri(15); e(23)<=ri(16); e(24)<=ri(17);
e(25)<=ri(16); e(26)<=ri(17); e(27)<=ri(18); e(28)<=ri(19); e(29)<=ri(20); e(30)<=ri(21);
e(31)<=ri(20); e(32)<=ri(21); e(33)<=ri(22); e(34)<=ri(23); e(35)<=ri(24); e(36)<=ri(25);
e(37)<=ri(24); e(38)<=ri(25); e(39)<=ri(26); e(40)<=ri(27); e(41)<=ri(28); e(42)<=ri(29); 
e(43)<=ri(28); e(44)<=ri(29); e(45)<=ri(30); e(46)<=ri(31); e(47)<=ri(32); e(48)<=ri(1);
end behavior;
