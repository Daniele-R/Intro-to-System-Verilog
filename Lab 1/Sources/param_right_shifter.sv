`timescale 1ns / 1ps

module param_right_shifter #(parameter N = 3) 
(
    input logic [(2**N)-1:0] a,                         // inputs (increase by N^2 -1)
    input logic [N-1:0] amt,                            // selector (increases by N -1)
    output logic [(2**N)-1:0] y                         // outputs will match inputs (increases by N^2 -1)
);                                                  
  
    logic [(2**N)-1:0] temp;                            // temp here will store our results, thus the same size as Y
    
    always_comb                                         // blocking as is combinational
    begin
        temp = a;                                       // our input (a) will now be temp
        for(int i = 0; i < N; i++) begin                // it will loop up to N times
            if(amt[i] == 1)                             // checks if our selector is 1, if so proceeds
                for(int j = (2**i); j > 0; j--)         // right shifting loop with 2^i iteration
                    temp = {temp[0],temp[(2**N)-1:1]};  // glues temp[0] (LSB) and temp[7:1] (MSB) (if we were using N=3)
        end                                             // and causes the rest of the bits to be shifted to the right
    end
       
   assign y = temp;                                     // we store the temp value into out output Y
        
endmodule
