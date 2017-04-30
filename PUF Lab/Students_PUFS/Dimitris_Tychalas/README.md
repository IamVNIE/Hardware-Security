RO PUF with a 4-bit challenge and a 16-bit response
Authors : Dimitris Tychalas / Esha Sarkar

Switch J15 controls the enable signal that powers the ring oscillators
Button N17 resets the circuit
Switches U11-U12-H6-T13 provide the input challenge (MSB to LSB)

After powering up the device and loading the bit file, raise enable to '1' and reset (or start with the J15 switch turned on)

To try different challenges, choose a challenge through the switches and reset the circuit.

Output displayed on the 4 rightmost digits of the 7-segment display.

Sample challenge-response pairs:

Challenge |  Response | Response in binary  |
  2(0010) |   8b45    | 0100 1011 0100 0101 |
  6(0110) |   b4c8    | 1011 0100 1101 1000 |
  7(0111) |   062d    | 0000 0110 0011 1110 |
  5(0101) |   4466    | 0100 0100 0110 0110 |
  4(0100) |   0733    | 0000 0111 0011 0011 |
 12(1100) |   2422    | 0010 0100 0010 0010 |
 13(1101) |   74ba    | 0111 0100 1011 1010 |

Sample challenge inputs are ordered by Gray code. You can get a sample of the output entropy by averaging the hamming distance of adjacent pairs comparing their responses in binary.

	
	

