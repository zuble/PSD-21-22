/*
PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
	Implements a set of 16 write/read registers of 64 bits
   
*/

module reg_bank(
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


// Additional registers
reg [31:0]  Real,
            Im;

reg     [0:63]     regs_vec [15:0];     // 16 registers with a 64 bits dimension
wire    [0:63]     const [ 8:0];        // 9 sets of predefined constants

integer i;


//Predefined constant sets
assign const[0] = {32'b00,32'b00};               //0+j0
assign const[1] = {32'b01,32'b00};               //1+j0
assign const[2] = {32'b00,32'b01};               //0+j1
assign const[3] = {32'b01,32'b01};               //1+j1
assign const[4] = {32'hFFFFFFFF,32'b00};         //-1+j0
assign const[5] = {32'b00,32'hFFFFFFFF};         //0-j1
assign const[6] = {32'hFFFFFFFF,32'hFFFFFFFF};   //-1-j1
assign const[7] = {32'hFFFFFFFF,32'b01};         //-1+j1
assign const[8] = {32'b01,32'hFFFFFFFF};         //1-j1


//------------------------------------------------------
always@(posedge clock)

    // RESET 
    if(reset) begin
        for (i = 0; i < 16; i = i + 1) begin
            regs_vec[i]<=64'b00;
        end
    end

    
    // LOAD REGISTERS ACCORDING TO regwen & endwreg 
    else begin if(regwen) begin

        case(endwreg)
            2'b00: regs_vec[selwreg]<=inA[63:0];
            2'b01: regs_vec[selwreg]<={inA[63:32],32'b00}; 
            2'b10: regs_vec[selwreg]<={32'b00,inA[31:0]};
            2'b11: regs_vec[selwreg]<={inA[31:0],inA[63:32]};
        endcase

    end

    // LOAD REGISTER OUTPUTS A&B 
    else begin
        
        if( enrregA ) begin
            
            // Load output port A with constants
            if( cnstA ) begin
                outA <= const[seloutA];
            end 

            // Load output port A with data from register
            else begin 
                case(seloutA)
                    4'b0000: outA <= regs_vec[0];
                    4'b0001: outA <= regs_vec[1];
                    4'b0010: outA <= regs_vec[2];
                    4'b0011: outA <= regs_vec[3];
                    4'b0100: outA <= regs_vec[4];
                    4'b0101: outA <= regs_vec[5];
                    4'b0110: outA <= regs_vec[6];
                    4'b0111: outA <= regs_vec[7];
                    4'b1000: outA <= regs_vec[8];
                    default: outA <= 64'b00;
                endcase
            end

        end
        
        if( enrregB ) begin

            // Load output port B with constants
            if( cnstB )begin
                outB <= const[seloutB];
            end

            // Load output port A with data from register
            else
                case(seloutB)
                    4'b0000: outB <= regs_vec[0];
                    4'b0001: outB <= regs_vec[1];
                    4'b0010: outB <= regs_vec[2];
                    4'b0011: outB <= regs_vec[3];
                    4'b0100: outB <= regs_vec[4];
                    4'b0101: outB <= regs_vec[5];
                    4'b0110: outB <= regs_vec[6];
                    4'b0111: outB <= regs_vec[7];
                    4'b1000: outB <= regs_vec[8];
                    default: outB <= 64'b00;
                endcase           
            end

        end

    end



endmodule