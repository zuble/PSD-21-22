`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:       FEUP
// Engineer:      jca@fe.up.pt
//
// Create Date:   19:23:36 12/19/2020
// Design Name:   interpol
// Module Name:   C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/interpol_tb.v
// Project Name:  Linear interpolator
// Target Device: Spartan 3
// Tool versions:  
// Description:    Verilog Test Fixture created by ISE for module: interpol
//
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module interpol_tb;

	// Inputs
	reg clock;
	reg reset;
	reg endatain;
	reg endataout;
	reg [3:0] Nfreq;
	reg signed [17:0] datain;

	// Outputs
	wire signed [17:0] dataout;

	// Instantiate the Unit Under Test (UUT)
	interpol uut (
		.clock(clock), 
		.reset(reset), 
		.endatain(endatain), 
		.endataout(endataout), 
		.Nfreq(Nfreq), 
		.datain(datain), 
		.dataout(dataout)
	);
	
	parameter NFREQ = 6;
	
	reg signed [17:0] inputdata[0:511];
	
	integer ndata;

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		endatain = 0;
		endataout = 0;
		Nfreq = NFREQ;
		datain = 0;
		
		// Read sim data
		$readmemh( "../simdata/sine.hex", inputdata );
		ndata = 0;
		while ( inputdata[ndata] !== 18'dx )
		  ndata = ndata + 1;
	end
	 
	initial
	begin
	  #1
	  forever #5 clock = ~clock;
	end
	
	initial
	begin
	  #13 reset = 1;
	  #10 reset = 0;
	end
	
	// dataout clock enable = fclk / 10
   initial
	begin
	  #25
	  forever
	  begin
	    #90
		 endataout = 1;
		 #10
		 endataout = 0;
	  end
	end
	
	// Datain clock enable = dataout clock enable / Nfreq
	reg [3:0] count;
	always @(posedge clock)
	begin
	  if ( reset )
	    count <= 0;
	  else
	  begin
	  	 endatain <= 0;
	    if ( endataout )
		 begin
	      if ( count == Nfreq-1 )
			begin
			  endatain <= 1;
			  count <= 0;
			end
			else
			  count <= count + 1;
		 end
	  end
	end
	
	
	integer i = 0;
	
	// input stimuli:
	always @(posedge clock)
	begin
	  if ( endatain )
	  begin
	    datain <= inputdata[i];
		 i = i + 1;
		 if ( i == ndata )
		   $stop;
	  end
	end
      
endmodule

