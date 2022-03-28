/*

	Testbench for the linear 4x interpolator
	
    jca@fe.up.pt

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
*/
`timescale 1ns/1ps

module interpol4x_tb;

// Filenames of data files:
parameter INPUT_FILENAME    = "../simdata/indata.hex",
          OUTGOLDEN_FILENAME = "../simdata/outdata.hex",
          MAXPOS             = 4096,   // Maximum number of data samples to load
		  MAXERRORS          = 100,     // Max errors to abort simulation
		  CLOCK_PERIOD       = 8.138;  // Clock period in ns (Fclk = 12.288 MHz)

	
// input vector and expected output data:	
reg  signed [17:0] xkinv[0:MAXPOS];
reg  signed [17:0] ykoutgoldenv[0:MAXPOS];


reg         clock;        // Master clock, 10 MHz
reg         reset;        // Master synchronous reset, active high
reg         en48000Hz;    // 48000 Hz clock enable (Fs)
reg         en192000Hz;   // 4 x 48000 = 192000 Hz clock enable (4 x Fs)

reg  signed [17:0] xkin;  // input signal
wire signed [17:0] ykout;  // output signal

// Instantiation of the interpolator
interpol4x 
UUT( 
            .clock( clock ), 
            .reset( reset ),
		    .clkenin( en48000Hz ),
            .clken4x( en192000Hz ),
		    .xkin( xkin ),
		    .ykout( ykout )
		 );



// Load simulation vectors
integer ni, no; // Number of samples read:
initial
begin
  $readmemh( INPUT_FILENAME, xkinv );
  $readmemh( OUTGOLDEN_FILENAME, ykoutgoldenv );
     
  // Count number of input samples read:
  ni = 0;
  while ( xkinv[ ni ] !== 18'hx )
  begin
    ni = ni + 1;
  end
  $display( "Input test signal: %d samples", ni );

  // Count number of output samples read:
  no = 0;
  while ( ykoutgoldenv[ no ] !== 18'hx )
  begin 
    no = no + 1;
  end
  $display( "Expected output signal: %d samples", no );
  
end	

  
integer j = 0;
initial
begin
  clock = 1'b0;
  reset = 1'b0;
  xkin = 18'd0;
  en48000Hz = 1'b0;
  en192000Hz = 1'b0;
  
  // generate the master clock: 12.288 MHz (period = 4.069 ns)
  #104
  forever #4.069 clock = ~clock;
end

// generate the master reset:
initial
begin
  # 200
  reset = 1;
  repeat (10)
    @(negedge clock);
  reset = 0;
end


// generate the en48000Hz clock enable: (divide clock by 256)
// the clock enable pulse lasts only for one clock cycle:
// NOTE this code is not synthesisable !
initial 
begin
  #1
  @(negedge reset);
  #1
  repeat (10)
    @(negedge clock);
  #1
  while (1)
  begin
    en48000Hz = 1;
    @(negedge clock);
    #2
    en48000Hz = 0;
    repeat (255)
      @(negedge clock);
  end
end


// generate the en192000Hz clock enable: (divide clock by 64)
// the clock enable pulse lasts only for one clock cycle:
// NOTE this code is not synthesisable !
always 
begin
  #1
  @(negedge reset);
  #1
  repeat (10)
    @(negedge clock);
  #1
  while (1)
  begin
    en192000Hz = 1;
    @(negedge clock);
    #2
    en192000Hz = 0;
    repeat (63)
      @(negedge clock);
  end
end

//------------------------------------------------------------
// Main simulation process
// Apply refpos(i), update system response, compare new position
integer i = 0, k = 0;
integer error_count = 0;

// Apply input samples:
initial
begin
  for (i=0; i<ni; i=i+1 )
  begin
    // Apply input sample in the rising edge of input clock enable:
	@(posedge en48000Hz)
	xkin = xkinv[i];
  end
  if ( error_count == 0 )
    $display("No errors found");
  $stop;
end

// Verify output data
always  @(posedge en192000Hz)
begin
  @(posedge clock);
  #2
  $display("Yout = %d ", ykout );

  if ( ykout != ykoutgoldenv[k] )
  begin
	$display("Error %4d at time %8d, output sample index = %3d, read %d != expected %d",
	          error_count, $time, k, ykout, ykoutgoldenv[k] );
			  
	error_count = error_count + 1;
	if ( error_count == MAXERRORS )
	begin
	  $display("Too many errors, aborting simulation");
	  $stop;
	end
  end
  k = k + 1;
end


endmodule
