`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 11:11:35 PM
// Design Name: 
// Module Name: fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_tb(

    );
    
    // signal declarations
    localparam DATA_WIDTH = 4;
    localparam ADDR_WIDTH = 3;
    localparam T = 10; //clock period
    
    logic clk, reset;
    logic wr, rd;
    logic [DATA_WIDTH*2 -1: 0] w_data;
    logic [DATA_WIDTH -1: 0]  r_data;
    logic full, empty;
    
    // instantiate module under test
    fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) uut (.*);
    
    // 10 ns clock running forever
    always
    begin
        clk = 1'b1;
        #(T / 2);
        clk = 1'b0;
        #(T / 2);
    end
    
    // reset for the first half cylce
    initial
    begin
        reset = 1'b1;
        rd = 1'b0;
        wr = 1'b0;
        @(negedge clk);
        reset = 1'b0;
    end
    
    //test vectors
    initial
    begin
        // ----------------EMPTY-----------------------
        // write
        @(negedge clk);
        w_data = 8'h21;
        wr = 1'b1;     
        @(negedge clk);
        wr = 1'b0;
        
        // write
        repeat(1) @(negedge clk);
        w_data = 8'h43;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;        
        
        // write
        repeat(1) @(negedge clk);
        w_data = 8'h65;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;        
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;     

        // write
        repeat(1) @(negedge clk);
        w_data = 8'h87;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;        
        
        // write
        repeat(1) @(negedge clk);
        w_data = 8'ha9;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;              
        
        // ----------------FULL-----------------------

        // write
        repeat(1) @(negedge clk);
        w_data = 8'hcb;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;    
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;

        // write
        repeat(1) @(negedge clk);
        w_data = 8'hcb;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;  
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;

        // read
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        // ----------------EMPTY-----------------------
        
        // read & write at the same time
        repeat(1) @(negedge clk);
        w_data = 8'h21;
        wr = 1'b1;
        rd = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        rd = 1'b0;

        // read the rest
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        // read while empty
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;

        // ----------------NOT EMPTY-----------------------
        repeat(1) @(negedge clk);
        w_data = 8'h21;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        
        repeat(1) @(negedge clk);
        w_data = 8'h43;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        
        repeat(1) @(negedge clk);
        w_data = 8'h65;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        
        // read & write at the same time
        repeat(1) @(negedge clk);
        w_data = 8'h87;
        wr = 1'b1;
        rd = 1'b1;
        @(negedge clk)
        wr = 1'b0;
        rd = 1'b0;

        repeat(1) @(negedge clk);
        w_data = 8'ha9;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;

        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;
        
        repeat(1) @(negedge clk);
        w_data = 8'ha9;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;

        // ----------------FULL-----------------------
        repeat(1) @(negedge clk);
        w_data = 8'hcb;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;

        repeat(1) @(negedge clk);
        w_data = 8'hed;
        wr = 1'b1;
        @(negedge clk)
        wr = 1'b0;

        // ----------------NOT FULL-----------------------
        repeat(1) @(negedge clk);
        rd = 1'b1;
        @(negedge clk)
        rd = 1'b0;

        repeat(3) @(negedge clk);
        $stop;
                
        
    end
    
endmodule

