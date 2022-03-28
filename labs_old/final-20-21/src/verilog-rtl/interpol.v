/*

   Author: jca@fe.up.pt

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
	Linear interpolator
	
	Uses a VERY LARGE combinational divider. This design can be improved
	signficantly by using a smaller sequential divider.
	
	This module synthesizes to 
	 743 LUTs, 41 Flops, max clock 12.66 MHz (opt area, effort high)
	1193 LUTs, 61 Flops, max clock 16.54 MHz (opt speed, effort high)
 
 */
 
`timescale 1ns/1ps


module interpol 
          ( 
            input clock,    // master clock
            input reset,    // master reset, assynchronous, active high
				input endatain, // enable input data, low sampling frequency
				input endataout,// output data enable, this should be the 48 kHz clock enable
				input         [ 3:0]  Nfreq, // the interpolationm factor, this is the same as the downsample factor
				input signed  [17:0] datain, // input data
				output signed [17:0] dataout // output data
          );

reg signed [17:0] dataout_r;

// Differentiation :
wire signed [18:0] diffsample;

// The previous input sample:
reg signed [17:0] datain_old;

// Differentiator:
always @(posedge clock)
if ( reset )
begin
  datain_old <= 0;
end
else
begin
  if ( endatain )
  begin
	datain_old <= datain;
  end
end

assign diffsample = datain - datain_old;

// accumulator register
// max accum is 10X, needs more 4 bits than differentiator reg:
reg signed [22:0] accumout;

// Integrator:
always @(posedge clock)
if ( reset )
  accumout <= 19'd0;
else
begin
  if ( endataout )
  begin
    accumout <= accumout + diffsample;
  end
end

// Scale down to 18 bits, divide by the interpolation factor
// We should use here a sequential divider, NOT this HUGE combinational divider !
always @(posedge clock)
if ( reset )
  dataout_r <= 18'd0;
else
begin
  if ( endataout )
  begin
    dataout_r <= accumout / $signed(Nfreq);
  end
end

// assign to output port:
assign dataout = dataout_r;

endmodule

