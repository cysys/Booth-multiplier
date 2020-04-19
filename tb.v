`timescale 1ns / 100ps

module tb;
	parameter numBitsTB = 4; // Paramter to define the number of bits that is used in the multiplier
	reg signed [numBitsTB - 1:0]multiplicand;
	reg signed [numBitsTB - 1:0]multiplier;
	wire signed [2 * numBitsTB - 1:0]p;


	boothMultiplier DUT(p, multiplicand, multiplier);
	defparam DUT.numBits = numBitsTB; // Passes the number of bits defined in numBitsTB to the numBits parameter in the multiplier module
	
	integer i; // for loop variable
	integer j; // for loop variable

	integer failCount; // maintains count of failed test cases
	integer totalCount; // maintains count of total test cases

	real failPercentage; // maintains percentage of test case failure


	initial
	begin

		
		failCount = 0;
		totalCount = 0;

		// The loops to generate all the test cases
		for(i = -(2 ** (numBitsTB - 1)) + 1 ; i < 2 ** (numBitsTB - 1); i = i + 1)
		begin
			for(j = -(2 ** (numBitsTB - 1)) + 1; j < 2 ** (numBitsTB - 1); j =  j + 1)
			begin
				
				multiplicand = i; multiplier = j;
				totalCount = totalCount + 1;

				#0 // Required to make sure p doesn't become x

				if(multiplicand * multiplier != p)
				begin
					write("%c[1;31m",27); // Text in color green

					$display("FAILED Testcase: multiplicand = %d, multiplier = %d, Output produced p = %d (Binary output: %b)", multiplicand, multiplier, p, p);

					$write("%c[0m",27);

					failCount =  failCount + 1;
				end
				else
				begin
					$write("%c[1;32m",27); // Text in color red

					$display("Passed Testcase: multiplicand = %d, multiplier = %d, Output produced p = %d (Binary output: %b)",  multiplicand, multiplier, p, p);

					$write("%c[0m",27);
				end
			end
		end

		failPercentage = (failCount / totalCount )* 100;

		// Displays Test summary
		$display("\n\n");

		$write("%c[1;36m",27);  // Text in color cyan.
		$display("Test Summary");
		$write("%c[0m",27);

		$display("No. of testcases run:%d", totalCount);
		$display("No. of testcases failed:%d", failCount);
		$display("Failure percentage:%d %", failPercentage);

		$finish;
	end
endmodule