`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 06:24:11 PM
// Design Name: 
// Module Name: square_pattern_gen
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


module square_pattern_gen(
    input logic [10:0] x, y,
    input logic [11:0] color_sw,
    input logic [1:0] pixel_sw,
    output logic [11:0] square_rgb 
); //I have left the last switch for the rgb to grayscale function
    
    logic [3:0] r, g, b;
    logic [10:0] sq_size;
        
    always_comb
    begin
        case(pixel_sw)
        2'b00: sq_size = 8'd16;
            //16 pixels
        2'b01: sq_size = 8'd32;
            //32 pixels
        2'b10: sq_size = 8'd64;
            //64 pixels
        2'b11: sq_size = 8'd128;
            //128 pixels
        endcase
    end
    
    always_comb
    begin //use pixel variable from before and calculate where sides of square are
        if((y <= 240 + ((sq_size/2) - 1)) && (y >= 239 - ((sq_size/2) - 1)) && (x <= 320 + ((sq_size/2) - 1)) && (x >= 319 - ((sq_size/2) -1)))
        begin
            r = color_sw[11:8];
            g = color_sw[7:4];
            b = color_sw[3:0];
        end
        else//outside the square
        begin
            r = 4'b1111 - color_sw[11:8];
            g = 4'b1111 - color_sw[7:4];
            b = 4'b1111 - color_sw[3:0];
        end
    end
    
    assign square_rgb = {r, g, b};
    
endmodule
