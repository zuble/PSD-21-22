/* 
PSD 2021-2022

    Gustavo Pelayo
    Rui Barbosa
	
*/

module psdsqrt (
    input clock,            //master clock rising edge
    input reset,            //synch reset active high
    input start,            //start a new square root, one clock cycle
    input stop,             //load output register, one clock pulse
    input [31:0] xin,       //operand, unsigned integer 32 bits
    output reg [15:0] sqrt  //sqrt(xin), unsigned integer 16 bits
);

    reg signed [31:0]   xin_out;
    reg signed [15:0]   tempsqrt;
    reg signed [15:0]   right_or;

    wire comparator;

    wire signed [31:0] sqtestsqrt;
    wire signed [15:0] testsqrt;


    // multiplier
    assign sqtestsqrt = testsqrt * testsqrt;    

    //comparator
    assign comparator = (xin_out >= sqtestsqrt) ? 1'b1 : 1'b0;

    /*// Comparator
    reg signed comparator;
    always @*
        comparator <= (xin_out >= sqtestsqrt) ? 1'b1 : 1'b0;
        
        //ou
        
        if (xin_out >= sqtestsqrt)                  
            comparator <= 1;
        else
            comparator <= 0;
    */


    // xin FF
    always@(posedge clock)
        if(reset) begin
            xin_out <= 32'h0000; 
        end else if(start)  begin
            xin_out <= xin;     
        end


    // left OR
    always@(posedge clock)
        if(reset) begin
            tempsqrt <= 16'h0000;
        end else if(start) begin    //top left mux
            tempsqrt <= 16'h0000;
        end else begin				//down left mux
            tempsqrt <= comparator ? testsqrt : tempsqrt;  // if comparator == 1 : tempsqrt <= testsqrt; else tempsqrt <= tempsqrt
        end

    // right OR
    always@(posedge clock)
        begin
            if(reset)                   //right FF      
                right_or <= 16'h0000;
            else if(start)              //right mux 
                right_or <= 16'h8000;    
            else
                right_or <= right_or >> 1;
        end

    // OR
    assign testsqrt = tempsqrt | right_or;   


    // sqrt FF
    always@(posedge clock)
        begin
            if(reset)
                sqrt <= 16'h0000;
            else if(stop)
                sqrt <= tempsqrt;
        end

endmodule