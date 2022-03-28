/*-----------------------------------------------------------

 	jca@fe.up.pt, Nov 2018
	
	This Verilog code is proprietary of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.

	
    interpol4x - 4X linear interpolator

    Output ykout is the linear interpolated signal applied at input xkin, with a 
	sampling frequency equal to 4X the frequency of the input data.

    clkenin is a clock enable signal (set to 1 during a single clock period) that 
	synchronizes the arrival of the input data at xkin.

    clken4x is a clock enable signal that must have a frequency 4 times higher than
    clkenin
  	
	Input xkin is valid with clock enable clkenin and output ykout is valid with clken4x
	
-----------------------------------------------------------*/

`timescale 1ns/1ps

// Select the initial model or the new model
// `define INTERPOL_MODEL_1  // Uncomment to use the previous interpolator model
`define INTERPOL_MODEL_2  // Uncomment to use the new interpolator model
//`define OUTPUT_DELAYED    // USE ONLY with INTERPOL_MODEL_2

module interpol4x
         ( input         clock,        // Master clock
           input         reset,        // Master synchronous reset, active high
	       input         clkenin,      // clock enable for input data (Fs)
	       input         clken4x,      // 4 x input Fs clock enable
		   
           input  signed [17:0] xkin,      // input signal

           `ifdef INTERPOL_MODEL_1
	       output reg signed [17:0] ykout      // output signal
           `endif

           `ifdef INTERPOL_MODEL_2
	       output signed [17:0] ykout      // output signal
           `endif
	     );



//------------- The first model of the interpolator	 
`ifdef INTERPOL_MODEL_1	 

// Input register
reg signed [17:0] xkr;
always @(posedge clock)
if ( reset )
begin
  xkr <= 18'd0;
end
else
begin
  if ( clkenin )
    xkr <= xkin;
end


// Upsample x 4
reg signed [17:0] xkus;
always @(posedge clock)
if ( reset )
begin
  xkus <= 18'd0;
end
else
begin
  if ( clken4x )
  begin
    if ( clkenin )
      xkus <= xkr;
	else
	  xkus <= 18'd0;
  end
end

// Fir registers, 21 bits:
reg signed [20:0] r0, r1, r2, r3, r4, r5, r6;


always @(posedge clock)
if ( reset )
begin
  r0 <= 21'd0;
  r1 <= 21'd0;
  r2 <= 21'd0;
  r3 <= 21'd0;
  r4 <= 21'd0;
  r5 <= 21'd0;
  r6 <= 21'd0;
  ykout <= 17'd0;
end
else
begin
  if ( clken4x )
  begin
    r0 <= xkus;
    r1 <= r0 + xkus * 2 ;
    r2 <= r1 + xkus * 3 ;
    r3 <= r2 + xkus * 4 ;
    r4 <= r3 + xkus * 3 ;
    r5 <= r4 + xkus * 2 ;
    r6 <= r5 + xkus;
    ykout <= r6 >>> 2; // signed divide by 4
  end
end
`endif  // ifdef INTERPOL_MODEL_1



//------------- The second model of the interpolator	
`ifdef INTERPOL_MODEL_2
	 
wire signed [18:0] diff;

reg signed [17:0] r1 = 0 , r2 = 0;

reg signed [20:0] accum = 0;

always @(posedge clock)
  if ( clkenin )
  begin
    r1 <= xkin;
	r2 <= r1;
  end

		 
assign 	diff = r1 - r2; 
		 
always @(posedge clock)
if ( reset )
  accum <= 0;
else
  if ( clken4x )
  begin
    accum <= accum + diff;
  end
  

`ifdef OUTPUT_DELAYED
reg [17:0] R5, R4, R3, R2, R1;
always @(posedge clock)
if ( reset )
begin
  R5 <= 0;
  R4 <= 0;
  R3 <= 0;
  R2 <= 0;
  R1 <= 0;
end
else
if ( clken4x )
begin
  R5 <= accum[19:2];
  R4 <= R5;
  R3 <= R4;
  R2 <= R3;
  R1 <= R2;
end
assign ykout = R1;

`else

 assign ykout = accum[19:2];

`endif  // ifdef OUTPUT_DELAYED

`endif  // ifdef INTERPOL_MODEL_2
		 

endmodule
