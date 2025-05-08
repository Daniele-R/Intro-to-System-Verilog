`timescale 1ns / 1ps

module synch_rom_param
    #(parameter file = "binary_truth_table.mem", ADDR_WIDTH = 8, DATA_WIDTH = 8)
    (
    input logic clk,
    input logic [ADDR_WIDTH - 1:0] addr,
    output logic [DATA_WIDTH - 1:0] data
    );
    
    // signal declaration
    (*rom_style = "block" *)logic [DATA_WIDTH - 1:0] rom [0:2**ADDR_WIDTH -1];
    
    initial
        $readmemb(file, rom);
        
    always_ff @(posedge clk)
        data <= rom[addr];
        
endmodule