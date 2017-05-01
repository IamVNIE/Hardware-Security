# PUF LAB - 6
# Authors: 
Ramkumar Ranjithkumar, Qasim Idrees

# Switches Used:
J15: Reset

L16: Enable

M13: C1<0>

R15: C1<1>

R17: C1<2>

T18: C2<0>

U18: C2<1>

R13: C2<2>

H17: LED

Program the Bit File in FPGA. There are 8 Ring Oscillators in the PUF and so there are possible 28 Combinations to compare the count value. Select one of the PUFs using the switches for C2 and the other from C1. Then trigger the Reset Pin from 0 to 1 and then Enable from 0 to 1. The Rightmost LED gives the output.

# Response Pairs
1) C1<000> C2<001>: 1
2) C1<000> C2<010>: 1
3) C1<000> C2<011>: 1
4) C1<000> C2<100>: 0
5) C1<000> C2<101>: 1
6) C1<000> C2<110>: 0
7) C1<000> C2<111>: 1
8) C1<001> C2<010>: 0
9) C1<001> C2<011>: 0
10) C1<001> C2<100>: 0
11) C1<001> C2<101>: 0
12) C1<001> C2<110>: 0
13) C1<001> C2<111>: 0
14) C1<010> C2<011>: 1
15) C1<010> C2<100>: 0
16) C1<010> C2<101>: 1
17) C1<010> C2<110>: 0
18) C1<010> C2<111>: 1
19) C1<011> C2<100>: 0
20) C1<011> C2<101>: 0
21) C1<011> C2<110>: 0
22) C1<011> C2<111>: 0
23) C1<100> C2<101>: 1
24) C1<100> C2<110>: 0
25) C1<100> C2<111>: 1
26) C1<101> C2<110>: 0
27) C1<101> C2<111>: 1
28) C1<110> C2<111>: 1
