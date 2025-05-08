 module bin2bcd(
    input logic [7:0] bin,
    output logic [11:0] bcd
    );
      
     logic [3:0] i;   
     
     //Always block - implement the Double Dabble algorithm
     always_comb
        begin
            bcd = 0;                            //initialize bcd to zero.
            for (i = 0; i < 8; i = i+1)         //run for 8 iterations
            begin
                bcd = {bcd[10:0],bin[7-i]};     //concatenation
                    
                //if a hex digit of 'bcd' is more than 4, add 3 to it.  
                if(i < 7 && bcd[3:0] > 4) 
                    bcd[3:0] = bcd[3:0] + 3;
                if(i < 7 && bcd[7:4] > 4)
                    bcd[7:4] = bcd[7:4] + 3;
                if(i < 7 && bcd[11:8] > 4)
                    bcd[11:8] = bcd[11:8] + 3;  
            end
        end     
                
endmodule
