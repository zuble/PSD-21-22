
	module requantize(
		input clock, // Master clock
		input reset, // master reset, synchronous, active high
		input [4:0] Nquant, // No. of output quantization bits
		input [17:0] datain, // input data
		input endatain, // input data clock enable
		output [17:0] dataout // output data
 );


reg signed [17:0] int_reg, temp_reg;
reg[17:0] frac_reg;
reg[3:0] state;
reg[4:0] counter;
reg[1:0] skip_flag;
localparam WAIT=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
integer i;

reg[17:0] data;

always@(posedge clock)begin
         
  if(reset)begin
    temp_reg<=0;
	 data<=0;
    int_reg<=0;
    frac_reg<=0;
	 counter<=0;
	 state<=S1;
	 end
  else begin
  
case(state)
	
	 WAIT:begin
			if(endatain)
				temp_reg<=datain;
				if(data == temp_reg)
					state<=WAIT;
				else begin
					data<=temp_reg;
					state<=S1;
				end
			end
  	 S1:	begin
			for(i=0;i<=17-Nquant;i=i+1)begin
				frac_reg[i]<=temp_reg[i];
			end
			int_reg<=temp_reg >> 18-Nquant;
			state<=S2;
			end
			
	 S2:	begin
			if(frac_reg[17-Nquant]==0)begin
				state<=S3;
			end
			else begin
				for(i=0;i<17-Nquant;i=i+1)begin
					if(frac_reg[i]==1)begin
					skip_flag<=1;
					state<=S4;
					end
				end
			if(skip_flag == 0)begin
				if(int_reg[0]==0)
					state<=S3;
				else
					state<=S4;
			end
			end
			end
			
	 S3:	begin //rounding down
				frac_reg[17:0]<=0;
				state<=S5;
			end
			
	 S4:	begin //rounding up
				frac_reg[17:0]<=0;
				int_reg<=int_reg+1;
				skip_flag<=0;
				state<=S5;
			end
			
	 S5:	begin
				temp_reg<=int_reg << 18-Nquant;
				state<=S1;
			end
	endcase
	end
end

assign dataout=temp_reg;





//COMENTEI ESTE ETENTEI FAZERUMAS ALTERAÃ‡OES
/*
module requantize(
 input clock, // Master clock
 input reset, // master reset, synchronous, active high
 input [4:0] Nquant, // No. of output quantization bits
 input [17:0] datain, // input data
 input endatain, // input data clock enable
 output [17:0] dataout // output data
 );


reg signed [17:0] int_reg, temp_reg;
reg[17:0] frac_reg;
reg[2:0] state;
reg[4:0] counter;
reg[1:0] skip_flag;
localparam WAIT=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
integer i;


always@(posedge clock)begin
    	 
  if(reset)begin
    temp_reg<=0;
    int_reg<=0;
    frac_reg<=0;
	 counter<=0;
	 state<=S1;
	 end
  else begin
  
case(state)

  	 S1:	begin
			if(endatain)begin
				for(i=0;i<=17-Nquant;i=i+1)begin
				frac_reg[i]<=datain[i];
				end
				int_reg<=datain >> 18-Nquant;
				state<=S2;
				end
			end
			
	 S2:	begin
			if(frac_reg[17-Nquant]==0)begin
				state<=S3;
			end
			else begin
				for(i=0;i<17-Nquant;i=i+1)begin
					if(frac_reg[i]==1)begin
					skip_flag<=1;
					state<=S4;
					end
				end
			if(skip_flag == 0)begin
				if(int_reg[0]==0)
					state<=S3;
				else
					state<=S4;
			end
			end
			end
			
	 S3:	begin //rounding down
				frac_reg[17:0]<=0;
				state<=S5;
			end
			
	 S4:	begin //rounding up
				frac_reg[17:0]<=0;
				int_reg<=int_reg+1;
				skip_flag<=0;
				state<=S5;
			end
			
	 S5:	begin
				temp_reg<=int_reg << 18-Nquant;
				state<=S1;
			end
	endcase
	end
end

assign dataout=temp_reg;
*/


