/* 
PSD 2021-2022
Lab 1 - Design and verification of a sequential square root calculator
	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
	jca@fe.up.pt, April 2022
	
*/

`timescale 1ns / 100ps

module psdsqrt_xtra_tb;
 
// general parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)

parameter NBITS = 32;

// Registers for driving the inputs:
reg clock, reset;
reg [NBITS-1:0] x;
reg start, stop;

//reg run; 
//wire start, stop, busy;

// Registers for driving the outputs:
wire [(NBITS/2)-1:0] sqrt;


/*
seq_ctrl  #(.NBITSIN(NBITS)) seq_1    
	( 		
    .run(run),
    .clock(clock), // master clock rising edge 
    .reset(reset),
    .busy(busy),
    .start(start),
    .stop(stop)
);
*/

psdsqrt_xtra #(.NBITSIN(NBITS)) psdsqrt_1( 	
    .clock(clock), // master clock, active in the positive edge
    .reset(reset), // master reset, synchronous and active high
    .start(start), // set to 1 during one clock cycle to start a sqrt
    .stop(stop),   // set to 1 during one clock cycle to load the output registers
    .xin(x),       // the operands
    .sqrt(sqrt)
);    						

// Setup initial signals
initial
begin
  $dumpfile("mysimdata.vcd"); 
  $dumpvars(0, psdsqrt_xtra_tb);
  //run=0;

  start = 1'b0;
  stop  = 1'b0;
  x=0;
  clock = 0;
  reset = 0;

end

//---------------------------------------------------
// generate a 50% duty-cycle clock signal
initial
begin  
  forever
    # (CLOCK_PERIOD / 2 ) clock = ~clock;
end

//---------------------------------------------------
// Apply the initial reset for 2 clock cycles:
initial
begin
  # (CLOCK_PERIOD/3) // wait a fraction of the clock period to 
                     // misalign the reset pulse with the clock edges:
  reset = 1;
  # (2 * CLOCK_PERIOD ) // apply the reset for 2 clock periods
  reset = 0;
  
end

//---------------------------------------------------
// Set the maximum simulation time:
initial
begin
  # ( MAX_SIM_TIME )
  $stop;
end


//---------------------------------------------------
// The verification program (THIS IS TRUE A PROGRAM!)
integer i , flag = 0;
initial
begin
  // Wait 10 clock periods
  #( 10*CLOCK_PERIOD );


  $display("\n\tSTART\n");
    
  execsqrt(1000);
  $display("sqrt(1000)= %d\nobtido: %d\n",  golden_sqrt(1000), sqrt );

  execsqrt(0);
  $display("sqrt(0)= %d\nobtido: %d\n",  golden_sqrt(0), sqrt );

  execsqrt(-1);
  $display("sqrt(-1)= %d\nobtido: %d\n",  golden_sqrt(-1), sqrt );

  execsqrt(9);
  $display("sqrt(9)= %d\nobtido: %d\n",  golden_sqrt(9), sqrt );
  
  execsqrt(144);
  $display("sqrt(144)= %d\nobtido: %d\n",  golden_sqrt(144), sqrt );
  
  execsqrt(4294967295);
  $display("sqrt(4294967295)= %d\nobtido: %d\n",  golden_sqrt(4294967295), sqrt );


  for (i=0; i<100000; i=i+1 )
  begin
    
    execsqrt( i );
    if(sqrt != golden_sqrt(i)) begin
      $display("Expected Value: %d || Obtained: %d",  golden_sqrt( i ), sqrt );
      flag = 1;
    end

  end
  
  if(flag == 0)
    $display("\n\tall good\n\n\tEND\n");
  else 
    $display("\n\tnot good\n\n\tEND\n");


/*
  startstates(100);
  $display("test = %d", sqrt , "");
  startstates(12);
  $display("%d", sqrt);
  startstates(13);
  $display("%d", sqrt);
  startstates(1057);
  $display("%d", sqrt);
  startstates(4300);
  $display("%d", sqrt);
*/
  
  #( 10*CLOCK_PERIOD );
  //$stop;
  $finish;  //acaba a simulação

end


//---------------------------------------------------
// Simulate the sequential controller to perform a square root.
task execsqrt;
input [NBITS-1:0] xin;
begin
  x = xin;   // Apply operands
  @(negedge clock);
  start = 1'b1;       // Assert start
  @(negedge clock );
  start = 1'b0;  
  repeat (NBITS/2) @(posedge clock); 
  @(negedge clock);
  stop = 1'b1;        // Assert stop
  @(negedge clock);
  stop = 1'b0;
  @(negedge clock);
  
  // Print the results:
  // You may not watt to do this when verifying some millions of operands...
  // Add a flag to enable/disable this print
  //$display("Final SQRT(Input:%d)=%d", x, sqrt ); // Execute division
  
end  
endtask

//---------------------------------------------------
// A Verilog function implementing the same SQRT algorithm
// This is the "golden" function whose result should be exact
// bit by bit with the result created by your circuit.
// Note this does not include the rounding process nor
// supports the parameterization for different number of bits
function [15:0] golden_sqrt( input [31:0] xin );
reg   [15:0] mask;
reg   [15:0] temproot;
integer i;

  begin
    mask = 16'b1000_0000_0000_0000;
    temproot = 0;
    for (i=0; i<16; i=i+1 )
    begin
      if (  xin >= ( temproot | mask ) * (temproot | mask ) )
        temproot = temproot | mask;
      mask = mask >> 1;
    end
    golden_sqrt = temproot;
  end

endfunction



//---------------------------------------------------
// Simulate the sequential controller to perform a square root.
/*
task startstates;
input [NBITS-1:0] xin;

    begin
    x = xin;   // Apply operands

    @(posedge clock);
    run = 1'b1;       // Assert start
    @(posedge clock );
    run = 1'b0;
    @(posedge clock );  
    while (busy) @(posedge clock);

    @(posedge clock );
    end  
  
endtask
*/


endmodule