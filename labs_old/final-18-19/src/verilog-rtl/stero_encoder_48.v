 module stereo_encoder_48 (	clock,
							reset,
							enableclk48,
							left,
							right,
							Ks,
							Kd,
							LmR_out,
							LpR_out
							);
							
	input clock, reset, enableclk48;
	input signed [17:0] left;
	input signed [17:0] right;
	input[3:0] Ks;
	input[3:0] Kd;
	output reg signed [17:0] LpR_out;
	output reg signed [17:0] LmR_out;
	
	wire signed [18:0] LpR;
	wire signed [18:0] LmR;
	wire signed [23:0] LpR_Ks_temp;
	wire signed [23:0] LmR_Kd_temp;
	
	wire ready1, ready2;
	
	seqmultNM #(
				.N(5),
				.M(19)
				)
				seqmult_1 
				(
				.clock(clock),
				.reset(reset),
				.start(enableclk48),
				.ready(ready1),
				
				.A(LpR),
				.B({1'b0,Ks}),
				.R(LpR_Ks_temp)
				
				);
				
	seqmultNM #(
				.N(5),
				.M(19)
				)
				seqmult_2 
				(
				.clock(clock),
				.reset(reset),
				.start(enableclk48),
				.ready(ready2),
				
				.A(LmR),
				.B({1'b0,Kd}),
				.R(LmR_Kd_temp)
				
				);
				
				
	
	always @(posedge clock)
	begin
		if(ready1)
		begin
			LpR_out <= LpR_Ks_temp[21:4];
		end
		if(ready2)
		begin
			LmR_out <= LmR_Kd_temp[21:4];
		end
	end
	
	assign LmR = (left - right);
	
	assign LpR = (left + right);
	
endmodule