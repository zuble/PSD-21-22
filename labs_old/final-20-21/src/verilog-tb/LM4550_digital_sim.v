/*
  Simplified simulation model for the LM4550 audio codec
  jca@fe.up.pt, Nov 2012 
*/

`timescale 1ns/1ps

module LM4550_digital_sim(
                   input XTAL_IN,
				   input RESET_N,
				   
				   output reg BIT_CLK,
				   input SYNC,
				   output reg SDATA_IN,
				   input SDATA_OUT,
				   
				   input signed [17:0] LEFT_IN,       // inputs from the external "analog" circuit
				   input signed [17:0] RIGHT_IN,
				   output reg signed [17:0] LEFT_OUT,     // outputs to the external "analog" circuit
				   output reg signed [17:0] RIGHT_OUT
				   );





// configuration registers (only 20 registers are actually used):
reg [15:0]  REGS[0:127];


// frame and tag registers:
reg [219:0] framein;
reg [239:0] frameout;
reg [15:0]  tagin, tagout, tagout_r;

// control signals:
reg ac_link_ready,
    rqst_left, rqst_right,
	ready_left, ready_right;

// data slots for the output frame:
reg [19:0]  slotout1, slotout2, slotout3, slotout4,
            slotout5, slotout6, slotout7, slotout8,
            slotout9, slotout10, slotout11, slotout12;
			
// data slots from the input frame:
reg [19:0]  slotin1, slotin2, slotin3, slotin4,
            slotin5, slotin6, slotin7, slotin8,
            slotin9, slotin10, slotin11, slotin12;
			
// Aux variables:
integer i, j, k;


initial
begin
  BIT_CLK = 0;
  for (i=0; j<128; j=j+1)
    REGS[j] = 16'd0;
	
  slotout1 = 20'd0;
  slotout2 = 20'd0;
  slotout3 = 20'd0;
  slotout4 = 20'd0;
  slotout5 = 20'd0;
  slotout6 = 20'd0;
  slotout7 = 20'd0;
  slotout8 = 20'd0;
  slotout9 = 20'd0;
  slotout10 = 20'd0;
  slotout11 = 20'd0;
  slotout12 = 20'd0;
  
  tagout_r = 16'd0;  

  slotin1 = 20'd0;
  slotin2 = 20'd0;
  slotin3 = 20'd0;
  slotin4 = 20'd0;
  slotin5 = 20'd0;
  slotin6 = 20'd0;
  slotin7 = 20'd0;
  slotin8 = 20'd0;
  slotin9 = 20'd0;
  slotin10 = 20'd0;
  slotin11 = 20'd0;
  slotin12 = 20'd0;
  
  // always send valid samples and request new samples in every frame:
  rqst_left = 1;
  rqst_right = 1;
  ready_left = 1;
  ready_right = 1;
  ac_link_ready = 1;
  SDATA_IN = 0;
end


//---------------------------------------------------------------------
// cold reset:
/*
always @(posedge XTAL_IN)
begin
  if ( ~RESET_N )
  begin	
  slotout1 = 20'd0;
  slotout2 = 20'd0;
  slotout3 = 20'd0;
  slotout4 = 20'd0;
  slotout5 = 20'd0;
  slotout6 = 20'd0;
  slotout7 = 20'd0;
  slotout8 = 20'd0;
  slotout9 = 20'd0;
  slotout10 = 20'd0;
  slotout11 = 20'd0;
  slotout12 = 20'd0;
  
  tagout_r = 16'd0;  

  slotin1 = 20'd0;
  slotin2 = 20'd0;
  slotin3 = 20'd0;
  slotin4 = 20'd0;
  slotin5 = 20'd0;
  slotin6 = 20'd0;
  slotin7 = 20'd0;
  slotin8 = 20'd0;
  slotin9 = 20'd0;
  slotin10 = 20'd0;
  slotin11 = 20'd0;
  slotin12 = 20'd0;
  
  end
end
*/

//---------------------------------------------------------------------
// the output frame made up of 12 20-bit slots:			
assign frameout_r = { slotout1, slotout2, slotout3, slotout4, slotout5, slotout6, 
                      slotout7, slotout8, slotout9, slotout10, slotout11, slotout12 };		 
		 
		 
//---------------------------------------------------------------------
// Generate the BIT_CLK from XTAL_IN (divide by 2)
// XTAL in = 24.576 MHz, BIT_CLK = 12.288 MHz
always @(posedge XTAL_IN)
  #1 BIT_CLK = ~BIT_CLK;

  
//---------------------------------------------------------------------
// Read input frame: frame starts with the rising edge of SYNC:
always @(posedge SYNC)
begin
  #1
  @(posedge BIT_CLK);    // wait for next rising edge of BIT_CLK
  if ( SYNC == 1'b0 )    // false SYNC, too short
  begin
    $display("SYNC error: too short positive pulse");
  end
  else
  begin
    #1
	// read the first 16 bits as the tag phase
    for(i=0; i<16; i=i+1)
    begin
	  // Capture incoming bits in the negative clock edge
      @(negedge BIT_CLK); 
      #1	  
	  tagin = {tagin[14:0], SDATA_OUT};
    end	
	// read the rest of the frame (220 bits, last slot is always discarded) 
    for(i=0; i<220; i=i+1)
    begin
	  // Capture incoming bits in the negative clock edge
      @(negedge BIT_CLK);
	  #1
	  framein = {framein[218:0], SDATA_OUT};
    end	
	// $display($time, "  Frame: %x, tag: %x", framein, tagin );
  end
 
 if ( tagin[15] ) // input frame is valid
 begin
   // split the received frame into the 11 data slots:
   { slotin1, slotin2, slotin3, slotin4, slotin5,
         slotin6, slotin7, slotin8, slotin9, slotin10, slotin11 } = framein[219:0]; 
   // Read / write configuration registers:
   if (tagin[14:13] == 2'b11 ) // valid write register slots:
   begin
     if ( slotin1[19] == 1'b1 ) // read data
	 begin
	   slotout2 = { REGS[ slotin1[18:12] ], 4'd0};
	   tagout_r[14] = 1'b1; // slot 1 has valid data (reg address and status)
	   tagout_r[13] = 1'b1; // slot 2 has valid data (register data)
	 end
	 else                   // write data
	 begin
	   if ( slotin1[18:12] == 7'h2C || slotin1[18:12] == 7'h32 ) // ADC / DAC data rate
	   begin
	     // $display( $time, "Invalid write: changing sampling rate is not supported");
	   end
	   else
	   begin
	     if ( tagin[14:13] == 2'b11 ) // if valid data in slots 1 and 2:
		 begin
	       REGS[ slotin1[18:12] ] = slotin2[19:4];
	       // $display($time, "  Writing register %x with %x", slotin1[18:12], slotin2[19:4]);
		   slotout2 = 20'd0;
		 end
	   end
	 end
   end
  
// form the data slots to be sent in the next frame:
   slotout1[19]    = 1'b0;           // always zero
   slotout1[18:12] = slotin1[18:12]; // requested register address
   slotout1[11]    = rqst_left;      // slot 3 request data (left channel)
   slotout1[10]    = rqst_right;     // slot 4 request data (right channel)
   slotout1[9:0]   = 10'd0;
   
   tagout_r[15] = ac_link_ready;       // AC link is ready
   tagout_r[12] = ready_left;          // slot 3 valid data (left ADC data)
   tagout_r[11] = ready_right;         // slot 4 valid data (right ADC data)
   
   tagout_r[10:0] = 11'd0;             // unused bits
   
   if (ready_left)
     slotout3 = {LEFT_IN, 2'd0};
   else
     slotout3 = 20'd0;

   if (ready_right)
     slotout4 = {RIGHT_IN, 2'd0};
   else
     slotout4 = 20'd0;

   // Unused slots padded with zeros:
   {slotout5, slotout6, slotout7, slotout8,
    slotout9, slotout10, slotout11, slotout12} = 160'd0;
	 					  
  // Output path (from DAC):
  // if valid data, extract the data samples for the DAC input:
    if ( tagin[12:11] == 2'b11 ) // valid data for left and right DAC
    begin
      LEFT_OUT  = slotin3[19:2];  // Extract left data from slot 3 (integer, 18 bits left justified)
      RIGHT_OUT = slotin4[19:2];  // Extact right data from slot 4 (integer, 18 bits left justified)
    end
  end
  else
  begin
    // $display($time," Invalid frame received: bit 15 of tag is 0");
  end

end



/*
always @(negedge SYNC)
begin
   #1
// form the data slots to be sent in the next frame:
   slotout1[19]    = 1'b0;           // always zero
   slotout1[18:12] = slotin1[18:12]; // requested register address
   slotout1[11]    = rqst_left;      // slot 3 request data (left channel)
   slotout1[10]    = rqst_right;     // slot 4 request data (right channel)
   slotout1[9:0]   = 10'd0;
   
   tagout_r[15] = ac_link_ready;       // AC link is ready
   tagout_r[12] = ready_left;          // slot 3 valid data (left ADC data)
   tagout_r[11] = ready_right;         // slot 4 valid data (right ADC data)
   
   tagout_r[10:0] = 11'd0;             // unused bits
   
   if (ready_left)
     slotout3 = {LEFT_IN, 2'd0};
   else
     slotout3 = 20'd0;

   if (ready_right)
     slotout4 = {RIGHT_IN, 2'd0};
   else
     slotout4 = 20'd0;

   // Unused slots padded with zeros:
   {slotout5, slotout6, slotout7, slotout8,
    slotout9, slotout10, slotout11, slotout12} = 160'd0; 			
end				


*/


//---------------------------------------------------------------------
// Send output frame: frame starts with the rising edge of SYNC:
always @(posedge SYNC)
begin
  #1
  frameout = { slotout1, slotout2, slotout3, slotout4, slotout5, slotout6, 
                      slotout7, slotout8, slotout9, slotout10, slotout11, slotout12 }; // latch the frame data to output
  tagout = tagout_r;
  @(negedge BIT_CLK);    // wait for next falling edge of BIT_CLK
  #1
  // send the first 16 bits as the tag phase
  for(j=0; j<16; j=j+1)
  begin
	// send outgoing bits in the positive clock edge
    @(posedge BIT_CLK);
	#1
    SDATA_IN = tagout[15];	
	tagout = {tagout[14:0], 1'b0};
	// DISABLE verification of SYNC
    //if ( SYNC == 1'b0 && j < 15)  // Do not check SYNC state in the last bit, it has alreadybeen set to zero
	//  $display($time, " - SYNC error: SYNC is low during the tag phase");
  end	
  // send the rest of the frame (240 bits) 
  for(j=0; j<220; j=j+1)
  begin
	// send outgoing bits in the positive clock edge
    @(posedge BIT_CLK);
	#1
    SDATA_IN = frameout[239];
	frameout = {frameout[238:0], 1'b0};
 	// DISABLE verification of SYNC
    //if ( SYNC == 1'b1 )
	//  $display($time, " - SYNC error: SYNC is high during the data phase (%d)", j);
  end
  // discard last slot, always send 0:
  SDATA_IN = 0;
  
end



endmodule

