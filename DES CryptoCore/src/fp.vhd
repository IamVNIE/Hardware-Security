library ieee;
use ieee.std_logic_1164.all;
entity fp is port
(
l,r : in std_logic_vector(1 to 32);
pt : out std_logic_vector(1 to 64)
);
end fp;
architecture behaviour of fp is
begin
pt(1)<=r(8); pt(2)<=l(8); pt(3)<=r(16);pt(4)<=l(16);pt(5)<=r(24);pt(6)<=l(24); pt(7)<=r(32);pt(8)<=l(32);
pt(9)<=r(7); pt(10)<=l(7);pt(11)<=r(15); pt(12)<=l(15); pt(13)<=r(23); pt(14)<=l(23); pt(15)<=r(31); pt(16)<=l(31);
pt(17)<=r(6);pt(18)<=l(6);pt(19)<=r(14); pt(20)<=l(14); pt(21)<=r(22); pt(22)<=l(22); pt(23)<=r(30); pt(24)<=l(30);
pt(25)<=r(5);pt(26)<=l(5);pt(27)<=r(13); pt(28)<=l(13); pt(29)<=r(21); pt(30)<=l(21); pt(31)<=r(29); pt(32)<=l(29);
pt(33)<=r(4);pt(34)<=l(4);pt(35)<=r(12); pt(36)<=l(12); pt(37)<=r(20); pt(38)<=l(20);pt(39)<=r(28); pt(40)<=l(28);
pt(41)<=r(3);pt(42)<=l(3);pt(43)<=r(11); pt(44)<=l(11); pt(45)<=r(19); pt(46)<=l(19); pt(47)<=r(27); pt(48)<=l(27);
pt(49)<=r(2);pt(50)<=l(2);pt(51)<=r(10); pt(52)<=l(10); pt(53)<=r(18); pt(54)<=l(18); pt(55)<=r(26); pt(56)<=l(26);
pt(57)<=r(1);pt(58)<=l(1);pt(59)<=r(9);pt(60)<=l(9);pt(61)<=r(17); pt(62)<=l(17); pt(63)<=r(25); pt(64)<=l(25);
end;
