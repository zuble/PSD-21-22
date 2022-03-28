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
reg[4:0] counter;
reg[2:0] state;
localparam S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110, S7=3'b111;
localparam [4:0] reg_size=17;
integer i;

always@(posedge clock)begin
  if(reset)begin
    temp_reg<=0;
    int_reg<=0;
    frac_reg<=0;
    state<=S1;
      counter<=0;
  end
  else begin
  case(state)
    S1:begin //Armazenar parte inteira
      if(endatain)begin
        int_reg<=datain >> 18-Nquant;
        state<=S7;
      end
  end
  S7:begin //Armazenar parte fraccionária
    if(counter<18-Nquant)begin
      frac_reg[counter]<=datain[counter];
      counter<=counter+1;
    end
    else begin
      counter<=0;
      state<=S2;
    end
  end
  S2:begin
    if(frac_reg[reg_size-Nquant]==0)begin
        state<=S3;
    end
    else begin
      if(counter<reg_size-Nquant)begin
        if(frac_reg[counter]==1)begin
          state<=S4;
        end
        else begin
        counter<=counter+1;
        end
      end
      else begin
        state<=S6;
      end
    end
  end

S6:begin
    if(int_reg[0]==0)begin
      state<=S3;
    end
    else begin
      state<=S4;
    end
  end

S3:begin //rounding down
  frac_reg[17:0]<=0;
  state<=S5;
end
S4:begin //rounding up
  frac_reg[17:0]<=0;
  int_reg<=int_reg+1;
  state<=S5;
end
S5:begin
  counter<=0;
  temp_reg<=int_reg << 18-Nquant;
  state<=S1;
end
endcase
end
end


assign dataout=temp_reg;

endmodule
