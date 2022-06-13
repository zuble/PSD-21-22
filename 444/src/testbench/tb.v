/* 
    PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
    responsible to test if the input number is 
    corretly stored in the selected register 
    by comparing the input word, 20+20i, 
    with the corresponding selected register,
    in a for cycle trough the 16 registers


*/

`timescale 1ns / 1ps

module testbench;

initial
begin
  $dumpfile("mysimdata.vcd");// The filename with the waveform data
  $dumpvars(0, testbench ); // The root node to dump end
end

// General parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)


// reg_bank variables
reg clock, reset, start, regwen;
reg cnstA, cnstB, enrregA, enrregB;

reg [63:0]  in;
reg [ 3:0]  selwreg;
reg [ 1:0]  endwreg;

reg [ 3:0]  seloutA,
            seloutB,
            opr;

wire [63:0] outA,
            outB;


// alu variables
wire [63:0] result;
wire done;

reg [63:0]  inA_Alu,
            inB_Alu;
reg maxclock;


// rec2pol variables
reg enable;
reg [31:0] x0;
reg [31:0] y0;

wire signed [31:0] polMod;
wire signed [31:0] polAngle;


// reg_bank module initiation
reg_bank reg_bank_tb(  
  .clock( clock ), 
  .reset( reset ), 
  .regwen( regwen ),
  .inA( in ),
  .selwreg( selwreg ),
  .endwreg( endwreg ),
  .outA( outA ),
  .outB( outB ),
  .seloutA( seloutA ),
  .seloutB( seloutB ), 
  .cnstA( cnstA ),
  .cnstB( cnstB ), 
  .enrregA( enrregA ),
  .enrregB( enrregB )
);

// alu module initiation
alu alux_tb(
  .clock( clock ),              
  .reset( reset ),             
  .inA( inA_Alu ),            
  .inB( inB_Alu ),                  
  .opr( opr ),                   
  .start( start ),          
  .out_alu( result ),                    
  .done( done )
);

// rec2pol module initiation
rec2pol r2p (
  .clock(clock), 
  .reset(reset), 
  .enable(enable), 
  .start(start), 
  .x(x0), 
  .y(y0), 
  .mod( polMod ), 
  .angle( polAngle )
);



// Setup initial signals
initial begin
  clock = 1'b0;
  reset = 1'b0;
  start = 1'b1;
  in_aux = 64'b0;
  regwen = 1'b0;
  cnstA = 1'b0;
  cnstB = 1'b0;
  enrregA = 1'b0;
  enrregB = 1'b0;
  opr =0000;         
  maxclock = 1'b1;
end


// Generate a 50% duty-cycle clock signal
initial begin  
  forever 
  # (CLOCK_PERIOD / 2 ) clock = ~clock;
end


// Reset
initial begin
	#10
	reset = 0; 
end



//----------------------------------------------------
integer j;
reg [ 3:0]  i_aux;
reg [63:0]  in_aux;
reg [31:0]  Real,
            Im;

initial begin

  Real  = 16'b10100;  //20
  Im    = 16'b10100;  //20i

  in_aux = {Real ,Im };

  
  begin
    #10
    endwreg = 2'b0;
    enrregA = 1'b1;
    enrregB = 1'b1;    
    cnstA = 1'b0;
    cnstB = 1'b0; 
    opr = 0002;          
    maxclock = 1'b1;

    
    // REG_BANK
    @(posedge clock);
    in = in_aux;  
    regwen = 1'b1;
    selwreg = 0;
    #10
    @(negedge clock);
    regwen = 1'b0;   
    seloutA = 0;
    seloutB = 0; 

    
    #10
    inA_Alu = outA;
    inB_Alu = outB;

    //----------------------------------------------------  
    $display("\nSAIDA IGUAL A:");
    execAlu(inA_Alu, inB_Alu, 0);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d+%d i,",  result[63:32], result[31:0]);

    //----------------------------------------------------
    $display("\nSAIDA IGUAL B:");
    execAlu(inA_Alu, inB_Alu, 1);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d+%d i,",  result[63:32], result[31:0]);    

    //----------------------------------------------------
    $display("\nSOMA:");
    execAlu(inA_Alu, inB_Alu, 2);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d+%d i,",  result[63:32], result[31:0]);    

    //----------------------------------------------------
    $display("\nSUBTRACAO:");
    execAlu(inA_Alu, inB_Alu, 3);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d+%d i,",  result[63:32], result[31:0]);    
    
    //----------------------------------------------------
    $display("\nMULTIPLICACAO CMPLX:");
    execAlu(inA_Alu, inB_Alu, 4);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d+%d i,",  result[63:32], result[31:0]);    
    
    //----------------------------------------------------
    $display("\nDIVISAO CMPLX:");
    execAlu(inA_Alu, inB_Alu, 5);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d,",  result[63:32], result[31:0]);    

    //----------------------------------------------------
    $display("\nMULTIPLICACAO REAL:");
    execAlu(inA_Alu, inB_Alu, 6);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d",  result[31:0]);    

    //----------------------------------------------------
    $display("\nDIVISAO REAL:");
    execAlu(inA_Alu, inB_Alu, 7);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);
    $display("result: %d",  result[31:0]);    
      
    //----------------------------------------------------
    $display("\nCOMPARACAO:");
    execAlu(inA_Alu, inB_Alu, 8);
    $display("Initial: %d+%d i,", in[63:32], in[31:0]);
    $display("in AluA: %d+%d i,", inA_Alu[63:32], inA_Alu[31:0]);
    $display("in AluB: %d+%d i,",  inB_Alu[63:32], inB_Alu[31:0]);
    $display("opr: %d,", opr);        
      
      if (result == 1)
      begin
        $display("OS NUMEROS SÃO IGUAIS");
      end
      else
      begin
        $display("OS NUMEROS SÃO DIFERENTES");
      end
    
    //----------------------------------------------------
    $display("\nRECTANGULAR->POLAR A:");
    execcordic(inA_Alu[63:32], inA_Alu[31:0]);

    //----------------------------------------------------
    $display("\nRECTANGULAR->POLAR B:");
    execcordic(inB_Alu[63:32], inB_Alu[31:0]);

  end
  $finish;

end


//----------------------------------------------------
// alu module test task
task execAlu;
  input [63:0] inA;
  input [63:0] inB;
  input [3:0] operation;
  
  begin
    inA_Alu = inA;  
    inB_Alu = inB; 
    opr = operation;  

    @(posedge clock);
    start = 1'b1;
    #10
    @(negedge clock);
    start = 1'b0;  
  end
endtask



//---------------------------------------------------
// rec2pol module test task

// CORDIC variables
real fracfactor = 1<<16;
real fracfactorangle = 1<<24;
real PI = 3.1415926536;
real Xr, Yr; 
real real_mod, real_atan, err_mod, err_atan;

task execcordic;
  input signed [31:0] X;
  input signed [31:0] Y;
  begin
    //x0 = X; //LOAD REC2POOL REAL INPUT 
    //y0 = Y; //LOAD REC2POOL IMAG INPUT 
    x0 = {X,16'd0};
	  y0 = {Y,16'd0};
    
    start = 1;
    enable = 1;
    @(negedge clock);
    start = 0;
    
    repeat( 32 )
    @(negedge clock);
    
    enable = 0;
    
    // Wait some clocks to separate the calls to the task
    repeat( 10 )
    @(negedge clock);
    
    begin  
    // Calculate the expected results:
      Xr = X;
      Yr = Y;
      real_mod = $sqrt( Xr*Xr+Yr*Yr);
      real_atan = $atan2(Yr,Xr) * 180 / PI;
      err_mod = 100 * ( real_mod - (polMod / fracfactor) ) / ( polMod / fracfactor);
      err_atan = 100 * ( real_atan - (polAngle / fracfactorangle) ) / (polAngle / fracfactorangle);
      
      $display("Xi=%d, Yi = %d\npolMod=%f polAngle=%f drg\nExpMod=%f ExpAngle=%f drg (ERRORs = %f%% %f%%)",
                  X, Y, polMod / fracfactor, polAngle / fracfactorangle,
                  real_mod, real_atan, err_mod, err_atan );	
    end
  end

endtask


endmodule


