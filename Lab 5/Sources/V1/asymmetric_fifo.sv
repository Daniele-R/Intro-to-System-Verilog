
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 10:45:01 PM
// Design Name: 
// Module Name: fifo
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


module asymmetric_fifo
    #(parameter ADDR_WIDTH = 3, DATA_WIDTH = 8) //this address width is for how many words can be written, as in word addresses
    (
        input logic clk, reset,
        input logic wr, rd,
        input logic [2 * DATA_WIDTH - 1: 0] w_data,
        output logic [DATA_WIDTH - 1: 0] r_data,
        output logic full, empty
    );
    
    // signal declaration
    logic [ADDR_WIDTH : 0] w_addr, r_addr; //this address is how many addresses needed in order to write all the words
    //we claim we can take into slots of memory that the other system can read
    
    // instantiate register file
    asy_reg_file #(.ADDR_WIDTH(ADDR_WIDTH + 1), .DATA_WIDTH(DATA_WIDTH))
        r_file_unit (.w_en( wr & ~full), .*);

    // instantiate fifo controller
    asy_fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH + 1))
        ctrl_unit (.*);                    
endmodule
