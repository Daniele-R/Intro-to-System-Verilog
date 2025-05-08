`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2024 12:14:58 PM
// Design Name: 
// Module Name: temp_converter
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


module temp_converter(
    input logic format, clk, reset,
    input logic [7:0] degree,//binary
    output logic [7:0] AN,
    output logic [6:0] sseg,
    output logic DP
    );
    
    //if format is 0, c2f else f2c
    
    logic [7:0] data;
    
    //synch_rom
    synch_rom #(.F("Cel_and_Fah.mem")) M1(
        .addr({format, degree}), //if format = 0, we are turning celsius degree into fahrenheit and vise versa
        .*
    );
     
    logic [9:0] data_bcd, degree_bcd;
    
    bin2bcd #(.W(8)) M2(
        .bin(degree),
        .bcd(degree_bcd)
    );
    
    bin2bcd #(.W(8)) M3(
        .bin(data),
        .bcd(data_bcd)
    );
    
    sseg_driver M4(
        .I7({1'b1, degree_bcd[3:0], 1'b0}),
        .I6({1'b1, degree_bcd[7:4], 1'b0}),
        .I5({1'b1, {2'b00, degree_bcd[9:8]}, 1'b0}),
        .I4({1'b0, 4'b0000, 1'b0}),
        .I3({1'b1, data_bcd[3:0], 1'b0}),
        .I2({1'b1, data_bcd[7:4], 1'b0}),
        .I1({1'b1, {2'b00, data_bcd[9:8]}, 1'b0}),
        .I0({1'b0, 4'b0000, 1'b0}),
        .reset_n(reset),
        .*
    );
    
endmodule
