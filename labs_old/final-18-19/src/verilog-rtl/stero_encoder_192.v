 module stereo_encoder_192 (clock,
							reset,
							enableclk192,
							lpr,
							lmr,
							Kp,
							Kf,
							stereo_Kf_out
							);
							
	input clock, reset, enableclk192;
	input signed [17:0] lpr;
	input signed [17:0] lmr;
	input[3:0] Kp;
	input[7:0] Kf;
	output reg signed [23:0] stereo_Kf_out;
	
	reg signed [19:0] stereo;
	wire signed [7:0] outsine_19;
	wire signed [7:0] outsine_38;
	
	reg [31:0] phaseinc_19 = 'b000110_010101010101;
	reg [31:0] phaseinc_38 = 'b001100_101010101010;
	
	wire signed [28:0] stereo_Kf;
	
	wire signed [12:0] tone_19;
	wire signed [25:0] lmr_38;
	
	reg signed [17:0] lpr_buff;
	
	reg signed [17:0] tone_19_buff;
	reg signed [17:0] lmr_38_buff;
	
	reg start_kf_multiply = 0;
	

	wire ready_multiply_19, ready_multiply_38, ready_kf_multiply;
	
	reg ready_multiply_19_pulse, ready_multiply_38_pulse, ready_kf_multiply_pulse;

		
	seqmultNM #(
				.N(8),
				.M(18)
				)
	seqmult_1 
				(
				.clock(clock),
				.reset(reset),
				.start(enableclk192),
				.ready(ready_multiply_38),
				
				.A(lmr),
				.B(outsine_38),
				.R(lmr_38)
				
				);
				
	seqmultNM #(
				.N(5),
				.M(8)
				)
	seqmult_2 
				(
				.clock(clock),
				.reset(reset),
				.start(enableclk192),
				.ready(ready_multiply_19),
				
				.A(outsine_19),
				.B({1'b0,Kp}),
				.R(tone_19	)
				
				);
				
	seqmultNM #(
				.N(9),
				.M(20)
				)
	seqmult_3 
				(
				.clock(clock),
				.reset(reset),
				.start(start_kf_multiply),
				.ready(ready_kf_multiply),
				
				.A(stereo),
				.B({1'b0,Kf}),
				.R(stereo_Kf)
				
				);
				
	dds #(
		.Nsamples_LUT(64),
		.Nbits_Samples_LUT(6),
		.Nfrac(12))
		
	dds_19( 
		.clock( clock ),
		.reset( reset ),
		.enableclk( enableclk192 ),
		.phaseinc( phaseinc_19 ),
		.outsine( outsine_19 )
    );
	
	dds #(
		.Nsamples_LUT(64),
		.Nbits_Samples_LUT(6),
		.Nfrac(12))
		
	dds_38( 
		.clock( clock ),
		.reset( reset ),
		.enableclk( enableclk192 ),
		.phaseinc( phaseinc_38 ),
		.outsine( outsine_38 )
    );
				
	
	// possible area saver, sequential adder
	always @(posedge clock)
	begin
		
		if(ready_multiply_38)
			begin
				lmr_38_buff <= lmr_38 >> 8;
				start_kf_multiply <= 1'b1;
			end
		
		if(ready_multiply_19)
			begin
				tone_19_buff <= tone_19 << 6;
			end
			

		if(start_kf_multiply)
				start_kf_multiply <= 1'b0;
			
		if(ready_kf_multiply)
			begin
				stereo_Kf_out <= stereo_Kf >>> 4;
			end

			
		if (reset)
			begin
				start_kf_multiply <= 1'b0;
				stereo_Kf_out <= 0;
				stereo <= 0;
				tone_19_buff <= 0;
				lmr_38_buff <= 0;
//				ready_multiply_19_pulse <= 0;
//				ready_multiply_38_pulse <= 0;
//				ready_kf_multiply_pulse <= 0;
				lpr_buff <=0;
				
			end
		
		stereo <= $signed(lpr_buff) + $signed(tone_19_buff) + $signed(lmr_38_buff);
		
		if (enableclk192)
			begin
				lpr_buff <= lpr;
			end
			
	end
	
	
	
endmodule