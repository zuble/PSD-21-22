/*

	Testbench for the linear 4x interpolator
	
    jca@fe.up.pt

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
*/
`timescale 1ns/1ps

module stereo_encoder_192_tb;

// Filenames of data files:
parameter  CLOCK_PERIOD       = 8.138;  // Clock period in ns (Fclk = 12.288 MHz)

	
reg         clock;        // Master clock, 10 MHz
reg         reset;        // Master synchronous reset, active high
reg         en48000Hz;    // 48000 Hz clock enable (Fs)
reg         en192000Hz;   // 4 x 48000 = 192000 Hz clock enable (4 x Fs)

reg  signed [17:0] lpr;  // input signal
reg  signed [17:0] lmr;  // input signal

wire signed [23:0] stereo_Kf_out;  // output signal lpr

// Instantiation of the interpolator
 stereo_encoder_192 encoder_192(	
							.clock(clock),
							.reset(reset),
							.enableclk192(en192000Hz),
							.lpr(lpr),
							.lmr(lmr),
							.Kp(4'h0),
							.Kf(8'b0001_0000),
							.stereo_Kf_out(stereo_Kf_out)
							);


initial
begin
  clock = 1'b0;
  reset = 1'b0;
  lpr = 18'd0;
  lmr = 18'd0;
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
	@(posedge en192000Hz)
	lpr = 'd1;
	lmr = 'd1;
	@(posedge en192000Hz)
	$display("left %d right %d lpr %d",
	          lpr, lmr, stereo_Kf_out);
  #2000
  $stop;
end



endmodule
