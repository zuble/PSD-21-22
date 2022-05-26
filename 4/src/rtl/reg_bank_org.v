/* 
PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
*/

module reg_bank_org(

    input clock,                // Master clock, active in the posedge
    input reset,                // Master reset, synchronous and active high
    //--- Data input port ----------------------------------------------------
    input regwen,               // Register write enable: set to 1 to write the register
                                // selected by selwreg with the data at port inA
    input [63:0] inA,           // Data input
    input [ 3:0] selwreg,       // Select register index [0 to 15] to write data from port inA
    input [ 1:0] endwreg,       // Data enable: 00-write both data fields
                                // 10/01-write only data field selected by 1’b0
                                // 11: swap high word and low word
    //--- Data output ports --------------------------------------------------
    output reg [63:0] outA,     // Data output A, registered
    output reg [63:0] outB,     // Data output B, registered
    input [ 3:0] seloutA,       // Select register index [0 to 15] to output port outA
    input [ 3:0] seloutB,       // Select register index [0 to 15] to output port outB
    input cnstA,                // Define whether the output ports A and B are loaded with
    input cnstB,                // the contents of the register bank or a fixed constant
    input enrregA,              // Read enable to output register outA (loads output register)
    input enrregB               // Read enable to output register outB (loads output register)
 
); 


reg [63:0] reg_vec [3:0];
reg [63:0] cnst_vec [8:0];

assign cnst_vec[0] = {32'b00,32'b00}; //0+j0
assign cnst_vec[1] = {32'b01,32'b00}; //1+j0
assign cnst_vec[2] = {32'b00,32'b01}; //0+j1
assign cnst_vec[3] = {32'b01,32'b01}; //1+j1
assign cnst_vec[4] = {32'b11,32'b00}; //-1+j0
assign cnst_vec[5] = {32'b00,32'b11}; //0-j1
assign cnst_vec[6] = {32'b11,32'b11}; //-1-j1
assign cnst_vec[7] = {32'b11,32'b01}; //-1+j1
assign cnst_vec[8] = {32'b01,32'b11}; //1-j1

integer i;

    // WRITE FROM IN TO BANK
    always@(posedge clock)
        if(regwen) begin
            case(endwreg)
                2'b00: reg_vec[selwreg]<=inA[63:0];
                2'b01: reg_vec[selwreg]<={inA[63:32],32'b00}; 
                2'b10: reg_vec[selwreg]<={32'b00,inA[31:0]};
                2'b11: reg_vec[selwreg]<={inA[31:0],inA[63:32]};
                default:$display ("lets get it");
            endcase
        end
        else if(reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                reg_vec[i]<=64'b00;
            end
        end

    // WRITE FROM BANK TO outA
    always@(posedge clock)
        if(enrregA ) begin
            if(cnstA) begin
                outA <= cnst_vec[seloutA];
            end else if (~cnstA) begin
                case(seloutA)
                    4'b0000: outA <= reg_vec[0]
                    4'b0001: outA <= reg_vec[1]
                    4'b0010: outA <= reg_vec[2]
                    4'b0011: outA <= reg_vec[3]
                    4'b0100: outA <= reg_vec[4]
                    4'b0101: outA <= reg_vec[5]
                    4'b0110: outA <= reg_vec[6]
                    4'b0111: outA <= reg_vec[7]
                    4'b1000: outA <= reg_vec[8]
                    default: outA <= 64'b00;
                endcase
            end
        end

    // WRITE FROM BANK TO outB
    always@(posedge clock)
        if(enrregB) begin
            if(cnstB) begin
                outB <= cnst_vec[seloutB];
            end else if (~cnstB) begin
                case(seloutB)
                    4'b0000: outB <= reg_vec[0]
                    4'b0001: outB <= reg_vec[1]
                    4'b0010: outB <= reg_vec[2]
                    4'b0011: outB <= reg_vec[3]
                    4'b0100: outB <= reg_vec[4]
                    4'b0101: outB <= reg_vec[5]
                    4'b0110: outB <= reg_vec[6]
                    4'b0111: outB <= reg_vec[7]
                    4'b1000: outB <= reg_vec[8]
                    default: outB <= 64'b00;
                endcase
            end
        end

endmodule