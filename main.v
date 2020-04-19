module boothMultiplier(p, m, r);
	parameter numBits = 4; // Parameter deciding the number of bits used in the module
	output reg signed [2*numBits - 1:0]p;
	input [numBits - 1:0]m;
	input [numBits - 1:0]r;

	reg signed [2*numBits:0]A; // Refer algorithm for details
	reg signed [2*numBits:0]S; // Refer algorithm for details
	reg signed [2*numBits:0]P; // Refer algorithm for details
	reg signed [numBits - 1:0]mComp; // -m

	integer i;

	always@(m,r)
	begin
		A = {m,{numBits{1'b0}},1'b0};
		mComp = ~m + 1'b1; // 2's complement of m -> -m

		S = {mComp,{numBits{1'b0}},1'b0};
		P = {{numBits{1'b0}},r, 1'b0};

		for (i = 0; i < numBits; i = i + 1)
		begin
			case (P[1:0])
			
				2'b00 : begin P = P >>> 1;end 
				2'b01 : begin P = P + A; P = P >>> 1; end // Condition where a block of ones starts
				2'b10 : begin P = P + S; P = P >>> 1; end // Condition where a block of ends starts
				2'b11 : begin P = P >>> 1;end 
			endcase
		end

		p = P[2 * numBits:1]; // Final Product
	end

endmodule