

//-------------------------------------------------------------------
//
// Tasks to read/write the ioports interface:
//
// Write 32bit data to a port:
task WritePort;
input [31:0] data;
input [3:0]  port;
begin
  // send command WRITE:
  SendData( { 4'b0010, port } );
  // send data:
  SendData( data[31:24] );
  SendData( data[23:16] );
  SendData( data[15:8] );
  SendData( data[7:0] );
end
endtask


// read 32 bit data from a port:
task ReadPort;
output [31:0] data;
input  [3:0]  port;
reg [7:0] b3, b2, b1, b0;
begin
  // send command READ:
  SendData( { 4'b0011, port } );
  GetData( b3 );
  GetData( b2 );
  GetData( b1 );
  GetData( b0 );
  data = { b3, b2, b1, b0};
end
endtask



// Send one byte to the UART, wait for the end of transmission:
task SendData;
input [7:0] data;
begin
 #50
 uart_din = data; // set value at the UART input databus
 @(negedge BIT_CLK );
 uart_txen = 1; // start transmission
 #1
 @(posedge BIT_CLK );
 uart_txen = 0;
 @( posedge uart_txready ) // wait for the end of transmission
 #50; // wait more...
end
endtask

task GetData;
output [7:0] data;
begin
  # 50
  @(negedge BIT_CLK );
  #1
  // wait for a new byte received:
  while( uart_rxready == 1'b0 )
    @(negedge BIT_CLK );
  data = uart_dout;
  #50;
end
endtask


task print_pass;
begin
     $display("-------------------------------------------------------"); 
     $display("");
     $display("          #####     ##     ####    ####"); 
     $display("          #    #   #  #   #       #"); 
     $display("          #    #  #    #   ####    ####"); 
     $display("          #####   ######       #       #"); 
     $display("          #       #    #  #    #  #    #"); 
     $display("          #       #    #   ####    ####"); 
     $display("");
     $display("-------------------------------------------------------\n"); 
end
endtask

task print_fail;
     input integer errors;
begin
     $display("-------------------------------------------------------"); 
     $display("");
     $display("          ######    ##       #    #"); 
     $display("          #        #  #      #    #"); 
     $display("          #####   #    #     #    #"); 
     $display("          #       ######     #    #"); 
     $display("          #       #    #     #    #"); 
     $display("          #       #    #     #    ######"); 
     $display("");
     $display("-------------------------------------------------------\n"); 
     $display(" ***************   %3d errors found    ****************", errors );
     $display("-------------------------------------------------------\n"); 
end
endtask

  
task finalize_simulation;
begin
  if ( error_count > 0 )
    print_fail( error_count );
  else
    print_pass();
	
  // Close open files
  $fclose( fpout );
  
  $stop;
end
endtask



//-------------------------------------------------------------------------------------

