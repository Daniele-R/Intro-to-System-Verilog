`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2024 11:18:51 AM
// Design Name: 
// Module Name: Square_Wave_Gen
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


module Square_Wave_Gen(
        input logic clk, reset,
        input logic [3:0] n, //off
        input logic [3:0] m, //on
        output logic sig
    );
    
    logic [3:0] value;
    logic [7:0] limit;
    logic done;
    logic sel;
    
    param_mux_2x1 #(.N(2)) M1(.x0(n),
                              .x1(m),
                              .sel(sel),
                              .y(value));
    
    assign limit = value * 4'b1010;
    
    mod_m_counter_binary #(.M(8)) M2(.clk(clk),
                             .reset(reset),
                             .q(limit),
                             .max_tick(done));
    
    T_FF M3(.clk(clk),
            .T(done),
            .reset_n(~reset),
            .Q(sel));
    
    assign sig = sel;
    
endmodule
