module downsample(
    input clock, // Master clock
    input reset, // master reset, synchronous, active high
    input [3:0] Nfreq, // sampling rate divide factor
    input [17:0] datain, // input data
	input endatain, // in clock enable, Fs=48kHz
	output [17:0] dataout, // output data
	output endataout // out clock enable, Fs = 48kHz/Nfreq
);

reg signed[17:0] temp_reg;
reg [4:0] counter;
reg state;
reg new_freq;

localparam INIT=1'b0, S1=1'b1;

always@(posedge clock)begin
if(reset)begin
	temp_reg<=0;
	state<=INIT;
	counter<=0;
	new_freq<=0;
end
else begin
case(state)
INIT: begin
		if(endatain)begin
			temp_reg<=datain;
			new_freq<=1;
			state<=S1;
			end
		end
S1: begin
	 if(endatain)begin
		if(counter==Nfreq-1)begin
		temp_reg<=datain;
		new_freq<=1;
		counter<=0;
		end
	 else begin
		new_freq<=0;
		counter<=counter+1;
		end
	 end
	 else begin
		new_freq<=0;
	 end
	 end
endcase
end
end

assign dataout = temp_reg;

assign endataout = new_freq;

endmodule
