module lowpass(
	input clock, // Master clock
	input reset, // master reset, synchronous, active high
	input [17:0] datain, // input data
	input endata, // data clock enable
	output [17:0] dataout, // output data
	// Interface to the coefficient memory:
	output [6:0] coefaddress, // 7-bit address
	input [17:0]  coefdata // 18-bit data
	);

reg[6:0] counter;
reg[17:0] input_memory[0:64];
integer i;

initial begin
	for(i=0;i<65;i=i+1)
		input_memory[i]<=0;
end

reg [1:0] state;
reg[17:0] temp;
reg signed [42:0] acc;

localparam S0=2'd0, S1=2'd1, DUMMY_STATE=2'd3;
localparam [6:0] input_memory_size=65;

always@(posedge clock)
begin
  if(reset)begin
    acc<=0;
    temp<=0;
    counter<=0;
    state<=S0;
    end
  else begin
  case(state)
	S0: begin
       if(endata)begin
         acc<=0;
         for(i=0;i<input_memory_size-1;i=i+1)begin
           input_memory[i]<=input_memory[i+1];
         end
         input_memory[64]<=datain;
			state<=DUMMY_STATE;
		 end
		 end
	DUMMY_STATE: begin
						state<=S1;
					 end
   S1: begin
       if(counter<input_memory_size-1)begin
			acc<=($signed(input_memory[input_memory_size-counter-1])*$signed(coefdata))+acc;
			counter<=counter+1;
			state<=DUMMY_STATE;
       end
       else begin
			temp<=acc[29:12];
			counter<=0;
			state<=S0;
		 end
		 end
  endcase
  end
end

assign coefaddress=counter;

assign dataout=temp;

endmodule
