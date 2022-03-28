module stereo_fm_mx(
			//-----------------------------------------------
			// Global signals
            clock,     // master clock, active in posedge
            reset,     // master reset, synchronous, active high
				
			//-----------------------------------------------
			// Gains:
			Ks,
			Kd,
			Kp,
			Kf,
			//-----------------------------------------------
			//-----------------------------------------------
			// Audio data in:
            LEFTin,            // data in, left channel
            RIGHTin,          // data in, right channel

			clken48kHz,    // Clock enable for input sampling rate:
			clken192kHz,  // Clock enable for 4X sampling rate:
				
			//-----------------------------------------------
			// FM Stereo dataout:
			FMout               // data out, FM stereo signal
            );

input clock, reset;

input[3:0] Ks, Kd, Kp; 
input[7:0] Kf;

input signed [17:0] LEFTin, RIGHTin;

input clken48kHz, clken192kHz;

output reg signed [23:0] FMout;

wire signed [17:0] lmr_out, lpr_out;

wire signed [17:0] lmr_192, lpr_192;


wire signed [23:0] FMout_temp;

stereo_encoder_48 encoder_48(	
			.clock(clock),
			.reset(reset),
			.enableclk48(clken48kHz),
			.left(LEFTin),
			.right(RIGHTin),
			.Ks(Ks),
			.Kd(Kd),
			.LmR_out(lmr_out),
			.LpR_out(lpr_out)
		);
							
interpol4x interpol_lpr( 
            .clock( clock ), 
            .reset( reset ),
		    .clkenin( clken48kHz ),
            .clken4x( clken192kHz ),
		    .xkin( lpr_out ),
		    .ykout( lpr_192 )
		 );
		 
interpol4x interpol_lmr( 
            .clock( clock ), 
            .reset( reset ),
		    .clkenin( clken48kHz ),
            .clken4x( clken192kHz ),
		    .xkin( lmr_out ),
		    .ykout( lmr_192 )
		 );
							
 stereo_encoder_192 encoder_192(	
			.clock(clock),
			.reset(reset),
			.enableclk192(clken192kHz),
			.lpr(lpr_192),
			.lmr(lmr_192),
			.Kp(Kp),
			.Kf(Kf),
			.stereo_Kf_out(FMout_temp)
		);
		
always @(posedge clock)
begin
	if (clken192kHz)
		begin
			FMout <= FMout_temp;
		end
end
endmodule