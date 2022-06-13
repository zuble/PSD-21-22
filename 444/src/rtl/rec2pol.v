/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
	Implements the conversion from rectangular coords to polar coords 
	using the CORDIC algorithm from previous works

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
			  
			   
reg signed [33:0]	yr,
					xr;
reg signed [31:0]	zr;

wire signed [31:0]	ATAN_data;
wire signed [5:0]	count_out;


// ITERCOUNTER module initiation
ITERCOUNTER ITERCOUNTER_1(
			.clock(clock),
			.reset(reset),
			.start(start),
			.enable(enable),
			.count(count_out)
);

// MODSCALE module initiation
MODSCALE MODSCALE_1(
			.XF(xr),	
			.MODUL(mod)

);

// ATAN_ROM module initiation
ATAN_ROM ATAN_ROM_1(
			.addr(count_out),
			.data(ATAN_data)
);


//yr[33] - sign bit
always @(posedge clock)
begin
		
	if(reset)
		xr <= 0;
	else if(enable)

		if (start) xr <= x;
		else if (yr[33])
				xr <= xr - (yr >>> count_out);
		else
			xr <= xr + (yr >>> count_out);

		// xr <= start ? x : (yr[33] ? xr - (yr >>> count_out) : xr + (yr >>> count_out));
end


always @(posedge clock)

	if(reset) begin
		yr <= 0;
	end

	else if(enable) begin

		if (start) yr <= y;
		else if (yr[33])
				yr <= yr + (xr >>> count_out);
		else
			yr <= yr - (xr >>> count_out);
	end
	// yr <= start ? y : (yr[33] ? yr + (xr >>> count_out) : yr - (xr >>> count_out));


always @(posedge clock)
begin
	if(reset)
		zr <= 0;
	else if(enable)
				
		if (start) zr <= 32'b0;
		else if (yr[33])
			zr <= zr - (ATAN_data);
		else
			zr <= zr + (ATAN_data);
	// zr <= start ? 32'b0 : (yr[33] ? zr - (ATAN_data) : zr + (ATAN_data));
end

assign angle = zr; 

endmodule
// end of module rec2pol