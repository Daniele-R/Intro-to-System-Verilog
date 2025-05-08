`timescale 1ns / 1ps

module top #(parameter speed = 100_000)(
    input logic clk,
    input logic rst,
    input logic [7:0] din,
    input logic format,
    output logic [6:0] seg,
    output logic dp,
    output logic [7:0] an
    );
    
    logic [3:0] in0, in1, in2 , in3, in4, in5, in6, in7;
    logic [7:0] temp_out;
    
    temp_converter temp_conv
    (
        .clk(clk),
        .din(din),
        .format(format),
        .dout(temp_out)
    );
    
    bin2bcd conv_in
    (
        .bin(din),
        .bcd({in7,in6,in5})
    );
    
    assign in4 = format? 4'hf: 4'hc;
    
    bin2bcd conv_out
    (
        .bin(temp_out),
        .bcd({in3,in2,in1})
    );
    
    assign in0 = format? 4'hc: 4'hf;
    
    sseg_disp_driver #(.speed(speed)) disp_driv
    (
        .clk(clk),
        .rst(rst),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .seg(seg),
        .dp(dp),
        .an(an)
    );    
    
endmodule
