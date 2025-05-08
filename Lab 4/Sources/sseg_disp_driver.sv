`timescale 1ns / 1ps

module sseg_disp_driver #(parameter speed = 200_000)
(
    input logic clk,
    input logic rst,
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic [3:0] in2,
    input logic [3:0] in3,
    input logic [3:0] in4,
    input logic [3:0] in5,
    input logic [3:0] in6,
    input logic [3:0] in7,
    output logic [6:0] seg,
    output logic dp,
    output logic [7:0] an
);
    
    logic [2:0] bin_cnt_tmp;
    logic [3:0] input_mux_out;
    logic [2:0] cnt_next, cnt_reg;
    logic max_tick;
    
    
    // Mod counter to slow down for human eyes
    mod_m_counter #(.M(speed)) timer
    (
        .clk(clk),
        .reset(rst),
        .q(),
        .max_tick(max_tick)
    );
    
    // body
    // [1] Register segment
    always_ff @(posedge clk, posedge rst)
    begin
        if(rst)
            cnt_reg <= 0;
        else
            cnt_reg <= cnt_next;
    end
    
    // [2] next-state logic segment
    assign cnt_next = max_tick ? cnt_reg + 1: cnt_reg ;
    
    // [3] output logic segment
    always_comb
    begin
        case (cnt_reg)
            0: begin
                input_mux_out = in0;
                an = 8'b1111_1110;
            end
            1: begin
                input_mux_out = in1;
                an = 8'b1111_1101;
            end
            2: begin
                input_mux_out = in2;
                an = 8'b1111_1011;
            end
            3: begin
                input_mux_out = in3;
                an = 8'b1111_0111;
            end
            4: begin
                input_mux_out = in4;
                an = 8'b1110_1111;
            end
            5: begin
                input_mux_out = in5;
                an = 8'b1101_1111;
            end
            6: begin
                input_mux_out = in6;
                an = 8'b1011_1111;
            end
            7: begin
                input_mux_out = in7;
                an = 8'b0111_1111;
            end
            default: begin
                input_mux_out = 4'hXX;
                an = 8'b1111_1111;
            end
            
        endcase
    end
    
    bcd2sseg sseg_dec
    (
        .bcd_in(input_mux_out),
        .enable(1'b1),
        .sseg(seg)
    );
    
    assign dp = 1'b1;
    
endmodule
