/*

    jca@fe.up.pt

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
	General purpose I/O ports (32 bits)
	output port "outf" has automatic return to zero after 4 clock cycles
	
	This is the version for PSD 2016/2017: includes the automatic addressing for 
	loading the 2 x 16k x 36 bit coefficient memory.
 
 */
`timescale 1ns/1ps

module ioports16V2018( clk,    // master clock 
                reset,  // master reset, synchronous, active high
                load,   // load enable for din bus
                ready,  // ready to consume dout data
                enout,  // enable loading of dout data
                datain, // data in bus (8 bits)
                dataout,// data out bus (8 bits)
                in0,    // 8 32-bit input ports
                in1,    
                in2,    
                in3,    
                in4,    
                in5,    
                in6,    
                in7,    
                out0,   // 16 32-bit output ports
                out1, 
                out2, 
                out3, 
  			       out4, 
				    out5,   
				    out6,
				    out7,
				    out8,   
				    out9,   
				    outa,
				    outb,
				    outc,   
				    outd,   
				    oute,
				    outf    // port f has automatic return to zero after N clock cycles
				            // N is configured with parameter OUT15_DELAY_OUT (default is 1)
				
           );

// Reset values:					 
parameter INIT_P00 = 32'd0,
          INIT_P01 = 32'd0,					 
          INIT_P02 = 32'd0,					 
          INIT_P03 = 32'd0,					 
          INIT_P04 = 32'd0,					 
          INIT_P05 = 32'd0,					 
          INIT_P06 = 32'd0,					 
          INIT_P07 = 32'd0,					 
          INIT_P08 = 32'd0,
          INIT_P09 = 32'd0,					 
          INIT_P10 = 32'd0,					 
          INIT_P11 = 32'd0,					 
          INIT_P12 = 32'd0,					 
          INIT_P13 = 32'd0,					 
          INIT_P14 = 32'd0,					 
          INIT_P15 = 32'd0,
			 
		  OUT15_DELAY_OUT = 32'd3;

parameter ATLYS_HWID = 32'h2016_1702;			 

input        clk, reset, load, ready;
output       enout;
input  [7:0] datain;
output [7:0] dataout;

input  [31:0] in0, in1, in2, in3, 
              in4, in5, in6, in7;
output [31:0] out0, out1, out2, out3,
              out4, out5, out6, out7,
              out8, out9, outa, outb,
              outc, outd, oute, outf;
				  

// Registers:
reg    [5:0]  state;
reg    [31:0] out0, out1, out2, out3,
              out4, out5, out6, out7,
              out8, out9, outa, outb,
              outc, outd, oute, outf;
reg    [7:0]  dataout;
reg    [7:0]  byte3, byte2, byte1;
reg    [3:0]  nibble4;
reg           enout;
reg    [3:0]  address;
reg    [31:0] datatoout;
reg    [35:0] datatoout36;




// State encoding:
parameter IDLE       = 5'b0,
          WRITECMD   = 5'd1,
          WRITECMD2  = 5'd2,
          WRITECMD3  = 5'd3,
          WRITECMD4  = 5'd4,
          READCMD    = 5'd5,
          READCMD2   = 5'd6,
          READCMD3   = 5'd7,
          READCMD4   = 5'd8,
          READCMD5   = 5'd9,
          READCMD6   = 5'd10,
          READCMD7   = 5'd11,
          READCMD8   = 5'd12,
			 
		    DELAY0     = 5'd13,
		    DELAY1     = 5'd14,
		    DELAY2     = 5'd15,
		    DELAY3     = 5'd16;


// Commands:
parameter RESET      = 3'b001,
          WRITE      = 3'b010,
          READ       = 3'b011,
			 XXXXXX     = 3'b111;



always @(posedge clk)
begin
  if ( reset )
  begin
    out0 <= INIT_P00;
    out1 <= INIT_P01;
    out2 <= INIT_P02;
    out3 <= INIT_P03;
    out4 <= INIT_P04;
    out5 <= INIT_P05;
    out6 <= INIT_P06;
    out7 <= INIT_P07;
    out8 <= INIT_P08;
    out9 <= INIT_P09;
    outa <= INIT_P10;
    outb <= INIT_P11;
    outc <= INIT_P12;
    outd <= INIT_P13;
    oute <= INIT_P14;
    outf <= INIT_P15;
	 
    enout <= 0;
	 byte3 <= 0;
	 byte2 <= 0;
	 byte1 <= 0;
	
	 state <= IDLE; 

  end
  else
  begin
    case ( state )
      IDLE :        begin
                      if ( load )
                        case ( datain[6:4] ) // command
                          RESET : begin      // 001
                                    out0 <= INIT_P00;
                                    out1 <= INIT_P01;
                                    out2 <= INIT_P02;
                                    out3 <= INIT_P03;
                                    out4 <= INIT_P04;
                                    out5 <= INIT_P05;
                                    out6 <= INIT_P06;
                                    out7 <= INIT_P07;
                                    out8 <= INIT_P08;
                                    out9 <= INIT_P09;
                                    outa <= INIT_P10;
                                    outb <= INIT_P11;
                                    outc <= INIT_P12;
                                    outd <= INIT_P13;
                                    oute <= INIT_P14;
                                    outf <= INIT_P15;
												
                                    enout <= 0;
                                    state <= IDLE;
                                  end
											 
                          WRITE : begin   // 010
                                    address <= datain[3:0]; // address of port
                                    state <= WRITECMD;
                                  end
											 
                          READ  : begin   // 011
                                    case ( datain[3:0] )
                                      4'd0: datatoout <= in0;
                                      4'd1: datatoout <= in1;
                                      4'd2: datatoout <= in2;
                                      4'd3: datatoout <= in3;
                                      4'd4: datatoout <= in4;
                                      4'd5: datatoout <= in5;
                                      4'd6: datatoout <= in6;
                                      4'd7: datatoout <= in7;
									           default: datatoout <= ATLYS_HWID;
                                    endcase
                                    state <= READCMD;
                                  end
	 
 						        default : state <= IDLE;
                        endcase
                      else
                        state <= IDLE;
                    end
                    
      WRITECMD:     begin
                     if ( load )           // byte 3 arrived
                     begin
                       byte3 <= datain;       // load byte
                       state <= WRITECMD2;
                     end
                     else
                     begin
                       state <= WRITECMD;  // keep waiting for MS byte
                     end
                    end
					
     WRITECMD2:    begin
                     if ( load )           // byte 2 arrived
                     begin
                       byte2 <= datain;       // load byte 
                       state <= WRITECMD3;
                     end
                     else
                     begin
                       state <= WRITECMD2;  // keep waiting
                     end
                    end

	  WRITECMD3:    begin
                     if ( load )           // byte 1 arrived
                     begin
                       byte1 <= datain;       // load byte 
                       state <= WRITECMD4;
                     end
                     else
                     begin
                       state <= WRITECMD3;  // keep waiting 
                     end
                    end
                    
                    
     WRITECMD4   : begin
                     if ( load )           // LSbyte arrived
                     begin
                       case ( address )
                         0 : out0 <= {byte3, byte2, byte1, datain};
                         1 : out1 <= {byte3, byte2, byte1, datain};
                         2 : out2 <= {byte3, byte2, byte1, datain};
                         3 : out3 <= {byte3, byte2, byte1, datain};
                         4 : out4 <= {byte3, byte2, byte1, datain};
                         5 : out5 <= {byte3, byte2, byte1, datain};
                         6 : out6 <= {byte3, byte2, byte1, datain};
                         7 : out7 <= {byte3, byte2, byte1, datain};
                         8 : out8 <= {byte3, byte2, byte1, datain};
                         9 : out9 <= {byte3, byte2, byte1, datain};
                         10: outa <= {byte3, byte2, byte1, datain};
                         11: outb <= {byte3, byte2, byte1, datain};
                         12: outc <= {byte3, byte2, byte1, datain};
                         13: outd <= {byte3, byte2, byte1, datain};
                         14: oute <= {byte3, byte2, byte1, datain};
                         15: outf <= {byte3, byte2, byte1, datain};
                       endcase
							  
					        if ( address == 4'hF )
							  begin
					          case ( OUT15_DELAY_OUT )
						         32'd1: state <= DELAY3;  // wait 1 clock cycle
						         32'd2: state <= DELAY2;  // wait 2 clock cycles
						         32'd3: state <= DELAY1;  // wait 3 clock cycles
						         32'd4: state <= DELAY0;  // wait 4 clock cycles
							      default: state <= IDLE; // no auto return to zero
						       endcase
							  end
							  else
							    state <= IDLE;
							end
					     else
                      state <= WRITECMD4;  // keep waiting for LS byte
                  end
					
      DELAY0      : state <= DELAY1;					
                    
      DELAY1      : state <= DELAY2;					
                    
      DELAY2      : state <= DELAY3;					
                    
      DELAY3      : begin
	                  outf <= 0;
	                  state <= IDLE;					
					     end
                    
      READCMD     : begin
                      if ( ready )
                      begin
                        dataout <= datatoout[31:24]; // output byte 3
                        enout <= 1;
                        state <= READCMD2;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD;  // wait for ready
                      end
                    end
                    
      READCMD2    : begin              // wait for ready low
                      if ( ready )
                      begin
                        enout <= 1;    // keep enout active until ready is deasserted
                        state <= READCMD2;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD3;
                      end
                    end
                      
      READCMD3    : begin
                      if ( ready )
                      begin
                        dataout <= datatoout[23:16]; // output byte 2
                        enout <= 1;
                        state <= READCMD4;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD3;  // wait for ready
                      end
                    end
                    
      READCMD4    : begin              // wait for ready low
                      if ( ready )
                      begin
                        enout <= 1;    // keep enout active until ready is deasserted
                        state <= READCMD4;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD5;
                      end
                    end
                      
      READCMD5    : begin
                      if ( ready )
                      begin
                        dataout <= datatoout[15:8]; // output byte 1
                        enout <= 1;
                        state <= READCMD6;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD5;  // wait for ready
                      end
                    end
                    
      READCMD6    : begin              // wait for ready low
                      if ( ready )
                      begin
                        enout <= 1;    // keep enout active until ready is deasserted
                        state <= READCMD6;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD7;
                      end
                    end
                      
      READCMD7    : begin
                      if ( ready )
                      begin
                        dataout <= datatoout[7:0]; // output byte 0
                        enout <= 1;
                        state <= READCMD8;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= READCMD7;  // wait for ready
                      end
                    end
                    
      READCMD8    : begin              // wait for ready low
                      if ( ready )
                      begin
                        enout <= 1;    // keep enout active until ready is deasserted
                        state <= READCMD8;
                      end
                      else
                      begin
                        enout <= 0;
                        state <= IDLE;
                      end
                    end
						  				   						   						   						   						  
      default     : begin
                      state <= IDLE;
                    end
    endcase
  end
end


endmodule

