module  sum(
    input [63:0] sum_A,       
    input [63:0] sum_B,
    output[63:0] sum_out
);

    wire [31:0]   re_A,
                        re_B,
                        im_A,
                        im_B,
                        re_out,
                        im_out;

    wire [63:0] sum_out; 


    assign re_A = sum_A[64:32];
    assign re_B = sum_B[64:32];
    assign im_A = sum_A[31:0];
    assign im_B = sum_B[31:0];
    assign re_out = re_A + re_B;
    assign im_out = im_A + im_B;
    assign sum_out = {re_out,im_out};

endmodule