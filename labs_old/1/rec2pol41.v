

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

`include "ATAN_ROM.v"
`include "ITERCOUNTER.V"
`include "MODSCALE.v"

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
	else	if(enable)
			xr <= start ? x : (yr[33] ? xr - (yr >>> count_out) : xr + (yr >>> count_out));
end


always @(posedge clock)
begin
	if(reset)
		yr <= 0;
	else	if(enable)	
			yr <= start ? y : (yr[33] ? yr + (xr >>> count_out) : yr - (xr >>> count_out));
end

always @(posedge clock)
begin
	if(reset)
		zr <= 0;
	else	if(enable)
			zr <= start ? 32'b0 : (yr[33] ? zr - (ATAN_data) : zr + (ATAN_data));
end

assign angle = zr; 

endmodule
// end of module rec2pol


module rec2pol41(
		input clock,
				input reset,
				input enable,              // set and keep high to enable iteration
				input start,               // set to 1 for one clock to start 
				input  signed [31:0] x_in,    // X component, 16Q16
				input  signed [31:0] y_in,    // Y component, 16Q16
				output signed [31:0] mod_res,  // Modulus, 16Q16
				output signed [31:0] angle_res // Angle in degrees, 8Q24

);

real fracfactorangle = 1<<24;
reg signed [31:0] x_temp;
wire signed [31:0] angle_temp_1;
reg signed [31:0] angle_temp_2;

rec2pol rec2pol_orig(
		.clock(clock),
		.enable(enable),
		.reset(reset),
		.start(start),
		.x(x_temp),
		.y(y_in),
		.mod(mod_res),
		.angle(angle_temp_1)
);

//conversao para positivo e envio numero para rec2pol
always @(posedge start)
begin
	if(x_in < 0)
		begin
			x_temp = {-1*x_in[31:15], x_in[14:00]};
		end
	else
		begin
			x_temp = x_in;
		end
end

//+- 90graus caso x seja negativo
always @(*)
begin
	if (x_in < 0 && y_in > 0)	//2Q
		begin
			angle_temp_2 = angle_temp_1 + (fracfactorangle * 90);
		end
	else	if(x_in < 0 && y_in < 0) //3Q
			begin
				angle_temp_2 = angle_temp_1 - (fracfactorangle * 90);
			end
	else angle_temp_2 = angle_temp_1; //1Q + 4Q
end

assign angle_res = angle_temp_2;
endmodule