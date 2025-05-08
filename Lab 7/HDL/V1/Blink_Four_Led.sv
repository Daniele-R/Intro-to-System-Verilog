`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 03:53:36 PM
// Design Name: 
// Module Name: Blink_Four_Led
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


module Blink_Four_Led #(parameter W = 8) //output width
    ( //parameter for the four led values
        input logic clk,
        output logic reset,
        //slot interface
        input logic cs,
        input logic read, //not using this since we are only outputing
        input logic write,
        input logic [4:0] addr,
        input logic [31:0] wr_data,
        output logic [31:0] rd_data,
        //external port
        output logic [W-1:0] leds
    );
    
    //signals declare
    logic wr_en1, wr_en2, wr_en3, wr_en4;
    logic [15:0] led1, led2, led3, led4;
    
    
    //
    //wrapping circuit
    //
    
    assign wr_en1 = write && cs && addr[4:0] == 5'b00000;
    assign wr_en2 = write && cs && addr[4:0] == 5'b00001;
    assign wr_en3 = write && cs && addr[4:0] == 5'b00010;
    assign wr_en4 = write && cs && addr[4:0] == 5'b00011;
    
    assign rd_data = 0; //only outputing
    
    assign leds[W-1:4] = 0; //only need the first four leds
    
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            led1 <= 0;
        else
            if (wr_en1)
                led1 <= wr_data[15:0];
    end
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            led2 <= 0;
        else
            if (wr_en2)
                led2 <= wr_data[15:0];
    end
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            led3 <= 0;
        else
            if (wr_en3)
                led3 <= wr_data[15:0];
    end
    
    always_ff @(posedge clk, posedge reset)
    begin
        if (reset)
            led4 <= 0;
        else
            if (wr_en4)
                led4 <= wr_data[15:0];
    end
    
        
    //
    // four leds set up, the cores main function/task
    //
    alt_led M1(
        .clk(clk),
        .reset(reset),
        .rate(led1),
        .led(leds[0])
    );
    
    alt_led M2(
        .clk(clk),
        .reset(reset),
        .rate(led2),
        .led(leds[1])
    );
    
    alt_led M3(
        .clk(clk),
        .reset(reset),
        .rate(led3),
        .led(leds[2])
    );
    
    alt_led M4(
        .clk(clk),
        .reset(reset),
        .rate(led4),
        .led(leds[3])
    );
    
endmodule
