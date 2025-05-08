module synch_rom #(parameter F = "Cel_and_Fah.mem")(
    input logic clk,
    input logic [8:0] addr,
    output logic [7:0] data
    );
    
    // signal declaration
    (*rom_style = "block" *)logic [7:0] rom [0:511];
    
    initial
        $readmemb(F, rom);//b and h determines if we will read hex number that are inside file or binary inside files
        
    always_ff @(posedge clk)
        data <= rom[addr];
endmodule