`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:03:59 12/03/2020
// Design Name:   DPRAM
// Module Name:   C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/DPRAM_tb.v
// Project Name:  psdlab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DPRAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DPRAM_tb;

	// Inputs
	reg clock1;
	reg [6:0] addr1;
	reg we1;
	reg [17:0] datain1;
	reg clock2;
	reg [6:0] addr2;

	// Outputs
	wire [17:0] dataout1;
	wire [17:0] dataout2;

	// Instantiate the Unit Under Test (UUT)
	DPRAM uut (
		.clock1(clock1), 
		.addr1(addr1), 
		.we1(we1), 
		.datain1(datain1), 
		.dataout1(dataout1), 
	
   	.clock2(clock2), 
		.addr2(addr2), 
		.dataout2(dataout2)
	);

	initial begin
		// Initialize Inputs
		clock1 = 0;
		addr1 = 0;
		we1 = 0;
		datain1 = 0;
		
		clock2 = 0;
		addr2 = 0;

		// Wait 100 ns for global reset to finish
		#100;
	end


   initial
   begin
     #23
	  forever #5 clock1 = ~clock1;
   end

   initial
   begin
     #29
	  forever #5 clock2 = ~clock2;
   end
	
	initial
	begin
	  # 200;
	  @(negedge clock2);
	  
	  for( addr2=0; addr2<127; addr2 = addr2 + 1)
	  begin
	    #1
	    @(negedge clock2);
	  end
	  $stop;
	end
	
endmodule

