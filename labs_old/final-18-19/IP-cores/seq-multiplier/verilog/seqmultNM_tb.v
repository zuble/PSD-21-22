/*---------------------------------------------------------
    basic testbench for the sequential M by N multiplier

 	jca@fe.up.pt, Dec 2015
	
	This Verilog code is proprietary of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.

*/
`timescale 1ns/1ps

module seqmultNM_tb;

// Mult parameters
parameter N  = 12; // Number of bits of the multiplier
parameter M  = 14; // Number of bits of the multiplicand

reg clock;
reg reset;
reg start;
wire ready;
reg signed [M-1:0] A;
reg signed [N-1:0] B;
wire signed [M+N-1:0] R;

// Instantiate the multiplier and set the parameters N and M:
seqmultNM #( 
              .N( N ), // Number of bits of the multiplier
			  .M( M )  // Number of bits of the multiplicand
		    )
			seqmult_1
       (
			.clock( clock ),
			.reset( reset ),
			.start( start ), // input, set start=1 during one clock cycle to start the multiplication
			.ready( ready ), // output, set to 1 when the multiplier is ready to accept a new start
			                 //         and the result is ready after activating input start
			.A( A ),         // Multiplicand,  M bits
			.B( B ),         // Multiplier,    N bits
			.R( R )          // Result: A x B, M+N bits
		);

		
// Init regs and generate clock
initial
begin
  clock = 0;
  reset = 0;
  start = 0;
  A = 0;
  B = 0;
  #3 forever #5 clock = ~clock;
end

// Apply reset:
initial
begin
  # 1;
  @(negedge clock);
  reset = 1;
  @(negedge clock);
  reset = 0;
end


// Execute one multiplication:
reg signed [M+N-1:0] expectedR; // This is needed to compute the result A x B with M+N bits
                         // in the $write( )
initial
begin
  # 1;
  @(negedge reset);
  @(negedge clock);
  A = -321;
  B = 1234;
  expectedR = A * B;
  start = 1;
  @(negedge clock);
  start = 0;
  @(negedge clock);
  @(posedge ready);
  $write( "A=%d, B=%d, AxB=%d (expected %d)\n", A, B, R, expectedR );
  # 100
  $stop;
end

		
endmodule
