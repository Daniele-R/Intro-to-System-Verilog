`timescale 1ns / 1ps

module temp_converter
(
    input logic clk,
    input logic [7:0] din,
    input logic format,
    output logic [7:0] dout
);
    
    synch_rom_param #(.file("temp_conv_lookup.mem"), .ADDR_WIDTH(9), .DATA_WIDTH(8)) cel2far
    (
        .clk(clk),
        .addr({format,din}),
        .data(dout)
    );
    
endmodule
