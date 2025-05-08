//Taken from prev. lab 3300

`timescale 1ns / 1ps

module decoder_param #(parameter N = 3)
(
    input logic [N - 1:0] in,
    input logic en,
    output logic [2**N - 1:0] out
);
    
    always_comb
    begin
        out = {2**N{1'b0}}; 
        
        if(en)
        begin
            integer i;
            for(i = 0; i < 2**N; i = i +1)
            begin
                if (in == i)
                    out[i] = 1'b1;
            end
        end
    end
    
endmodule

