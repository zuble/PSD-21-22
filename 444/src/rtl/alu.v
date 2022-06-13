/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
    implements arithmetic and logical operations 0, 1, 2, 3, 6, 7, 8
    complex multiplication, opr=4, is taken care by cmplxMult.v
    complex division, opr=5, is taken care by cmplxDiv.v
    conversion to polar, opr=9 and 10, is taken care by rec2pol.v

*/

module alu(

    input clock,                // Master clock, active in the posedge
    input reset,                // Master reset, synchronous and active high
    input [63:0] inA,           // Data input A 
    input [63:0] inB,           // Data input B
    input [3:0] opr,            // Operation between data input A and data input B
    input start,
    
    //--- Data output ports --------------------------------------------------
    output reg [63:0] out_alu,  // Data output A, registered
    output done
 
    /*****************************************************************************|
    |OPR| DESCRIPTION              |MAX CLKS|                                     |
    |---|--------------------------|--------|-------------------------------------|
    | 0 |                          |  1 clk | outAB <= A                          |
    | 1 |                          |  1 clk | outAB <= B                          |
    | 2 | Complex & Real add       |  2 clk | outAB <= A + B                      |
    | 3 | Complex & Real sub       |  2 clk | outAB <= A – B                      |
    | 4 | Complex multiplication   |  6 clk | outAB <= A * B                      |
    | 5 | Complex division         | 40 clk | outAB <= A / B                      |
    | 6 | Real multiplication      |  4 clk | outAB <= RE(A)*RE(B) , IM(A)*IM(B)  |  
    | 7 | Real division            | 34 clk | outAB <= RE(A)/RE(B) , IM(A)/IM(B)  | 
    | 8 | Equality compare         |  1 clk | outAB <= (A == B)                   |
    | 9 | Conv inA to polar coords | 38 clk | outAB <= { MOD(A), ANG(A) }         |
    | 10| Conv inB to polar coords | 38 clk | outAB <= { MOD(B), ANG(B) }         |
    ******************************************************************************/
);

reg [63:0]  in_A, 
            in_B;

reg [31:0]  x0, 
            y0;

reg maxclock,
    done_alux,
    enable;

wire [63:0] out_mult,
            out_div;


wire [31:0] polMod,
            polAngle;


assign done = done_alux;


// complex multiplication module initiation
cmplxMult cmplx_Mult(
    .clock( clock ),
    .reset( reset ),
    .inA( in_A ),
    .inB( in_B ),
    .out( out_mult )
);

// complex division module initiation
cmplxDiv cmplx_Div(
    .clock( clock ),
    .reset( reset ),
    .inA( in_A ),
    .inB( in_B ),
    .out( out_div )
);

// rec2pol module initiation
rec2pol r2p (
    .clock(clock), 
    .reset(reset), 
    .enable(enable), 
    .start(start), 
    .x(x0), 
    .y(y0), 
    .mod( polMod ), 
    .angle( polAngle )
);



always@(posedge clock)

    // RESET 
    if( reset ) begin
        in_A <= 64'b00; 
        in_B <= 64'b00;
        out_alu <= 0;
        enable  <= 0;
    end

    else begin
        in_A <= inA[63:0];                       
        in_B <= inB[63:0];                          


        if ( start ) begin

            case ( opr )

                // A
                0000: begin                                
                    out_alu <= in_A;
                    done_alux <= 1;
                end

                // B
                0001: begin                                 
                    out_alu  <= in_B;
                    done_alux <= 1;
                end

                // A+ B
                0002: begin                                 
                    out_alu  <= in_A + in_B;
                    done_alux <= 1;
                end

                // A- B
                0003: begin                                 
                    out_alu  <= in_A - in_B;
                    done_alux <= 1;
            
                end

                // A * B COMPLEXO
                0004: begin                                 
                    out_alu  <= out_mult;
                    done_alux <= 1;
                end

                // A / B COMPLEXO
                0005: begin                                 
                    out_alu  <= out_div;
                    done_alux <= 1;
                end

                // A * B REAL
                0006: begin                                 
                    out_alu  <= in_A[63:32] * in_B[63:32];
                    done_alux <= 1;
                end

                // A / B REAL
                0007: begin                                 
                    out_alu  <= in_A[63:32] / in_B[63:32];
                    done_alux <= 1;
            
                end  

                // A == B   
                0008: begin                                 
                    if  (in_A == in_B) begin
                        out_alu = 1; 
                        done_alux <= 1;   
                    end                                       
                end

                // { MOD(A), ANG(A) }  
                0009: begin                                
                    x0 = in_A[63:32];
                    y0 = in_A[31:0];
                    enable <= 1;
                    out_alu = {polMod,polAngle};
                    done_alux <= 1;
                end

                default: begin
                    out_alu <= 64'b0;
                    done_alux <= 1;
                end

            endcase

        end
    end

 endmodule
