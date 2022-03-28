 module dds (clock,
			reset,
			enableclk,
			phaseinc,
			outsine
			);
parameter Nsamples_LUT=64;
parameter Nbits_Samples_LUT = 6;
parameter Nfrac = 12;

input clock, reset, enableclk;
input [31:0] phaseinc;
output reg [7:0] outsine;

reg [31:0] sineLUT[ 0 : Nsamples_LUT-1 ];
reg [Nfrac + Nbits_Samples_LUT -1:0] address_buffer;
wire [Nbits_Samples_LUT + Nfrac - 1:0] address;
wire [Nbits_Samples_LUT -1 :0] address_LUT;

assign address = address_buffer + phaseinc;
assign address_LUT = address_buffer >>> Nfrac;

always @ (posedge clock)
begin
	if (reset)
	begin
		outsine <= 32'd0;
		address_buffer <= 'd0;
	end

	if (enableclk)
	begin
		outsine <= sineLUT[address_LUT][7:0];
		address_buffer <= address;
	end	
end

initial 
begin
	$readmemh("../simdata/DDSLUT.hex", sineLUT);
end
	
endmodule