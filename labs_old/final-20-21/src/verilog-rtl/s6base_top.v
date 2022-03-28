
`timescale 1ns/1ps



module s6base_top(
			//------------------------------------------------------------------
			// Gobal external signals:
			input clockext100MHz,	  // master clock input (external oscillator 100MHz) THIS CLOCK IS NOT USED IN THIS PROJECT
			//------------------------------------------------------------------

			input reset_n,            // external reset, active low
			//------------------------------------------------------------------
            // push buttons: button down = logic 1 (no debouncing hw)
			input btnu,			  // button up
			input btnr,           // button right
			input btnd,           // button down
			input btnl,			  // button left
			input btnc,           // button center

			//------------------------------------------------------------------
            // Slide switches:
			input sw0,
			input sw1,
			input sw2,
			input sw3,
			input sw4,
			input sw5,
			input sw6,
			input sw7,

			//------------------------------------------------------------------
			// LEDs: logic 1 lights the LED
			output ld7,			// LED 7 (leftmost)
			output ld6,
			output ld5,
			output ld4,
			output ld3,
			output ld2,
			output ld1,
			output ld0,			// LED 6 (rightmost)


			//------------------------------------------------------------------
			// Serial interface (RS232 port)
            output tx,		// tx data (output from the user circuit)
            input  rx,		// rx data (input to the user circuit)


			//------------------------------------------------------------------
			// Audio codec interface (LM4550)
			input  SDATA_IN,    // serial stream from codec
			output SDATA_OUT,   // serial stream to codec
			output SYNC,        // frame sync
			input  BIT_CLK,     // bit clock (12.288 MHz)
			output RESET_N,     // codec hw reset (active low)
			output SYNC_IN,
			output RESET_S,
			input RESET_STOP,

			//------------------------------------------------------------------
			// PMOD connector
			output  PMOD1,
			output  PMOD2,
			output  PMOD3,
			output  PMOD4,
			output  PMOD7,
			output  PMOD8,
			output  PMOD9,
			output  PMOD10,

			//------------------------------------------------------------------
			// VHDC differential connector
			output    VHDC1P,
			output    VHDC1N,
			output    VHDC2P,
			output    VHDC2N,
			output    VHDC3P,
			output    VHDC3N,
			output    VHDC4P,
			output    VHDC4N,
			output    VHDC5P,
			output    VHDC5N,
			output    VHDC6P,
			output    VHDC6N,
			output    VHDC7P,
			output    VHDC7N,
			output    VHDC8P,
			output    VHDC8N,
			output    VHDC9P,
			output    VHDC9N,
			output    VHDC10P,
			output    VHDC10N,
			output    VHDC11P,
			output    VHDC11N,
			output    VHDC12P,
			output    VHDC12N,
			output    VHDC13P,
			output    VHDC13N,
			output    VHDC14P,
			output    VHDC14N,
			output    VHDC15P,
			output    VHDC15N,
			output    VHDC16P,
			output    VHDC16N,
			output    VHDC17P,
			output    VHDC17N,
			output    VHDC18P,
			output    VHDC18N,
			output    VHDC19P,
			output    VHDC19N,
			output    VHDC20P,
			output    VHDC20N

			);

			assign SYNC_IN=DIN_RDY;


// VHDC bus (for routing signals to primary outputs):
wire [39:0] VHDC;
assign
   { VHDC1P,  VHDC1N, VHDC2P, VHDC2N, VHDC3P, VHDC3N, VHDC4P, VHDC4N,
     VHDC5P,  VHDC5N, VHDC6P, VHDC6N, VHDC7P, VHDC7N, VHDC8P, VHDC8N,
     VHDC9P,  VHDC9N,  VHDC10P, VHDC10N, VHDC11P, VHDC11N, VHDC12P, VHDC12N,
     VHDC13P, VHDC13N, VHDC14P, VHDC14N, VHDC15P, VHDC15N, VHDC16P, VHDC16N,
     VHDC17P, VHDC17N, VHDC18P, VHDC18N, VHDC19P, VHDC19N, VHDC20P, VHDC20N
   } = VHDC;

// assign unused outputs to zero.
assign VHDC =40'd0;

assign PMOD1 = 1'd0;
assign PMOD2 = 0;
assign PMOD3 = 0;
assign PMOD4 = 0;
assign PMOD5 = 0;
assign PMOD6 = 0;
assign PMOD7 = 0;
assign PMOD8 = 0;
assign PMOD9 = 0;
assign PMOD10 = 0;

// join the 8 slide switch inputs to an 8-bit bus:
wire [7:0] slide_switches;
assign slide_switches = {sw7, sw6, sw5, sw5, sw4, sw3, sw2, sw1, sw0};

//---------------------------------------------------
// global synchronous reset, active high
reg			reset_d, reset;

//---------------------------------------------------
// UART local signals:
wire        txen, rxready, txready;

//---------------------------------------------------
// data bus between UART and the I/O ports module:
wire [ 7:0] din, dout;

//---------------------------------------------------
// General 32-bit I/O ports:
// output ports (32 bits)
wire [31:0] P0out, P1out, P2out, P3out,
            P4out, P5out, P6out, P7out,
			P8out, P9out, PAout, PBout,
			PCout, PDout, PEout, PFout;
// input ports (32 bits)
wire [31:0] P0in,  P1in,  P2in,  P3in,
            P4in,  P5in,  P6in,  P7in;


// Main clock:
wire clock;
assign clock = BIT_CLK;



//---------------------------------------------------
// Reset synchronizer:
always @(posedge clock )
begin
    reset_d <= ~reset_n;
    reset   <= reset_d;
end


assign RESET_S=reset;

//---------------------------------------------------
// UART 921600 baud, 8 bit, 1 stop bit, no parity:
uart  #(
         .INPUT_CLOCK_FREQUENCY( 12288000 ),
         .TX_BAUD_RATE( 921_600 ),
		   .RX_BAUD_RATE( 921_600 )
		)
        uart_1
 		   (
             .clock( clock ),	// master clock (12.288 MHz)
             .reset(reset),			// master reset, asynchronous, active high
             .tx(tx),					// tx data, connected to rx input
             .rx(rx),					// rx data, connected to tx output
             .txen(txen),			// load data into transmit buffer and initiate a transmission
             .txready(txready),	// ready to receive a new byte to tx
             .rxready(rxready),	// data is ready at dout port
             .dout(dout),			// data out (received data)
             .din(din)				// data in (data to transmit)
           );

//---------------------------------------------------
// Command interpreter:
ioports16V2018
            #(   // Define initial reset values for the output ports (default is 32'd0)
                 .INIT_P08( { 14'd0, 18'b000010001001010100 } ), // Stepwc = 2.145263671875 (FM freqs  95.00 MHz and 101.60 MHz)
                 .INIT_P09( { 24'd0,  8'b0100_0000 } ),			 // Kf = 4.000
                 .INIT_P10( { 28'd0,  4'b1000 } ),               // Ks = 1.000
                 .INIT_P11( { 28'd0,  4'b1000 } ),			     // Kd = 1.000
                 .INIT_P12( { 28'd0,  4'b0100 } ) 	             // Kp = 0.500
             )

// ioports
 				 ioports16_1
             (
			      .clk( clock ),	// master clock
               .reset(reset),		   // master reset, asynchronous, active high

               .load(rxready),		// load enable for din bus
               .ready(txready),		// ready to consume dout data
               .enout(txen),		   // enable loading of dout data

               .datain(dout),		// data in bus (8 bits), from USART
               .dataout(din),		// data out bus (8 bits), to USART

               .in0(P0in),	.in1(P1in), .in2(P2in), .in3(P3in),
					.in4(P4in), .in5(P5in), .in6(P6in), .in7(P7in),

               .out0(P0out), .out1(P1out), .out2(P2out), .out3(P3out),
			      .out4(P4out), .out5(P5out), .out6(P6out), .out7(P7out),
			      .out8(P8out), .out9(P9out), .outa(PAout), .outb(PBout),
			      .outc(PCout), .outd(PDout), .oute(PEout), .outf(PFout)
			);


//---------------------------------------------------------------------------------
// LM5440 audio CODEC interface
wire [15:0]DIN;
wire [5:0] REGID;
wire [3:0] STATUS;
wire WE, RE, RDY, DIN_RDY, DOUT_RQST;

wire [17:0] LEFT_in, RIGHT_in, LEFT_out, RIGHT_out;

LM4550_controler LM4550_controler_1 (
                .SDATA_IN(SDATA_IN),
                .SDATA_OUT(SDATA_OUT),
                .SYNC(SYNC),
                .BIT_CLK( BIT_CLK ),        // bit clock from audio codec
                .RESET_N( ),                // Reset to external codec
                .DIN(DIN),
                .REGID(REGID),
                .STATUS(STATUS),
                .WE(WE),
                .RE(RE),
                .RDY(RDY),

                .DIN_RDY(DIN_RDY),          // Data input enable
                .RIGHT_IN( RIGHT_in ),      // from codec ADC to FPGA, 18 bit, 48 kHz
                .LEFT_IN( LEFT_in ),

                .DOUT_RQST(DOUT_RQST),     // request for output data to DAC
                .RIGHT_OUT( RIGHT_out ),   // from FPGA to codec DAC, 18 bit, 48 kHz
                .LEFT_OUT( LEFT_out ),

                .RESET(reset),
                .CLOCK( clock )
				);

// Disable CODEC reset:
assign RESET_N = 1'b1;

// assign control signals to access the LM4550 programming interface:
assign DIN=P2out[15:0];
assign REGID=P3out[5:0];
assign P1in={27'b0,STATUS};
assign WE=PFout[0];
assign RE=PFout[1];
assign P2in={31'd0,RDY};



//-------------------------------------------------------------------------------
// Instantiate the RAM holding the FIR coefficients:
wire [6:0]  addr_coefs_r, addr_coefs_l;
wire [17:0] dataout_coefs_r, dataout_coefs_l;

DPRAM #( .MEM_INIT_FILENAME("../simdata/FIR.hex") )

      RAM_coefs_l (

		.clock1(clock),
		// connect to the serial interface:
		.addr1( P6out[6:0] ),
		.we1( PFout[2] ),
		.datain1( P3out[ 17:0] ),
		.dataout1( P3in[ 17:0] ),

	   // Connecto to your circuit:
   	    .clock2(clock),
		.addr2(addr_coefs_l),
		.dataout2(dataout_coefs_l)
	);

DPRAM #( .MEM_INIT_FILENAME("../simdata/FIR.hex") )

	      RAM_coefs_r (

			.clock1(clock),
			// connect to the serial interface:
			.addr1( P6out[6:0] ),
			.we1( PFout[2] ),
			.datain1( P7out[ 17:0] ),
			.dataout1( P7in[ 17:0] ),

		   // Connecto to your circuit:
	   	    .clock2(clock),
			.addr2(addr_coefs_r),
			.dataout2(dataout_coefs_r)
		);

// Sign extend to 32 bits the value read from memory:
assign P7in[31:18] = {14{P7in[17]}};

//CRIAÇAO NOSSA:
wire reset_s;

assign reset_s= RESET_S | RESET_STOP;

//-------------------------------------------------------------------------------
// The example of DSP processing block:
psdi_dsp   psdi_dsp_1(
         .clock( clock),
			.reset( reset_s ),
			.switches( slide_switches ),

			// Interface to the RAM memory holding the FIR coefficients:
			//.RAM_coefs_addr_right( addr_coefs_r ),
			//.RAM_coefs_dataout_right( dataout_coefs_r ),
			//.RAM_coefs_addr_left( addr_coefs_l ),
			//.RAM_coefs_dataout_left( dataout_coefs_l ),
			.RAM_coefs_addr( addr_coefs ), //CASO NAO TENHAMOS DUAS RAMS PARA CADA CHANNEL
			.RAM_coefs_dataout( dataout_coefs ), //CASO NAO TENHAMOS DUAS RAMS PARA CADA CHANNEL

			.data_en( DIN_RDY ),

			.right_in( RIGHT_in ),
			.left_in( LEFT_in ),

			.right_out( RIGHT_out ),
			.left_out( LEFT_out )
		    );




//-------------------------------------------------------------------------------
// Generate the output mono signal rectified to view in the LEDs the
// real-time signal envelope:
wire [18:0] mono_digital_mix;
wire [18:0] mono_digital_mix_rectified;
assign mono_digital_mix =  ( {LEFT_in[17], LEFT_in} + {RIGHT_in[17], RIGHT_in} ) / 2;  // >>> 1
assign mono_digital_mix_rectified = mono_digital_mix[17] ? ( -mono_digital_mix ) : ( mono_digital_mix );


//-------------------------------------------------------------------------------
// display the output signal envelope
assign {ld7, ld6, ld5, ld4, ld3, ld2, ld1, ld0} = mono_digital_mix_rectified[17:10];



//---------------------------------------------------------------------------------
// Connect P0in to the push buttons and slide switches:
assign P0in[31:21] = 32'd0;
assign P0in[20:16] = {btnu, btnr, btnd, btnl, btnc };
assign P0in[15: 8] = 8'd0;
assign P0in[ 7: 0] = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};

// Unused input ports
//assign P3in[31:24]  = 32'd0;
assign P4in[31:18]  = 32'd0;
assign P5in[31:24]  = 32'd0;
assign P6in[31:24]  = 32'd0;
//assign P7in[31:24]  = 32'd0;
//---------------------------------------------------------------------------------
endmodule





/*   //TOP CODIGO ORIGINAL

`timescale 1ns/1ps

module s6base_top(
			//------------------------------------------------------------------
			// Gobal external signals:
			input clockext100MHz,	  // master clock input (external oscillator 100MHz) THIS CLOCK IS NOT USED IN THIS PROJECT
			//------------------------------------------------------------------

			input reset_n,            // external reset, active low
			//------------------------------------------------------------------
            // push buttons: button down = logic 1 (no debouncing hw)
			input btnu,			  // button up
			input btnr,           // button right
			input btnd,           // button down
			input btnl,			  // button left
			input btnc,           // button center

			//------------------------------------------------------------------
            // Slide switches:
			input sw0,
			input sw1,
			input sw2,
			input sw3,
			input sw4,
			input sw5,
			input sw6,
			input sw7,

			//------------------------------------------------------------------
			// LEDs: logic 1 lights the LED
			output ld7,			// LED 7 (leftmost)
			output ld6,
			output ld5,
			output ld4,
			output ld3,
			output ld2,
			output ld1,
			output ld0,			// LED 6 (rightmost)


			//------------------------------------------------------------------
			// Serial interface (RS232 port)
            output tx,		// tx data (output from the user circuit)
            input  rx,		// rx data (input to the user circuit)


			//------------------------------------------------------------------
			// Audio codec interface (LM4550)
			input  SDATA_IN,    // serial stream from codec
			output SDATA_OUT,   // serial stream to codec
			output SYNC,        // frame sync
			input  BIT_CLK,     // bit clock (12.288 MHz)
			output RESET_N,     // codec hw reset (active low)


			//------------------------------------------------------------------
			// PMOD connector
			output  PMOD1,
			output  PMOD2,
			output  PMOD3,
			output  PMOD4,
			output  PMOD7,
			output  PMOD8,
			output  PMOD9,
			output  PMOD10,

			//------------------------------------------------------------------
			// VHDC differential connector
			output    VHDC1P,
			output    VHDC1N,
			output    VHDC2P,
			output    VHDC2N,
			output    VHDC3P,
			output    VHDC3N,
			output    VHDC4P,
			output    VHDC4N,
			output    VHDC5P,
			output    VHDC5N,
			output    VHDC6P,
			output    VHDC6N,
			output    VHDC7P,
			output    VHDC7N,
			output    VHDC8P,
			output    VHDC8N,
			output    VHDC9P,
			output    VHDC9N,
			output    VHDC10P,
			output    VHDC10N,
			output    VHDC11P,
			output    VHDC11N,
			output    VHDC12P,
			output    VHDC12N,
			output    VHDC13P,
			output    VHDC13N,
			output    VHDC14P,
			output    VHDC14N,
			output    VHDC15P,
			output    VHDC15N,
			output    VHDC16P,
			output    VHDC16N,
			output    VHDC17P,
			output    VHDC17N,
			output    VHDC18P,
			output    VHDC18N,
			output    VHDC19P,
			output    VHDC19N,
			output    VHDC20P,
			output    VHDC20N

			);

// VHDC bus (for routing signals to primary outputs):
wire [39:0] VHDC;
assign
   { VHDC1P,  VHDC1N, VHDC2P, VHDC2N, VHDC3P, VHDC3N, VHDC4P, VHDC4N,
     VHDC5P,  VHDC5N, VHDC6P, VHDC6N, VHDC7P, VHDC7N, VHDC8P, VHDC8N,
     VHDC9P,  VHDC9N,  VHDC10P, VHDC10N, VHDC11P, VHDC11N, VHDC12P, VHDC12N,
     VHDC13P, VHDC13N, VHDC14P, VHDC14N, VHDC15P, VHDC15N, VHDC16P, VHDC16N,
     VHDC17P, VHDC17N, VHDC18P, VHDC18N, VHDC19P, VHDC19N, VHDC20P, VHDC20N
   } = VHDC;

// assign unused outputs to zero.
assign VHDC =40'd0;

assign PMOD1 = 1'd0;
assign PMOD2 = 0;
assign PMOD3 = 0;
assign PMOD4 = 0;
assign PMOD5 = 0;
assign PMOD6 = 0;
assign PMOD7 = 0;
assign PMOD8 = 0;
assign PMOD9 = 0;
assign PMOD10 = 0;

// join the 8 slide switch inputs to an 8-bit bus:
wire [7:0] slide_switches;
assign slide_switches = {sw7, sw6, sw5, sw5, sw4, sw3, sw2, sw1, sw0};

//---------------------------------------------------
// global synchronous reset, active high
reg			reset_d, reset;

//---------------------------------------------------
// UART local signals:
wire        txen, rxready, txready;

//---------------------------------------------------
// data bus between UART and the I/O ports module:
wire [ 7:0] din, dout;

//---------------------------------------------------
// General 32-bit I/O ports:
// output ports (32 bits)
wire [31:0] P0out, P1out, P2out, P3out,
            P4out, P5out, P6out, P7out,
			P8out, P9out, PAout, PBout,
			PCout, PDout, PEout, PFout;
// input ports (32 bits)
wire [31:0] P0in,  P1in,  P2in,  P3in,
            P4in,  P5in,  P6in,  P7in;


// Main clock:
wire clock;
assign clock = BIT_CLK;



//---------------------------------------------------
// Reset synchronizer:
always @(posedge clock )
begin
    reset_d <= ~reset_n;
    reset   <= reset_d;
end



//---------------------------------------------------
// UART 921600 baud, 8 bit, 1 stop bit, no parity:
uart  #(
         .INPUT_CLOCK_FREQUENCY( 12288000 ),
         .TX_BAUD_RATE( 921_600 ),
		   .RX_BAUD_RATE( 921_600 )
		)
        uart_1
 		   (
             .clock( clock ),	// master clock (12.288 MHz)
             .reset(reset),			// master reset, asynchronous, active high
             .tx(tx),					// tx data, connected to rx input
             .rx(rx),					// rx data, connected to tx output
             .txen(txen),			// load data into transmit buffer and initiate a transmission
             .txready(txready),	// ready to receive a new byte to tx
             .rxready(rxready),	// data is ready at dout port
             .dout(dout),			// data out (received data)
             .din(din)				// data in (data to transmit)
           );

//---------------------------------------------------
// Command interpreter:
ioports16V2018
            #(   // Define initial reset values for the output ports (default is 32'd0)
                 .INIT_P08( { 14'd0, 18'b000010001001010100 } ), // Stepwc = 2.145263671875 (FM freqs  95.00 MHz and 101.60 MHz)
                 .INIT_P09( { 24'd0,  8'b0100_0000 } ),			 // Kf = 4.000
                 .INIT_P10( { 28'd0,  4'b1000 } ),               // Ks = 1.000
                 .INIT_P11( { 28'd0,  4'b1000 } ),			     // Kd = 1.000
                 .INIT_P12( { 28'd0,  4'b0100 } ) 	             // Kp = 0.500
             )

// ioports
 				 ioports16_1
             (
			      .clk( clock ),	// master clock
               .reset(reset),		   // master reset, asynchronous, active high

               .load(rxready),		// load enable for din bus
               .ready(txready),		// ready to consume dout data
               .enout(txen),		   // enable loading of dout data

               .datain(dout),		// data in bus (8 bits), from USART
               .dataout(din),		// data out bus (8 bits), to USART

               .in0(P0in),	.in1(P1in), .in2(P2in), .in3(P3in),
					.in4(P4in), .in5(P5in), .in6(P6in), .in7(P7in),

               .out0(P0out), .out1(P1out), .out2(P2out), .out3(P3out),
			      .out4(P4out), .out5(P5out), .out6(P6out), .out7(P7out),
			      .out8(P8out), .out9(P9out), .outa(PAout), .outb(PBout),
			      .outc(PCout), .outd(PDout), .oute(PEout), .outf(PFout)
			);


//---------------------------------------------------------------------------------
// LM5440 audio CODEC interface
wire [15:0]DIN;
wire [5:0] REGID;
wire [3:0] STATUS;
wire WE, RE, RDY, DIN_RDY, DOUT_RQST;

wire [17:0] LEFT_in, RIGHT_in, LEFT_out, RIGHT_out;

LM4550_controler LM4550_controler_1 (
                .SDATA_IN(SDATA_IN),
                .SDATA_OUT(SDATA_OUT),
                .SYNC(SYNC),
                .BIT_CLK( BIT_CLK ),        // bit clock from audio codec
                .RESET_N( ),                // Reset to external codec
                .DIN(DIN),
                .REGID(REGID),
                .STATUS(STATUS),
                .WE(WE),
                .RE(RE),
                .RDY(RDY),

                .DIN_RDY(DIN_RDY),          // Data input enable
                .RIGHT_IN( RIGHT_in ),      // from codec ADC to FPGA, 18 bit, 48 kHz
                .LEFT_IN( LEFT_in ),

                .DOUT_RQST(DOUT_RQST),     // request for output data to DAC
                .RIGHT_OUT( RIGHT_out ),   // from FPGA to codec DAC, 18 bit, 48 kHz
                .LEFT_OUT( LEFT_out ),

                .RESET(reset),
                .CLOCK( clock )
				);

// Disable CODEC reset:
assign RESET_N = 1'b1;

// assign control signals to access the LM4550 programming interface:
assign DIN=P2out[15:0];
assign REGID=P3out[5:0];
assign P1in={27'b0,STATUS};
assign WE=PFout[0];
assign RE=PFout[1];
assign P2in={31'd0,RDY};



//-------------------------------------------------------------------------------
// Instantiate the RAM holding the FIR coefficients:
wire [6:0]  addr_coefs;
wire [17:0] dataout_coefs;

DPRAM #( .MEM_INIT_FILENAME("../simdata/FIR.hex") )

      RAM_coefs (

		.clock1(clock),
		// connect to the serial interface:
		.addr1( P6out[6:0] ),
		.we1( PFout[2] ),
		.datain1( P7out[ 17:0] ),
		.dataout1( P7in[ 17:0] ),

	   // Connecto to your circuit:
   	    .clock2(clock),
		.addr2(addr_coefs),
		.dataout2(dataout_coefs)
	);

// Sign extend to 32 bits the value read from memory:
assign P7in[31:18] = {14{P7in[17]}};


//-------------------------------------------------------------------------------
// The example of DSP processing block:
psdi_dsp   psdi_dsp_1(
            .clock( clock),
			.reset( reset | reset_stop ),

			.switches( slide_switches ),

			// Interface to the RAM memory holding the FIR coefficients:
			.RAM_coefs_addr( addr_coefs ),
			.RAM_coefs_dataout( dataout_coefs ),


			.data_en( DIN_RDY ),

			.right_in( RIGHT_in ),
			.left_in( LEFT_in ),

			.right_out( RIGHT_out ),
			.left_out( LEFT_out ),
			
			.downsample_freq (downsample_freq)			//LINHA PARA LIGAR AO DOWNSAMPLE
		    );


//-------------------------------------------------------------------------------
// Generate the output mono signal rectified to view in the LEDs the
// real-time signal envelope:
wire [18:0] mono_digital_mix;
wire [18:0] mono_digital_mix_rectified;
assign mono_digital_mix =  ( {LEFT_in[17], LEFT_in} + {RIGHT_in[17], RIGHT_in} ) / 2;  // >>> 1
assign mono_digital_mix_rectified = mono_digital_mix[17] ? ( -mono_digital_mix ) : ( mono_digital_mix );


//-------------------------------------------------------------------------------
// display the output signal envelope
assign {ld7, ld6, ld5, ld4, ld3, ld2, ld1, ld0} = mono_digital_mix_rectified[17:10];



//---------------------------------------------------------------------------------
// Connect P0in to the push buttons and slide switches:
assign P0in[31:21] = 32'd0;
assign P0in[20:16] = {btnu, btnr, btnd, btnl, btnc };
assign P0in[15: 8] = 8'd0;
assign P0in[ 7: 0] = {sw7, sw6, sw5, sw4, sw3, sw2, sw1, sw0};

// Unused input ports
assign P3in[31:24]  = 32'd0;
assign P4in[31:18]  = 32'd0;
assign P5in[31:24]  = 32'd0;
assign P6in[31:24]  = 32'd0;
//assign P7in[31:24]  = 32'd0;
//---------------------------------------------------------------------------------



endmodule
*/