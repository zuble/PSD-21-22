`timescale 1ns / 1ps

module tb;

initial
begin
  $dumpfile("mysimdata.vcd");// The filename with the waveform data
  $dumpvars(0, tb ); // The root node to dump end
end

// General parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)

reg clock, reset, start, regwen;
reg cnstA, cnstB, enrregA, enrregB;

reg [63:0]  in;
reg [ 3:0]  selwreg;
reg [ 1:0]  endwreg;

reg [ 3:0]  seloutA,
            seloutB;

reg [4:0] opr;

wire [63:0] banq_outA,
            banq_outB;

wire done;

wire [63:0] alu_out;

reg [63:0]  outA_aux,
            outB_aux;


reg_banq reg_banq0(  
  .clock( clock ), 
  .reset( reset ), 
  .regwen( regwen ),
  .inA( in ),
  .selwreg( selwreg ),
  .endwreg( endwreg ),
  .outA( banq_outA ),
  .outB( banq_outB ),
  .seloutA( seloutA ),
  .seloutB( seloutB ), 
  .cnstA( cnstA ),
  .cnstB( cnstB ), 
  .enrregA( enrregA ),
  .enrregB( enrregB )
);


alu alu0(
  .clock(clock),              
  .reset(reset),             
  .inA(outA_aux),            
  .inB(outB_aux),                  
  .opr(opr),                   
  .start(start),          
  .outAB(alu_out),                    
  .done(done)
);


//---------------------------------------------------
// Setup initial signals
initial
begin
  clock   = 1'b0;
  reset   = 1'b0;
  start   = 1'b1;
  in_aux  = 64'b1;
  regwen  = 1'b0;
  cnstA   = 1'b0;
  cnstB   = 1'b0;
  enrregA = 1'b0;
  enrregB = 1'b0;
  opr     = 5'b0000;          // 0000 = A; 0001 = B; 0010 = sum; 0011 = sub; ...
end

//---------------------------------------------------
// Generate a 50% duty-cycle clock signal
initial
begin  
    forever
        # (CLOCK_PERIOD / 2 ) clock = ~clock;
end


// Apply reset:
initial
begin
	#10
	reset = 0; 
end

//----------------------------------------------------
// Test the inputs and outputs of the register bank
integer i;
reg [ 3:0] i_aux;
reg [63:0] in_aux;
initial
begin
    //in_aux = 1111;


    for (i=0; i<16; i=i+1)
    begin
        #10
        endwreg = 2'b00;      // reg_vec <= inA || inA,reg_vec || reg_vec,inA || inA flipped
        enrregA = 1'b1;       // enable outA read
        enrregB = 1'b1;       // enable outB read
        cnstA = 1'b0;         // defines if outA reads from cnst_vec or reg_vec 
        cnstB = 1'b0;         // defines if outB reads from cnst_vec or reg_vec 
        opr = 5'b00010;        // 0000 = A; 0001 = B; 0010 = sum; 0011 sub; ...
        i_aux = i;            // iterates over the 16 reg pos
        
        execbr(in_aux, i_aux);
        
        #10
        outA_aux = banq_outA;
        outB_aux = banq_outB;
        $display("Obtained: %d", alu_out);
        in_aux = in_aux+'b10000;
    end
    //$stop
    $finish;

end

task execbr;
  input [63:0] inA;
  input [ 3:0] i;

  begin
    in = inA;               // applys banq inA
    @(posedge clock);
    selwreg = i;            // selects [1,16] reg to write
    regwen = 1'b1;          // enable write from inA to banq
    #10
    @(negedge clock);
    regwen = 1'b0;          // disable write to banq
    seloutA = i;    
    seloutB = i;             
  end  
endtask


endmodule
