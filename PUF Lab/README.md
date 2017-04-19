# Hardware-Security

## Hardware Trojan Taxonomy
		TRUSTHUB Presentation: https://www.trust-hub.org/taxonomyResources/Taxonomy.pdf
## Tutorials on Tool-Chain

		https://plus.google.com/u/3/116149208990386154836

		https://www.youtube.com/watch?v=VBrKmNNKfTg

		https://www.youtube.com/watch?v=_s43QBUl9r0

		https://www.youtube.com/watch?v=xrpPpvORaIA

## DES Crypto Core
		Implements DES using mostly structural modelling. 
		This core is completely parallel. 
		New data can be pushed to the system every clock cycle.
		Latency = 19 Cycles

## DES Cypto Core File Hierarchy
		--src
			|
			|--Implementation Files (along with txt_util.vhd used by testbenches)
			|--DES_TOP_FILE.vhd: Top VHDL model describing DES
			|--test_vectors (folder)
					|
					|--DES_test_vectors.txt: Test vectors to test faults for different sub-blocks of DES
					|--DES_TV_Triplets_NBS.txt: This file is used by the testbench. 
											   Testbenches currently cannot any comments in the file.
			|--test_benches (folder)
					|
					|--DES_Decrypt_TestBench.vhd
					|--DES_Encrypt_TestBench
					
## DES USAGE
		Import all the files in src. Change Testbench files association to Simulation only in Hierarchy Window
				
