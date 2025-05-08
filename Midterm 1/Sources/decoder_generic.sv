`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 06:41:10 PM
// Design Name: 
// Module Name: decoder_generic
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


module decoder_generic
    #(parameter N = 3)(
    input logic [N - 1:0] w,
    input logic en,
    output logic [0: 2 ** N - 1] y
    );

    always_comb
    begin
        y = 'b0; //default
        
        if (en)
            y[w] = 1'b1;
        else
            y = 'b0;
        
    end

endmodule
