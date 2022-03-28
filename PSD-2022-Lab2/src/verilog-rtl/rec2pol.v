/*
    Integrated Master in Electrical and Computer Engineering - FEUP
	
	EEC0055 - Digital Systems Design 2019/2020
	
	----------------------------------------------------------------------
	module rec2pol - Converts rectangular coords to polar coords using the CORDIC algorithm
	
	Summary
	This module implements the CORDIC algorithm in vectoing mode to 
	convert the rectangular coordinates of a vector to polar coordinates.
	
	The inputs X and Y are 32 bit integers representing the X and Y coordinates
	with 16 integer bits and 16 fractional bits (16Q16 format)
	
	The outputs are the modulus represented in the same format and the 
	angle represented in degrees with 8 integer bits and 24 fractional bits
	
	Input range:
	The input X must be positive and less than 32767;
    The Y input can be positive or negative in the interval [-32768, 32767];
	The output modulus cannot exceed the 16-bit maximum positive in two's complement (32767)
	  
	----------------------------------------------------------------------	
	Date created: 4 Oct 2019
	Author: jca@fe.up.pt
	
	----------------------------------------------------------------------	
	This Verilog code is property of the University of Porto, Portugal
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
*/


module rec2pol( 
                input clock,
				input reset,
				input enable,              // set and keep high to enable iteration
				input start,               // set to 1 for one clock to start 
				input  signed [31:0] x,    // X component, 16Q16
				input  signed [31:0] y,    // Y component, 16Q16
				output signed [31:0] mod,  // Modulus, 16Q16
				output signed [31:0] angle // Angle in degrees, 8Q24
			  );
			  
			   
// ADD YOUR CODE HERE	

wire signed [5:0]	count_out;
reg signed [33:0]	yr;
reg signed [33:0]	xr;
wire signed [31:0]	ATAN_data;
reg signed [31:0]	zr;


ITERCOUNTER ITERCOUNTER_1(
			.clock(clock),
			.reset(reset),
			.start(start),
			.enable(enable),
			.count(count_out)
);

MODSCALE MODSCALE_1(
			.XF(xr),
			.MODUL(mod)

);

ATAN_ROM ATAN_ROM_1(
			.addr(count_out),
			.data(ATAN_data)
);


always @(posedge clock)
begin	
	if(reset)
		xr <= 0;
	else 	if(enable)
				if (start)
					xr <= x;
				else
					if (yr[33])
						xr <= xr - (yr >>> count_out);
					else
						xr <= xr + (yr >>> count_out);


			/**xr <= start ? x : (yr[33] ? xr - (yr >>> count_out) : xr + (yr >>> count_out));**/
end


always @(posedge clock)
begin
	if(reset)
		yr <= 0;
	else	if(enable)
				if (start)
					yr <= y;
				else
					if (yr[33])
						yr <= yr + (xr >>> count_out);
					else
						yr <= yr - (xr >>> count_out);

			/**yr <= start ? y : (yr[33] ? yr + (xr >>> count_out) : yr - (xr >>> count_out));**/
end

always @(posedge clock)
begin
	if(reset)
		zr <= 0;
	else	if(enable)
				if (start)
					zr <= 32'b0;
				else
					if (yr[33])
						zr <= zr - (ATAN_data);
					else
						zr <= zr + (ATAN_data);
			/**zr <= start ? 32'b0 : (yr[33] ? zr - (ATAN_data) : zr + (ATAN_data));**/
end

assign angle = zr; 

endmodule
// end of module rec2pol