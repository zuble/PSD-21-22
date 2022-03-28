module psdi_dsp(
         input  clock,
			input  reset,

			input [7:0] switches,
			input data_en,

         output [6:0] RAM_coefs_addr_right,
		   input  [17:0] RAM_coefs_dataout_right,
			output [6:0] RAM_coefs_addr_left,
		   input  [17:0] RAM_coefs_dataout_left,
			
			input [17:0] right_in,
			input [17:0] left_in,

			output signed [17:0] right_out,
			output signed [17:0] left_out
			);

wire[17:0] r_lp_dw;
wire[17:0] l_lp_dw;
wire[17:0] r_dw_re;
wire[17:0] l_dw_re;
wire[17:0] r_re_int;
wire[17:0] l_re_int;			

lowpass lowpass_right(
           .clock( clock ),
           .reset( reset ),
           .datain( right_in ),
           .endata( data_en ),
           .dataout( right_out ), //ALTERAR NO CASO DE SE CONSEGUIR LIGAR AO DOWNSAMPLE
           .coefaddress( RAM_coefs_addr_right ),
           .coefdata( RAM_coefs_dataout_right )
           );

           lowpass lowpass_left(
             .clock( clock ),
             .reset( reset ),
             .datain( left_in ),
             .endata( data_en ),
             .dataout( left_out ), //ALTERAR NO CASO DE SE CONSEGUIR LIGAR AO DOWNSAMPLE
             .coefaddress( RAM_coefs_addr_left ),
             .coefdata( RAM_coefs_dataout_left )
             );

parameter [3:0] N = 4; //(18/12-17:32) CRIEI EU O MEU N AQUI NO PSDI, IGUALANDO AO QUE ESTA NO PSDDSP 

			  downsample downsample_right(
				.clock( clock ), 
				.reset( reset ), 
				.Nfreq ( N ),
				.datain ( right_in ), //ALTERAR NO CASO DE SE CONSEGUIR LIGAR AO LOWPASS
				.endatain ( data_en ), 
				.dataout ( r_dw_re ), 
				.endataout ( r_downsample_freq ) 
				);

			  downsample downsample_left(
				.clock( clock ), 
				.reset( reset ), 
				.Nfreq ( N ),
				.datain ( left_in ), //ALTERAR NO CASO DE SE CONSEGUIR LIGAR AO LOWPASS
				.endatain ( data_en ), 
				.dataout ( l_dw_re ), 
				.endataout ( l_downsample_freq ) 
				); 

parameter [4:0] Nquantizacao = 10;


			requantize rqz_right(
			.clock( clock ), // Master clock
			.reset(reset), // master reset, synchronous, active high
			.Nquant(Nquantizacao), // No. of output quantization bits
			.datain(r_dw_re), // input data
			.endatain(data_en), // input data clock enable
			.dataout(right_out) // output data
);

			requantize rqz_left(
				.clock( clock ), 
				.reset(reset), 
				.Nquant(Nquantizacao), 
				.datain(l_dw_re), 
				.endatain(data_en), 
				.dataout(left_out) 
); 

//-------------------------------------------------------------------------------
// Audio samples are available in the positive clock edge when data_en is 1
//
// A synchronous process to handle the audio stream should be as:
// always @(posedge clock)
// if ( reset )
//   // do the reset actions
// else
//   if ( data_en )
//   begin
//     // do something with right_in and left_in
//     // and generate right_out and left_out
//   end
//-------------------------------------------------------------------------------


// Set the RAM read address bus to zero:
//assign RAM_coefs_addr = 7'd0;

//-------------------------------------------------------------------------------
// Implement some basic functions using  the audio stream

wire signed [17:0] LEFT_inf, RIGHT_inf;


// Set sw0=1 / sw1=1 to mute left/right inputs:
// set sw2=1 / sw3=1 to swap left and right channels
assign LEFT_inf   = ( switches[0] ) ? 18'd0 : ( switches[2] ? right_in : left_in  );
assign RIGHT_inf  = ( switches[1] ) ? 18'd0 : ( switches[3] ? left_in  : right_in );


// Example of basic signal processing operation:
// calculate the sum signal to the : out = (left + right) / 2

reg [17:0] Lr0, Rr0;
reg [17:0] LRsum, LRdif;

always @(posedge clock)
if ( reset )
  begin
    Lr0 <= 18'd0;
    Rr0 <= 18'd0;
    LRdif <= 18'd0;
    LRsum <= 18'd0;
 end
else
  if ( data_en )  // 48 KkHz
  begin
    Lr0 <= LEFT_inf;   // register the inputs
    Rr0 <= RIGHT_inf;

	// calculate the sum and difference of left and right channels,
	// sign-extend the operands to 19 bits
    LRsum <= ( $signed( {Lr0[17], Lr0} ) + $signed( {Rr0[17], Rr0} ) ) >>> 1;
    LRdif <= ( $signed( {Lr0[17], Lr0} ) - $signed( {Rr0[17], Rr0} ) ) >>> 1;
  end

// Select output signal with the position of the slide switches:
//assign left_out   = (switches[4]) ? LEFT_inf  : ( switches[5] ? LRsum : LRdif );
//assign right_out  = (switches[4]) ? RIGHT_inf : ( switches[6] ? LRdif : LRsum );

endmodule
