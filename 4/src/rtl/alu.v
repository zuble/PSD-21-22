module alu(

    input clock,            // Master clock, active in the posedge
    input reset,            // Master reset, synchronous and active high
    input start,

    //--- Data input port ----------------------------------------------------                            
    input [63:0] inA,       // Data input
    input [63:0] inB,       // Data input
    input [4:0]  opr,   /*****************************************************************************|
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
    //--- Data output ports --------------------------------------------------
    output reg [63:0] outAB,     // Data output A, registered
    output reg done
); 

    wire [63:0] sum_out;

    reg [63:0] out_aux;

    /*
    rec2pol23   polar(
        .clock(clock),
        .reset(reset),
        .enable(),    //?
        .start(start),
        .x_in(),
        .y_in(),
        .mod_res(),
        .angle_res()
    );
    */

    sum sum0(    
        .sum_A(inA),
        .sum_B(inB),
        .sum_out(sum_out)
    );


    always@(posedge clock)
        if (reset) begin
            outAB <= 64'b00;
            done <= 0;
        end
        else begin 

            if (start) begin
                //$display("alu@inA : %d", inA); 
                case(opr)
                    5'b00000: 
                        begin
                            $display("opr: = inA"); 
                            done <= 1;
                            out_aux <= inA;
                        end
                    5'b00001: 
                        begin
                            $display("opr: = inB"); 
                            done <= 1;
                            out_aux <= inB;
                        end
                    5'b00010:
                        begin
                            $display("opr: sum"); 
                            done <= 1;
                            out_aux <= sum_out;
                        end
                    5'b00011:
                        begin
                            $display("opr: sub");
                            
                        end
                    5'b00100:
                        begin
                            $display("opr: im_mul");

                        end
                    5'b00101:
                        begin
                            $display("opr: im_div");

                        end
                    5'b00110:
                        begin
                            $display("opr: re_mul");

                        end
                    5'b00111:
                        begin
                            $display("opr: re_div");

                        end
                    5'b01000:
                        begin

                            $display("opr: comp");

                        end
                    5'b01001:
                        begin
                            $display("opr: polar inA");

                        end
                    5'b01010:
                        begin
                            $display("opr: polar inB");

                        end
                endcase


                if (done) begin
                    outAB <= out_aux;
                end

            end

        end

endmodule