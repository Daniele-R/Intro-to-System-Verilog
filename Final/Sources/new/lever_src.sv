`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 10:40:45 PM
// Design Name: 
// Module Name: lever_src
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


module lever_src
  #(
    parameter CD = 12,      // color depth
              ADDR = 10,    // number of address bits
              KEY_COLOR =0  // chroma key
   )
   (
   input  logic clk,
    input  logic [10:0] x, y,   // x-and  y-coordinate    
    input  logic [10:0] x0, y0, // origin of sprite 
    input logic [1:0] ctrl, //sprite control
    // sprite ram write 
    input  logic we ,
    input  logic [ADDR-1:0] addr_w,
    input  logic pixel_in,
    // pixel output
    output logic [CD-1:0] lever_rgb
   );
   
   // localparam declaration
   localparam H_SIZE = 16; // horizontal size of sprite
   localparam V_SIZE = 32; // vertical size of sprite
   
   // signal delaration
   logic signed [11:0] xr, yr;  // relative x/y position
   logic in_region;
   logic [ADDR-1:0] addr_r;
   logic sid;             // sprite id  
   logic plt_code; 
   logic frame_tick, ani_tick;
   logic [3:0] c_next;        
   logic [3:0] c_reg;        
   logic [1:0] ani_next;        
   logic [1:0] ani_reg;        
   logic [10:0] x_d1_reg;
   logic [CD-1:0] full_rgb, out_rgb;
   logic [CD-1:0] out_rgb_d1_reg;
   logic gc_id_sel;        
   logic auto;
   
   // body
   assign gc_id_sel = ctrl[0]; //ctrl is 1 bit
   assign auto = ctrl[1];
   
   
   // instantiate sprite RAM
   lever_ram_lut #(.ADDR_WIDTH(ADDR),.DATA_WIDTH(1)) ram_unit (
      .clk(clk), .we(we), .addr_w(addr_w), .din(pixel_in),
      .addr_r(addr_r), .dout(plt_code));
      
   assign addr_r = {sid, yr[5:0], xr[4:0]};
   
   // palette table
   always_comb
      case (plt_code)
         1'b0:   full_rgb = 12'h000;   // chrome key
         1'b1:   full_rgb = 12'h111;   // dark gray 
         //default: full_rgb = 12'hfff;   // white
      endcase
   
   
   // relative coordinate calculation
   assign xr = $signed({1'b0, x}) - $signed({1'b0, x0});
   assign yr = $signed({1'b0, y}) - $signed({1'b0, y0});
   // in-region comparison and multiplexing 
   assign in_region = ((0<= xr) && (xr<H_SIZE) && (0<=yr) && (yr<V_SIZE));
   assign out_rgb = in_region ? full_rgb : KEY_COLOR;
   
   
   //******************************************************************
   // animation timing control
   //******************************************************************
   // counters 
   always_ff @(posedge clk) begin
      x_d1_reg <= x;
      c_reg <= c_next;
      ani_reg <= ani_next;
   end
   assign c_next = (frame_tick && c_reg==9) ? 0 :
                   (frame_tick) ? c_reg + 1 :
                    c_reg; 
   assign ani_next = (ani_tick) ? ani_reg + 1 : ani_reg;
   // 60-Hz tick from fram counter 
   assign frame_tick = (x_d1_reg==0) && (x==1) && (y==0);
   // sprite animation id tick 
   assign ani_tick  = frame_tick  && (c_reg==0); 
   // sprite id selection
   assign sid = (auto) ? ani_reg : gc_id_sel;
   
   
   // output with a-stage delay line
   always_ff @(posedge clk) 
      out_rgb_d1_reg <= out_rgb;
   assign sprite_rgb = out_rgb_d1_reg;
   
endmodule
