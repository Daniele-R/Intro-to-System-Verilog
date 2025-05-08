module vga_top 
   #(parameter CD = 12)    // color depth
   (
    input  logic clk,
    input  logic [15:0] sw,
    // to vga monitor
    output logic hsync, vsync,
    output logic[CD-1:0] rgb
   );

   // logic [CD-1:0] declaration
   logic [10:0] hc, vc;
   logic [CD-1:0] sqr_rgb, in_rgb, gray_rgb, color_rgb, vga_rgb;
   logic [1:0] sqr_size;
   logic bypass_sqr, bypass_gray;
   
   // body
   // use switches to set background color
   assign in_rgb = sw[11:0];
   assign sqr_size = sw[13:12];
   assign bypass_sqr = sw[14];
   assign bypass_gray = sw[15];
   // instantiate square pattern generator
   square_pattern square_unit  
      (
         .clk(clk),
         .reset(0),
         .x(hc),
         .y(vc),
         .size_sel(sqr_size),
         .rgb(in_rgb),
         .sqr_rgb(sqr_rgb)
      );
   // instantiate color-to-gray conversion circuit
   rgb2gray c2g_unit  
      (.color_rgb(color_rgb), .gray_rgb(gray_rgb));
   // instantiate video synchronization circuit
   vga_sync_demo #(.CD(CD)) sync_unit
      (.clk(clk), .reset(0), .vga_si_rgb(vga_rgb),
       .hsync(hsync), .vsync(vsync), .rgb(rgb), .hc(hc), .vc(vc));
   // video source selection mux #1  
   assign color_rgb = (bypass_sqr) ? in_rgb : sqr_rgb;
   // video source selection mux #0  
   assign vga_rgb = (bypass_gray) ? color_rgb : gray_rgb;
endmodule