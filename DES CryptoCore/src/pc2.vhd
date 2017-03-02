library ieee;
use ieee.std_logic_1164.all;
entity pc2 is port
(
c,d : in std_logic_vector(1 TO 28);
k : out std_logic_vector(1 TO 48)
);
end pc2;
architecture behavior of pc2 is
signal YY : std_logic_vector(1 to 56);
begin
YY(1 to 28)<=c; YY(29 to 56)<=d;
k(1)<=YY(14);	k(2)<=YY(17);	k(3)<=YY(11);	k(4)<=YY(24);	k(5)<=YY(1); k(6)<=YY(5);
k(7)<=YY(3); k(8)<=YY(28);k(9)<=YY(15);k(10)<=YY(6);k(11)<=YY(21); k(12)<=YY(10);
k(13)<=YY(23); k(14)<=YY(19); k(15)<=YY(12); k(16)<=YY(4); k(17)<=YY(26); k(18)<=YY(8);
k(19)<=YY(16); k(20)<=YY(7);k(21)<=YY(27); k(22)<=YY(20); k(23)<=YY(13); k(24)<=YY(2);
k(25)<=YY(41); k(26)<=YY(52); k(27)<=YY(31); k(28)<=YY(37); k(29)<=YY(47); k(30)<=YY(55);
k(31)<=YY(30); k(32)<=YY(40); k(33)<=YY(51); k(34)<=YY(45); k(35)<=YY(33); k(36)<=YY(48);
k(37)<=YY(44); k(38)<=YY(49); k(39)<=YY(39); k(40)<=YY(56); k(41)<=YY(34); k(42)<=YY(53);
k(43)<=YY(46); k(44)<=YY(42); k(45)<=YY(50); k(46)<=YY(36); k(47)<=YY(29); k(48)<=YY(32);
end behavior;
