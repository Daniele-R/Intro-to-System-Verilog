`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 07:32:34 PM
// Design Name: 
// Module Name: top
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


module top(
    input logic clk, reset_n,
    input logic we_input, //write enable
    input logic [11:0] addr,
    input logic [3:0] din,
    output logic [7:0] AN,
    output logic [6:0] sseg,
    output logic DP
    );
    
    logic [4:0] in_bcd, out_bcd;
    logic [3:0] dout;
    logic we;

    // Write enable push button
    button we_button(
        .noisy(we_input),        
        .p_edge(we),  
        .n_edge(),
        ._edge(),
        .debounced(),        
        .*
    );

    // 256B Memory block
    mem_block block0(
        .*
    );

    // Display input and output on the sseg display      
    bin2bcd  #(.W(4))in_converter(
        .bin(din),
        .bcd(in_bcd)
    );
    
    bin2bcd  #(.W(4))out_converter(
        .bin(dout),
        .bcd(out_bcd)
    );

    sseg_driver driver0(
        .I7({1'b1, in_bcd[3:0], 1'b0}),
        .I6({din > 8'd9, {3'b0, in_bcd[4]}, 1'b0}),
        .I5({1'b0, 4'b0, 1'b0}),
        .I4({1'b0, 4'b0, 1'b0}),
        .I3({1'b1, out_bcd[3:0], 1'b0}),
        .I2({dout > 8'd9, {3'b0, out_bcd[4]}, 1'b0}),
        .I1({1'b0, 4'b0, 1'b0}),
        .I0({1'b0, 4'b0, 1'b0}),
        .*
    );
    
    
endmodule
