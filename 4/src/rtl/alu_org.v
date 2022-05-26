module alu_org(

    input clock,                // Master clock, active in the posedge
    input reset,                // Master reset, synchronous and active high
    input start,
    //--- Data input port ----------------------------------------------------                            
    input [63:0] inA,           // Data input
    input [63:0] inB,           // Data input
    input [4:0] opr,
    //--- Data output ports --------------------------------------------------
    output reg [63:0] outAB,     // Data output A, registered
    output reg done
); 

    reg signed [31:0] re_inA = inA[64:32];
    reg signed [31:0] re_inB = inB[64:32];
    reg signed [31:0] re_outAB = outAB[64:32];

    reg signed [31:0] im_inA = inA[31:0];
    reg signed [31:0] im_inB = inB[31:0];
    reg signed [31:0] im_outAB = outAB[31:0];



endmodule