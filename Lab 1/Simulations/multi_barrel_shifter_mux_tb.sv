`timescale 1ns / 1ps

module multi_barrel_shifter_mux_tb #(parameter N_tb = 3)();
    logic [(2**N_tb)-1:0] a_tb;
    logic [N_tb-1:0] amt_tb;
    logic lr_tb;
    logic [(2**N_tb)-1:0] y_tb;
    
    integer i;
    
     multi_barrel_shifter_mux #(.N(N_tb)) GEN_MULTI_SHIFTER_TB
    (
        .a(a_tb),
        .amt(amt_tb),
        .lr(lr_tb),
        .y(y_tb)
    );
    
    initial begin
        a_tb = 8'b1100_0110; 
        amt_tb = 3'h0;
        lr_tb = 1'b0; //Left Shift Mode
        for(i=1; i<(2**N_tb); i=i+1) begin
            #10 amt_tb = amt_tb + 1'b1;
        end
        
        #10 amt_tb = 3'h0;
        lr_tb = 1'b1; //Right Shift Mode
        for(i=1; i<(2**N_tb); i=i+1) begin
            #10 amt_tb = amt_tb + 1'b1;
        end
        
        #10 $finish;
    end
    
endmodule
