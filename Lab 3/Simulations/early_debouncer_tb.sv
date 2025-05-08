`timescale 1ns / 1ps

module early_debouncer_tb#(parameter db_time_tb = 10)();
    logic sw_tb;
    logic reset_tb;
    logic clk_tb;
    logic db_tb;

    localparam N = db_time_tb;

    early_debouncer #(.db_time(db_time_tb))GEN_TB(
        .sw(sw_tb),
        .reset(reset_tb),
        .clk(clk_tb),
        .db(db_tb)
    );    
    
    initial
    begin
        //Initialization
        clk_tb = 1'b1;
        reset_tb = 1'b1;
        sw_tb = 1'b0;
        repeat(N)@(negedge clk_tb);
        reset_tb = 1'b0;

        //Timed Testing
        repeat(N)@(negedge clk_tb);
        
        //Bouncing - Rising Edge
        sw_tb = 1'b1;
        #1 sw_tb = 1'b0;
        #1 sw_tb =1'b1;
        #1 sw_tb = 1'b0;
        #2 sw_tb = 1'b1;
        #1 sw_tb = 1'b0;
        #1 sw_tb = 1'b1;

        //Active Cycle
        repeat(3*N)@(negedge clk_tb);

        //Bouncing - Falling Edge
        sw_tb = 1'b0;
        #1 sw_tb = 1'b1;
        #1 sw_tb =1'b0;
        #1 sw_tb = 1'b1;
        #2 sw_tb = 1'b0;
        #1 sw_tb = 1'b1;
        #1 sw_tb = 1'b0;

        repeat(2*N-2)@(negedge clk_tb);
        
        //Glitches
        //sw_tb = 1'b1;
        //#1 sw_tb = 1'b0;
        //repeat(N)@(negedge clk_tb);
        //sw_tb = 1'b1;
        //#1 sw_tb = 1'b0;
        //repeat(4*N)@(negedge clk_tb);
        
        $finish;
    end

    always
    begin
        #0.5 clk_tb = ~clk_tb;
    end

endmodule
