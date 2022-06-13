/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
    Implements the tests for the register bank module

*/

`timescale 1ns / 1ps

module testbench;

initial
begin
  $dumpfile("mysimdata.vcd");   // The filename with the waveform data
  $dumpvars(0, testbench );     // The root node to dump end
end

// General parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)


// reg_bank variables
reg clock, reset, start, regwen;
reg cnstA, cnstB, enrregA, enrregB;

reg [63:0]  in;
reg [ 3:0]  selwreg;
reg [ 1:0]  endwreg;

reg [ 3:0]  seloutA,
            seloutB,
            opr;

wire [63:0] outA,
            outB;


// alu variables
wire [63:0] result;
wire done;

reg [63:0]  inA_Alu,
            inB_Alu;
reg maxclock;


// rec2pol variables
reg enable;
reg [31:0] x0;
reg [31:0] y0;

wire signed [31:0] polMod;
wire signed [31:0] polAngle;


// reg_bank module initiation
reg_bank r2p(  
  .clock( clock ), 
  .reset( reset ), 
  .regwen( regwen ),
  .inA( in ),
  .selwreg( selwreg ),
  .endwreg( endwreg ),
  .outA( outA ),
  .outB( outB ),
  .seloutA( seloutA ),
  .seloutB( seloutB ), 
  .cnstA( cnstA ),
  .cnstB( cnstB ), 
  .enrregA( enrregA ),
  .enrregB( enrregB )
);


// Setup initial signals
initial begin
  clock = 1'b0;
  reset = 1'b0;
  start = 1'b1;
  in_aux = 64'b0;
  regwen = 1'b0;
  cnstA = 1'b0;
  cnstB = 1'b0;
  enrregA = 1'b0;
  enrregB = 1'b0;
  opr =0000;         
  maxclock = 1'b1;
end


// Generate a 50% duty-cycle clock signal
initial begin  
  forever 
  # (CLOCK_PERIOD / 2 ) clock = ~clock;
end


// Reset
initial begin
	#10
	reset = 0; 
end


//----------------------------------------------------
integer j;
reg [ 3:0]  i_aux;
reg [63:0]  in_aux;
reg [31:0]  Real,
            Im;

initial begin

  Real  = 16'b10100;  //20
  Im    = 16'b10100;  //20i

  in_aux = {Real ,Im };

    
    for (j=0; j<16 ; j=j+1)

    begin
        #10
        endwreg = 2'b0;
        enrregA = 1'b1;
        enrregB = 1'b1;    
        cnstA = 1'b0;
        cnstB = 1'b0; 
        opr = 4'b0;          
        maxclock = 1'b1;

        
        // REG_BANK
        @(posedge clock);
        in = in_aux;  
        regwen = 1'b1;
        selwreg = j;
        #10
        @(negedge clock);
        regwen = 1'b0;   
        seloutA = j;
        seloutB = j; 

        #10
        $display("%d: %h",j, outA);

    end

  $finish;

end

endmodule


