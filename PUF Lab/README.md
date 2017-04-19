
## Ring_Oscillator_Generator
		Implements RO using structural modelling. 
		Allows users to specify the number of elements in RO Path. Change RO_ChainLength in VHDL File.
		Allows user to control the placement of RO in any part of FPGA using UCF File.
		(For even greater control over placement.. see Lab 1 document) 	
		
## Ring_Oscillator_Generator Folder Organization 
		--Ring_Ocillator_VHDL_Code
			|
			|--RO_GENIE.vhd (Main VHDL file describing RO)
			|--RO_GENIE.ucf (UCF File to control placement of the RO)

Lab #6: PUFs on FPGA

This lab consists of 2 parts and all the students in the class will coordinate with each other to share designs and data to perform the analysis. (Assuming all students have Nexys 4 DDR FPGA)

Part 1: Implement, demonstrate and analyze a Ring Oscillator based PUF on FPGA. You can use switches and 7-Segment LEDs or UART  to show the results. 

Part 2a: Share your bit file, instructions on how to use the interface, and a subset of your challenge response pair with other students. Upload to "PUF Lab" in github repository https://github.com/IamVNIE/Hardware-Security/ . Create a folder with your group name and place all the files there.

Part 2b: Run other students PUF and obtain the responses for the challenges specified and provide an analysis. 

Compile the analysis and findings on your PUF and other students PUF and submit a report. 

Complete your design by next Tuesday (4/25) and share it with students. Any questions contact vj338@nyu.edu.