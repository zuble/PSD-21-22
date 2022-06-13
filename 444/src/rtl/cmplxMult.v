/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
	Auxiliar alu module to implement the complex multiplication
    
    (a+bi)*(c+di) = (a*c + a*di + bi*c - b*d)

*/


module cmplxMult(           
    input clock,
    input reset,
    input [63:0] inA,
    input [63:0] inB,
    output [63:0] out
);

reg [63:0] in_A;
reg [63:0] in_B;
reg [63:0] letout;


reg isdone;

assign done = isdone;
assign out = letout;

always@(posedge clock)

    if( reset ) begin
        in_A <= 0;
        in_B <= 0;
    end

    else begin
        in_A  <=inA;
        in_B  <=inB;
                        //REAL A      //REAL B        //IM A       //IM B  
        letout[63:32] <= (in_A[63:32] * in_B[63:32]) - (in_A[31:0] * in_B[31:0]);
                    
                    //REAL A        //REAL B      //IM A    //IM B              //REAL A         //IM B    //IM A        //REAL B
        letout[31:0] <= (in_A[63:32] * in_B[31:0]) + (in_A[31:0] * in_B[63:32] );                    

        isdone <=1;
    end

endmodule