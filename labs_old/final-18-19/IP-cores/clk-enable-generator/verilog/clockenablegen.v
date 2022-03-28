`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
Clock enable generator for the FM Stereo modulator
 
jca@fe.up.pt, Dec 2018

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
*/

module clockenablegen(
           input clock,
			  input reset,
			  output clken48kHz,
			  output clken192kHz
			  );
			  
parameter PULSEPOS_192K =    9'b1_0010_0000;			  
parameter PULSEPOS_48K  = 11'b000_0010_0000;	
/*-------------------------------------------------------------------------
 The two parameters define the relative position of the clock enable pulses
 Using these parameters the clk enable pulses are:
 first clken48kHz appears 32 clock cycles after releasing the reset
 first clken192kHz appears 256 clock cycles the first clken48k pulse
             ___
 reset:  ___|   |________________________________________________________
                 <-  32  ->
                         _                                      _
 en48k:  _______________| |____________________________________| |_______
                         <- 256 ->      <-  512   ->
                                _        _        _        _         _
 en192k: ______________________| |______| |______| |______| |_______| |__
 
--------------------------------------------------------------------------*/		  

reg [10:0] clkdivcount;

always @(posedge clock)
if ( reset )
  clkdivcount <= 10'd0; 
else
  clkdivcount <= clkdivcount + 11'd1;

assign #2 clken192kHz = ( clkdivcount[ 8:0] == PULSEPOS_192K );
assign #2 clken48kHz  = ( clkdivcount[10:0] == PULSEPOS_48K );

endmodule