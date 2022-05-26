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

module rec2pol( input clock,
				input reset,
				input enable,              // set and keep high to enable iteration
				input start,               // set to 1 for one clock to start 
				input  signed [31:0] x,    // X component, 16Q16
				input  signed [31:0] y,    // Y component, 16Q16
				output signed [31:0] mod,  // Modulus, 16Q16
				output signed [31:0] angle // Angle in degrees, 8Q24
			  );



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

/* xr */
always @(posedge clock)
begin	
	if(reset)
		xr <= 0;
	else 	if(enable)

				if (start) xr <= x;
				else if (yr[33])	//yr[33] - sign bit
						xr <= xr - (yr >>> count_out);
					else
						xr <= xr + (yr >>> count_out);

			// xr <= start ? x : (yr[33] ? xr - (yr >>> count_out) : xr + (yr >>> count_out));
end

/* yr */
always @(posedge clock)
begin
	if(reset)
		yr <= 0;
	else	if(enable)

				if (start) yr <= y;
				else if (yr[33])
						yr <= yr + (xr >>> count_out);
					else
						yr <= yr - (xr >>> count_out);

			// yr <= start ? y : (yr[33] ? yr + (xr >>> count_out) : yr - (xr >>> count_out));
end

/* zr */
always @(posedge clock)
begin
	if(reset)
		zr <= 0;
	else	if(enable)

				if (start) 
                    begin 
                        zr <= 32'b0; //=32bits0
                        $display("zr@start = %d",zr);
                    end
				else if (yr[33])
						zr <= zr - (ATAN_data);
					else
						zr <= zr + (ATAN_data);
			// zr <= start ? 32'b0 : (yr[33] ? zr - (ATAN_data) : zr + (ATAN_data));
				
end

assign angle = zr; 

endmodule //rec2pol

/*************************************/

module rec2pol23(	input clock,
					input reset,
					input enable,              // set and keep high to enable iteration
					input start,               // set to 1 for one clock to start 
					input  signed [31:0] x_in,    // X component, 16Q16
					input  signed [31:0] y_in,    // Y component, 16Q16
					output signed [31:0] mod_res,  // Modulus, 16Q16
					output signed [31:0] angle_res // Angle in degrees, 8Q24

);


real fracfactorangle = 1<<24;
reg signed [31:0] x_orig;
wire signed [31:0] angle_temp_1;
reg signed [31:0] angle_temp_2;


rec2pol rec2pol_orig(
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .start(start),
        .x(x_orig),
        .y(y_in),
        .mod(mod_res),
        .angle(angle_temp_1)
);

// 	x/x_orig sempre positivo
always @(posedge start)
begin
	if(x_in < 0)
		begin
			//x_orig = {-1*x_in[31:15], x_in[14:00]};
			x_orig = -x_in ;
		end
	else
		begin
			x_orig = x_in;
		end
end


//	+- 90graus caso x/x_orig seja negativo
always @(*)
begin

    //$display("%d",CLOCK);

	if (x_in < 0 && y_in > 0)	//2Q
		begin
			$display("2Q %d",angle_temp_1/fracfactorangle);	
			angle_temp_2 = angle_temp_1 + (fracfactorangle * 90);
		end
	else	if(x_in < 0 && y_in < 0) //3Q
			begin
				$display("3Q %d",angle_temp_1/fracfactorangle);	
				angle_temp_2 = angle_temp_1 - (fracfactorangle * 90);
			end
	else angle_temp_2 = angle_temp_1; //1Q + 4Q
end

assign angle_res = angle_temp_2;

endmodule //rec2pol23