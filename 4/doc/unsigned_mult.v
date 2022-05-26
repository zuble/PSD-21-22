module unsigned_mult (out, a, b);
output [64:0] out;
	input  [31:0] a;
	input  [64:31] b;
	
	assign out = a * b;

endmodule