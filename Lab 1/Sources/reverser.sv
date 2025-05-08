`timescale 1ns / 1ps

module reverser #(parameter N = 3)
(
    input logic [(2**N)-1:0] a,             // 7:0 inputs
    input logic en,                         // enabler
    output logic [(2**N)-1:0] y             // 7:0 outputs
);
    
    logic [(2**N)-1:0] temp = 0;            // temp 7:0 and initilize all temp values bits to 0
    
    always_comb 
    begin
        for(int i = 0; i < 2**N; i++)       // loop that goes thru the whole bits array
        begin
            temp[(2**N) - 1 - i] = a[i];    // flips the order (when temp[7] , a=0; temp[6] , a=1 ; and so on.
        end
    end
    
    assign y = en ? temp : a;               // if enable is on, y=en ; if not y=a
    
endmodule
