/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
	Auxiliar alu module to implement the complex division
    
    (a+bi)/(c+di) = ((ac+bd)/(c²+d²)) + ((bc-ad)/(c²+d²))i

*/
module cmplxDiv( 
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
if( reset )
begin
    in_A <= 0;
    in_B <= 0;

end
else
begin
    in_A  <=inA;
    in_B  <=inB;       
                  //    ac                      +           bd                /    c²                  +              d²  
    letout[63:32] <= ((in_A[63:32] *in_B[63:32]) + (in_A[31:0] * in_B[31:0])) / (in_B[63:32]*in_B[63:32] +in_B[31:0]*in_B[31:0]);
                //      bc                      -           ad                 /    c²                  +               d²
    letout[31:0] <= ((in_A[31:0]  *in_B[63:32]) - (in_A[63:32] * in_B[31:0])) / (in_B[63:32]*in_B[63:32] +in_B[31:0]*in_B[31:0]);

    
    isdone <=1;
end




endmodule