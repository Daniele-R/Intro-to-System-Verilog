`timescale 1ns / 1ps

module square_pattern
   (
    input clk,
    input reset,
    input logic [10:0] x, y,     // treated as x-/y-axis
    input logic [1:0] size_sel,
    input logic [11:0] rgb,
    output logic [11:0] sqr_rgb
   );

    logic [11:0] color_rgb, gray_rgb;
    logic [7:0] size;

    logic [3:0] r, g, b;
    assign r = rgb[11:8];
    assign g = rgb[7:4];
    assign b = rgb[3:0];

    logic [3:0] r_out, g_out, b_out;
    assign r = rgb[11:8];
    assign g = rgb[7:4];
    assign b = rgb[3:0];
    
    always_comb
    begin
        case(size_sel)
            2'b00:size=8'd16;
            2'b01:size=8'd32;
            2'b10:size=8'd64;
            2'b11:size=8'd128;
            default:size=8'd16;
        endcase
    end

    // body
    always_ff @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            r_out <= 0;
            g_out <= 0;
            b_out <= 0;
        end
        else
        begin
            if(y <= (240 - size/2))
            begin
                r_out <= ~r;
                g_out <= ~g;
                b_out <= ~b;
            end
            else if((y > (240 - size/2)) && (y <= (240 + size/2)))
            begin
                if(x <= 320 - size/2)
                begin
                    r_out <= ~r;
                    g_out <= ~g;
                    b_out <= ~b;
                end
                else if((x > (320 - size/2)) && (x <= (320 + size/2)))
                begin
                    r_out <= r;
                    g_out <= g;
                    b_out <= b;
                end
                else
                begin
                    r_out <= ~r;
                    g_out <= ~g;
                    b_out <= ~b;
                end
            end
            else
            begin
                r_out <= ~r;
                g_out <= ~g;
                b_out <= ~b;
            end
        end // else  
    end// always

    assign sqr_rgb = {r_out, g_out, b_out};
endmodule
