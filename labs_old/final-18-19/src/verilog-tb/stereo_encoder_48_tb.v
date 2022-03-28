/*

	Testbench for the linear 4x interpolator
	
    jca@fe.up.pt

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
*/
`timescale 1ns/1ps

module stereo_encoder_48_tb;

// Filenames of data files:
parameter  CLOCK_PERIOD       = 8.138;  // Clock period in ns (Fclk = 12.288 MHz)

	
reg         clock;        // Master clock, 10 MHz
reg         reset;        // Master synchronous reset, active high
reg         en48000Hz;    // 48000 Hz clock enable (Fs)
reg         en192000Hz;   // 4 x 48000 = 192000 Hz clock enable (4 x Fs)

reg  signed [17:0] left;  // input signal
reg  signed [17:0] right;  // input signal

wire signed [17:0] lmr_out;  // output signal lmr
wire signed [17:0] lpr_out;  // output signal lpr

// Instantiation of the interpolator
 stereo_encoder_48 encoder_48(	.clock(clock),
							.reset(reset),
							.enableclk48(en48000Hz),
							.left(left),
							.right(right),
							.Ks(4'h8),
							.Kd(4'h8),
							.LmR_out(lmr_out),
							.LpR_out(lpr_out)
							);


initial
begin
  clock = 1'b0;
  reset = 1'b0;
  left = 18'd0;
  right = 18'd0;
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


// generate the en176400Hz clock enable: (divide clock by 64)
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

// Apply input samples:
initial
begin
     // Apply input sample in the rising edge of input clock enable:
	@(posedge en48000Hz)
	left = -18'd210;
	right = 18'd206;
  #2000
  $stop;
end

// Verify output data
always  @(posedge en192000Hz)
begin
  @(posedge clock);
  #9
	$display("left %d right %d lpr %d lmr %d",
	          left, right, lpr_out, lmr_out);
			  

end


endmodule
