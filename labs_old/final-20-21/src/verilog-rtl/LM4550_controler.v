`timescale 1ns/1ps

module LM4550_controler(
                SDATA_IN,
                SDATA_OUT,
                SYNC,
                BIT_CLK,
                RESET_N,
                DIN,
                REGID,
                STATUS,
                WE,
                RE,
                RDY,
                DIN_RDY,
                RIGHT_IN,
                LEFT_IN,
                DOUT_RQST,
                RIGHT_OUT,
                LEFT_OUT,
                RESET,
                CLOCK);
                
  input WE,RE,RESET,CLOCK,BIT_CLK;
  input [5:0]REGID;//especifica q registo é para escrever
  input [15:0]DIN;//data para configurar registos do codec so escreve qnd WE esta activo
  input [17:0] RIGHT_OUT,LEFT_OUT;//Sinais de audio para o DAC do codec
  input SDATA_IN;//serial data vinda do codec interface de leitura com o codec 256 bits pra ler
  
  output [3:0]STATUS;//estados dos registos de configuração do codec
  output RDY;//restrição de leitura e escrita no registo de configuraçao
  output DIN_RDY;//diz que uma nova amostra de audio(LEFT_IN,RIGHT_IN) se encotra pronta a ser utilizada
  output [17:0]RIGHT_IN,LEFT_IN;//amostras de audio
  output DOUT_RQST;//bit que simboliza uma nova amostra de audio para ser mandada para o codec
  output SDATA_OUT;//data serie para ser enviado para o codec 
  output SYNC;// sinal de sincronismo 
  output RESET_N; //sinal de reset para o codec active low
  
//Inputs Outputs cm o codec
wire WE,RE;
wire BIT_CLK;
wire [5:0] REGID;
wire [15:0] DIN;
wire [17:0]RIGHT_OUT,LEFT_OUT;
wire SDATA_IN;

//Inputs Outputs 
wire [3:0] STATUS;
reg RDY,DIN_RDY;
wire [17:0] RIGHT_IN,LEFT_IN;
wire DOUT_RQST;
wire SDATA_OUT;//<-----devia ser wire
reg SYNC;
wire RESET_N;


assign RESET_N=(~ RESET);//


//###############################FSM PARA GERAÇÂO Do SYNC#############################
reg [1:0] STATE,NEXTSTATE;
integer count;
parameter INI =2'b00,
          S1=2'b01,
          S2=2'b10;

always @(posedge BIT_CLK)//OR POSEDGE RESETR
  begin
   if(RESET)
        STATE<=INI;
    else
      STATE<=NEXTSTATE;
  end

always @(posedge BIT_CLK)
if ( RESET )
  NEXTSTATE <= INI;
else
   case(STATE)
      INI:
			NEXTSTATE<=S1;
      S1:
        if(count==14)
			NEXTSTATE<=S2;
	S2:
		if(count==255)
			NEXTSTATE<=S1;
		
	endcase

  always @(posedge BIT_CLK)
  if ( RESET )
  begin
    SYNC<=0;
    count<=0;
  end 
  else
     case(STATE)
       INI:
           begin
              SYNC<=0;
              count<=0;
            end
        S1:begin
            SYNC<=1;
            count<=count+1;
           end
        S2: 
			if(count==256)
                begin
			          count<=1;
			           SYNC<=1;
			    end
            else
              begin
               SYNC<=0;
               count<=count+1;
              end
   endcase

////FSM PARA RECEBER ENVIAR DADOS CODEC////////////////////
reg SYNC_REGISTER_READY;
wire POSEDGE_SYNC_REGISTER,NEGEDGE_SYNC_REGISTER;
reg DELAY_SYNC1,DELAY_SYNC2,DELAY_SYNC_REGISTER,SYNC_REGISTER,DELAY_SYNC_REGISTER2;
wire NEGEDGE_SYNC;
reg [3:0] STATUS_REG;
wire POSEDGE_SYNC;//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<tava wire




 //-----------------------------------------------------------------------------------------------------------------
 //enviar e receber os bits em serie
reg [255:0] DATA_RECEIVED;
reg [255:0] DATA_TO_SEND;
reg [255:0] OUT_SHIFT, IN_SHIFT;
 
 always @(posedge BIT_CLK)
	begin
		if(RESET)
				begin
					OUT_SHIFT<=0;
				end
		else if(POSEDGE_SYNC)
				begin
					OUT_SHIFT<=DATA_TO_SEND;
				end
		else
				begin
					OUT_SHIFT<={OUT_SHIFT[254:0],1'b0};
					//IN_SHIFT={IN_SHIFT[254:0],SDATA_IN};
				end
		end
	
//-----leitura no negedge escrita  no posefge
	always @(negedge BIT_CLK)
		begin
		if(RESET)
		begin
		  IN_SHIFT<=0;
		  DATA_RECEIVED<=0;
		end
		else if(POSEDGE_SYNC)
					DATA_RECEIVED<={IN_SHIFT[254:0],1'b0};
			else
				IN_SHIFT <= {IN_SHIFT[254:0],SDATA_IN};
		end
	
 assign SDATA_OUT=OUT_SHIFT[255];
 

	//#############################SEPARAR DOMINIOS DE RELOGIO
	
	
	
always @(posedge BIT_CLK)
if ( RESET )
begin
  DELAY_SYNC1<=0;
  DELAY_SYNC2<=0;
end
else
    begin
      DELAY_SYNC1<=SYNC;
      DELAY_SYNC2<=DELAY_SYNC1;  //atrasa o SYNC 2 BIT_CLK's
    end
      
assign POSEDGE_SYNC =((~DELAY_SYNC1) & SYNC);
assign NEGEDGE_SYNC=(DELAY_SYNC1 & (~SYNC));
	  
always@(posedge CLOCK)
if ( RESET )
	begin
	  DELAY_SYNC_REGISTER<=0;
	  DELAY_SYNC_REGISTER2<=0;
      SYNC_REGISTER<=0;//Gera o SYNC_REGISTER
	end
	else
	begin
	  DELAY_SYNC_REGISTER<=DELAY_SYNC2;
	  DELAY_SYNC_REGISTER2<=DELAY_SYNC_REGISTER;
      SYNC_REGISTER<=DELAY_SYNC_REGISTER2;//Gera o SYNC_REGISTER
	end


reg VALID_STATUS;
reg [255:0] FRAME_IN,FRAME_OUT;
wire[15:0] FRAME_IN_TAG,FRAME_OUT_TAG;
wire [19:0] FRAME_IN_SLOT1,FRAME_IN_SLOT2,FRAME_IN_SLOT3,FRAME_IN_SLOT4;
wire[19:0] FRAME_OUT_SLOT1,FRAME_OUT_SLOT2,FRAME_OUT_SLOT3,FRAME_OUT_SLOT4;
wire VALID_LEFT_PCM,VALID_RIGHT_PCM;
wire CODEC_READY;
wire RIGHT_PCM_RQST,LEFT_PCM_RQST;
reg VALID_REGISTER_ADRESS,VALID_REGISTER_DATA,READ_WRITE;
reg [6:0] SEND_VALID_REG;   //adicionado
reg [15:0] DIN_REG;
reg [5:0] REGID_REG;



assign FRAME_IN_TAG=FRAME_IN[255:240];
assign FRAME_IN_SLOT1=FRAME_IN[239:220];
assign FRAME_IN_SLOT2=FRAME_IN[219:200];
assign FRAME_IN_SLOT3=FRAME_IN[199:180];
assign FRAME_IN_SLOT4=FRAME_IN[179:160];

assign CODEC_READY=FRAME_IN_TAG[15];
assign VALID_LEFT_PCM=FRAME_IN_TAG[12]; //amostras de audio validas
assign VALID_RIGHT_PCM=FRAME_IN_TAG[11];
assign LEFT_PCM_RQST=FRAME_IN_SLOT1[11];//requests de novas amostras de audio
assign RIGHT_PCM_RQST=FRAME_IN_SLOT1[10];


//sincronizaçao entre os 2 dominios de relogio
always @(posedge CLOCK)
  if(RESET)
    begin
      FRAME_IN<=0;
      DATA_TO_SEND<=0;
     end
  else
    if(POSEDGE_SYNC_REGISTER)
    begin
      FRAME_IN<=DATA_RECEIVED;
      DATA_TO_SEND<=FRAME_OUT;
    end
  //*************************************************************
  
always@(posedge CLOCK)
  if ( RESET )
      begin 
        SYNC_REGISTER_READY<=SYNC_REGISTER;
        DIN_RDY <= POSEDGE_SYNC_REGISTER; //calculo da saida DIN_RDY
      end
      else
      begin 
        SYNC_REGISTER_READY<=SYNC_REGISTER;
        DIN_RDY <= POSEDGE_SYNC_REGISTER; //calculo da saida DIN_RDY
      end
    
assign  POSEDGE_SYNC_REGISTER=(SYNC_REGISTER &(~SYNC_REGISTER_READY));
assign NEGEDGE_SYNC_REGISTER=((~SYNC_REGISTER)&SYNC_REGISTER_READY);
 
assign DOUT_RQST=POSEDGE_SYNC_REGISTER & (LEFT_PCM_RQST & RIGHT_PCM_RQST);
    
    
//  Gerar Amostras de audio |255 T 240|239 1 220|219 2 200|199 3 180|179 4 160|
assign LEFT_IN = VALID_LEFT_PCM ? FRAME_IN_SLOT3[19:2]:18'd0;
assign RIGHT_IN = VALID_RIGHT_PCM ? FRAME_IN_SLOT4[19:2]:18'd0;




//Gerar uma nova frame


assign FRAME_OUT_TAG={1'b1,VALID_REGISTER_ADRESS,VALID_REGISTER_DATA,2'b11,11'd0};
assign FRAME_OUT_SLOT1= VALID_REGISTER_ADRESS? {READ_WRITE,SEND_VALID_REG,12'd0}:0;  // alterado
assign FRAME_OUT_SLOT2 = VALID_REGISTER_DATA? {DIN_REG,4'd0}:0;
assign FRAME_OUT_SLOT3={LEFT_OUT,2'd0};
assign FRAME_OUT_SLOT4={RIGHT_OUT,2'd0};


always@(posedge CLOCK)
  if(RESET)
    FRAME_OUT<=0;
  else
     if(NEGEDGE_SYNC_REGISTER)
       begin
         FRAME_OUT<={FRAME_OUT_TAG,FRAME_OUT_SLOT1,FRAME_OUT_SLOT2,	FRAME_OUT_SLOT3,FRAME_OUT_SLOT4,160'b0};
       end
  
//FSM PARA LER E ESCREVER REGISTOS
  
reg [3:0] STATE_REG,NEXTSTATE_REG;
integer count_reg=0;
parameter INI_REG=4'b0000,
          S1_REG =4'b0001,
          S2_REG =4'b0010,
          S3_REG =4'b0011,
          S4_REG =4'b0100,
          S5_REG =4'b0101,
          S6_REG =4'b0110,
          S7_REG =4'b0111,
          S8_REG_CAPT=4'b1000,
          S9_REG_CAPTURE=4'b1001;
          

          
always @(posedge CLOCK)
  begin
    if(RESET)
        STATE_REG<=INI_REG;
    else
      STATE_REG <= NEXTSTATE_REG;
  end
  

always @(posedge CLOCK)
if ( RESET )
begin
  NEXTSTATE_REG<=0;
end
else
   case(STATE_REG)
      INI_REG:
		begin
			if(RE)
				NEXTSTATE_REG<=S1_REG;
           else if(WE)
				NEXTSTATE_REG<=S9_REG_CAPTURE;
				else
				NEXTSTATE_REG<=INI_REG;
			end
       S1_REG:
        begin         
           if(NEGEDGE_SYNC_REGISTER)
			NEXTSTATE_REG<=S2_REG;
        end
          
      S2_REG:
        begin
          if(POSEDGE_SYNC_REGISTER)
			NEXTSTATE_REG<=S3_REG;
        end 
            
      S3_REG:
        begin
           if(count_reg==4)
			NEXTSTATE_REG<=S4_REG;
         
      end
      
      S4_REG:
        begin
          if(/*POSEDGE_SYNC_REGISTER*/NEGEDGE_SYNC_REGISTER)
            NEXTSTATE_REG<=/*S5_REG*/INI_REG;
      
       end
       

      
	  S8_REG_CAPT:
      begin 
      if(REGID_REG == 6'h00 || REGID_REG == 6'h02 || REGID_REG == 6'h04 ||
                   REGID_REG == 6'h06 || REGID_REG == 6'h0A || REGID_REG == 6'h0C || 
                   REGID_REG == 6'h0E || REGID_REG == 6'h10 || REGID_REG == 6'h12 ||
                   REGID_REG == 6'h14 || REGID_REG == 6'h16 || REGID_REG == 6'h18 ||
                   REGID_REG == 6'h1A || REGID_REG == 6'h1C || REGID_REG == 6'h20 || 
                   REGID_REG == 6'h26 || REGID_REG == 6'h28 || REGID_REG == 6'h2A ||
                   REGID_REG == 6'h2C || REGID_REG == 6'h32)
            NEXTSTATE_REG<=S6_REG;
      else
            NEXTSTATE_REG<=INI_REG;
      end
      S9_REG_CAPTURE:
			NEXTSTATE_REG<=S8_REG_CAPT;
      S6_REG:
		  if(NEGEDGE_SYNC_REGISTER)
            NEXTSTATE_REG<=S7_REG;
          
      
	  S7_REG:
       
         if(POSEDGE_SYNC_REGISTER)
            NEXTSTATE_REG<=INI_REG;
	
        
endcase
      
          
always @(posedge CLOCK)
if ( RESET )
          begin 
            RDY<=1;
            count_reg<=0;
            VALID_STATUS<=0;
			REGID_REG <= 0;
            DIN_REG <= 0;
			VALID_REGISTER_ADRESS<=0;
			VALID_REGISTER_DATA<=0;
			READ_WRITE<=1;
			SEND_VALID_REG<= 0;
			STATUS_REG<=0;
        end
		else
     case(STATE_REG)
        INI_REG:
          begin 
            RDY<=1;
            count_reg<=0;
            VALID_STATUS<=0;
			REGID_REG <= 0;
             DIN_REG <= 0;
			 VALID_REGISTER_ADRESS<=0;
			VALID_REGISTER_DATA<=0;
			READ_WRITE<=1;
        end
        S1_REG:
          begin
            RDY<=0;
			READ_WRITE<=1;
			VALID_REGISTER_ADRESS<=1;
			VALID_REGISTER_DATA<=1;
		    SEND_VALID_REG<={1'b0,6'h26}; //adicionado 
		  end
        S2_REG:
			begin
				RDY<=0;
			end
        S3_REG: 
          begin
            RDY<=0;
            if(POSEDGE_SYNC_REGISTER)
              begin
                count_reg<=count_reg +1;
              end
           end
        S4_REG: 
		begin
		RDY<=0;
		VALID_STATUS<=1;
		STATUS_REG<=FRAME_IN_SLOT2[7:4];
		end
        /*S5_REG:
          begin
            RDY<=1;
            //VALID_STATUS<=1;
         end*/
        S6_REG: 
          begin
            RDY<=0;
            READ_WRITE<=0;
			VALID_REGISTER_ADRESS<=1;
			VALID_REGISTER_DATA<=1;
			 SEND_VALID_REG<={1'b0,REGID_REG}; //adicionado
				 
        end
        S7_REG:
          begin
           RDY<=0;
           READ_WRITE<=0;
          end
        S9_REG_CAPTURE:
            begin
             REGID_REG <= REGID;
             DIN_REG <= DIN;
            end  
 endcase


assign STATUS=STATUS_REG;

endmodule



