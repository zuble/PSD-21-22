module calibration    
	#( 	parameter M=16, // default value for M       
		parameter N=16) // default value for N     
	(    
		input  clock,          
		input  reset,          
		input  start, // set to 1 to start a new conversion          
		output ready, // set to 1 when ready          
		input  signed [16-1 : 0 ] X,          
		output signed [16-1 : 0 ] Y     
	); 
	
	// The lookup table, 16 locations, X and Y pairs: 
reg [ N + M - 1 : 0 ] LUTcalib[0:15]; 

// Load initial contents to the LUT from file “datafile.hex”: 
initial 
begin   
	$readmemh( “./data/datafile.hex”, LUTcalib ); 
end 
//your code here ... 

// binary search in LUTcalib

reg [4:0] L, R, midpoint;
integer i = 0;

always@( posedge clock)
begin
if(start)
begin
  L <= 4'd0;
  R <= 4'd15;
  midpoint <= 4d'0;
  flag <= 1b'0;
end
else  
begin
  for(i = 0; i < 4 && (flag == 0); i = i + 1)
	begin
		midpoint = (L + R) >> 1;		// isto arredonda por excesso ou por defeito?
		
		if(LUTcalib[midpoint][N + M-1: N] < X)
			L = midpoint + 1;
		else if(LUTcalib[midpoint][N + M-1: N] > X)
			R = midpoint - 1;
		else if(LUTcalib[midpoint][N + M-1: N] = X)
			flag = 1;
	end
	
  end
end

always@(posedge clock)
begin
	if(start)
		STATE <= INIT;
	else	
		STATE<= NEXTSTATE;
end

// NEXTSTATE logic
always@*
	case(STATE)
	INIT: 
	begin
		midpoint = (L + R) >> 1;
		if(LUTcalib[midpoint][N + M-1: N] < X)
			NEXTSTATE = STATE_L;
		else if(LUTcalib[midpoint][N + M-1: N] > X)
			NEXTSTATE = STATE_R;
		else 
			NEXTSTATE = FOUND;
	end	
	STATE_L:
	begin
		L = midpoint + 1;
		NEXTSTATE = INIT;
		if(iter == 4)
			NEXTSTATE = FINAL;
		iter = iter + 1;
	end
	STATE_R:
	begin
		R = midpoint - 1;
		NEXTSTATE = INIT;
		if(iter == 4)
			NEXTSTATE = FINAL;
		iter = iter + 1;
	end
	FOUND:
		y = LUTcalib[midpoint][M -1:0];
	FINAL: // do interpolation
		aux1 =;
		NEXTSTATE = slkfslf;
	sjdknjksdfn:
		aux2= ;
		NEXTSTATE = dkfsd
	dsajsl;
		aux3 = au1/aux2;
	endcase

endmodule

//next_Y = ($signed(LUTcalib[L][M -1:0])*($signed(LUTcalib[R][N + M -1 : N]) - X) + $signed(LUTcalib[R][M -1:0])*(X - $signed(LUTcalib[R][N + M -1 : N])))/($signed(LUTcalib[R][N + M -1 : N]) - $signed(LUTcalib[R][N + M -1 : N]));
    