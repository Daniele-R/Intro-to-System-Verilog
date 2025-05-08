`timescale 1ns / 1ps

module top_tb();
    logic [3:0] m_tb, n_tb;
    logic sys_clk_tb, sys_rst_tb;
    logic ff_rst_tb;
    logic pulse_tb;
    
    top GEN_TB 
    (
        .m(m_tb), 
        .n(n_tb),
        .sys_clk(sys_clk_tb),
        .sys_rst(sys_rst_tb),
        .ff_rst(ff_rst_tb),
        .pulse(pulse_tb)
    );
    
    always
    begin
        #5 sys_clk_tb = ~sys_clk_tb;
    end
    
    initial
    begin
        //Initialization
        sys_clk_tb = 1'b0;
        sys_rst_tb = 1'b1;
        ff_rst_tb = 1'b1;
        m_tb = 4'd1; n_tb = 4'd1;
        @(negedge sys_clk_tb);
        sys_rst_tb = 1'b0;
        ff_rst_tb = 1'b0;
        
        //Testing Square Wave
        repeat(100) @(negedge sys_clk_tb);
        m_tb = 4'd3;
        repeat(200) @(negedge sys_clk_tb);
        m_tb = 4'd1; n_tb = 4'd3;
        repeat(200) @(negedge sys_clk_tb);
        $finish;
    end

endmodule
