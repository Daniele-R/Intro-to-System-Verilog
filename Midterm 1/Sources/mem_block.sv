`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 07:29:58 PM
// Design Name: 
// Module Name: mem_block
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


module mem_block
    (
    input logic clk, 
    input logic we,                                             //write enable
    input logic [11:0] addr,
    input logic [3:0] din,
    output logic [3:0] dout
    );
    
    logic [3:0] we_temp, dec_temp;                              // wires
    logic [3:0] mem_out0, mem_out1, mem_out2, mem_out3;         // memory output
    
    // decoder
    decoder_param #(.N(2)) mod_dec
    (
        .in(addr[11:10]),
        .en(1'b1),
        .out(dec_temp)
    );
    
    // AND gates
    assign we_temp[0] = dec_temp[0] & we;
    assign we_temp[1] = dec_temp[1] & we;
    assign we_temp[2] = dec_temp[2] & we;
    assign we_temp[3] = dec_temp[3] & we;
    
    // BRAM modules
    
    bram_synch_one_port #(.ADDR_WIDTH(10), .DATA_WIDTH(4)) mem_block0
    (
        .clk(clk),
        .we(we_temp[0]),
        .addr_a(addr[9:0]),       
        .din_a(din),       
        .dout_a(mem_out0)
    );
    
    bram_synch_one_port #(.ADDR_WIDTH(10), .DATA_WIDTH(4)) mem_block1 
    (
        .clk(clk),
        .we(we_temp[1]),
        .addr_a(addr[9:0]),       
        .din_a(din),       
        .dout_a(mem_out1)
    );
    
    bram_synch_one_port #(.ADDR_WIDTH(10), .DATA_WIDTH(4)) mem_block2 
    (
        .clk(clk),
        .we(we_temp[2]),
        .addr_a(addr[9:0]),       
        .din_a(din),       
        .dout_a(mem_out2)
    );
    
    bram_synch_one_port #(.ADDR_WIDTH(10), .DATA_WIDTH(4)) mem_block3 
    (
        .clk(clk),
        .we(we_temp[3]),
        .addr_a(addr[9:0]),       
        .din_a(din),       
        .dout_a(mem_out3)
    );
    
    // MUX connection for output
    
    mux_4x1_nbit #(.N(4)) mem_mux
    (
        .w0(mem_out0),
        .w1(mem_out1),
        .w2(mem_out2),
        .w3(mem_out3),
        .s(addr[11:10]),
        .f(dout)
    );
    
endmodule