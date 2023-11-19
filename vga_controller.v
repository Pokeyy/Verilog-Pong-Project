`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2023 05:33:36 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input clk_100MHz,                                                   // clk from A50/A100T
    input reset,                                                        // master reset
    output video_ON,                                                    // output video is ON when x & y are within display area
    output hori_sync,                                                       // horizontal sync
    output vert_sync,                                                       // vertical sync
    output pixel_tick,                                                  // 25MHz pixel/second rate signal, pixel tick from clk_manager
    output [9:0] pixel_x,                                               // pixel count/position of pixel x, 0-799
    output [9:0] pixel_y                                                // pixel count/position of pixel y, 0-524
    );
    
    // This VGA Display will be using standard of 640x480 resolution
    
    // Total horizontal width of screen = 800 pixels, split into sections 
    parameter HORI_DISP_AREA = 640;                                     // horizontal display area width in pixels
    parameter HORI_FRONT_PORCH = 48;                                    // horizontal front porch width in pixels
    parameter HORI_BACK_PORCH = 16;                                     // horizontal back porch width in pixels
    parameter HORI_RETRACE = 96;                                        // horizontal retrace width in pixels   
    parameter HORI_MAX =  HORI_DISP_AREA +                              // max value of horizontal counter = 799 (0 - 799)
    HORI_FRONT_PORCH + HORI_BACK_PORCH +
    HORI_RETRACE - 1;
    
    // Total vertical width of screen = 525 pixels, split into sections 
    parameter VERT_DISP_AREA = 480;                                     // horizontal display area width in pixels
    parameter VERT_FRONT_PORCH = 10;                                    // horizontal front porch width in pixels
    parameter VERT_BACK_PORCH = 33;                                     // horizontal back porch width in pixels
    parameter VERT_RETRACE = 2;                                         // horizontal retrace width in pixels 
    parameter VERT_MAX =  VERT_DISP_AREA +                              // max value of horizontal counter = 799 (0 - 799)
    VERT_FRONT_PORCH + VERT_BACK_PORCH +                                // max value of vertical counter = 524 (0 - 524)
    VERT_RETRACE - 1;
    
    // Generate 25MHz CLK from 100MHz
    reg [1:0] tmp_25MHz;
    wire out_25MHz;
    always @(posedge clk_100MHz or posedge reset)
        if (reset)
            tmp_25MHz <= 0;
        else 
            tmp_25MHz <= tmp_25MHz + 1;
            
        assign out_25MHz = (tmp_25MHz == 0) ? 1 : 0;                        // outputs clock after counter goes up
                                                                            // four times, so 1/4 of the time
    
    // Counter Registers. Two registers for both Horizontal and Vertical for buffering to avoid glitches.
    reg [9:0] hori_count_reg, hori_count_next;
    reg [9:0] vert_count_reg, vert_count_next;
    
    // Output Buffers
    reg vert_sync_reg, hori_sync_reg;
    wire vert_sync_next, hori_sync_next;
    
    always @(posedge clk_100MHz or posedge reset)
        if (reset)
        begin                                                           // Set registers to 0
            vert_count_reg <= 0;
            hori_count_reg <= 0;
            vert_sync_reg <= 1'b0;
            hori_sync_reg <= 1'b0;
        end
        else
        begin                                                           // Buffer registers
            vert_count_reg <= vert_count_next;
            hori_count_reg <= hori_count_next;
            vert_sync_reg <= vert_sync_next;
            hori_sync_reg <= hori_sync_next;
        end
        
    // Logic for Horizontal Counter
    always @(posedge out_25MHz or posedge reset)                        // Pixel Tick 25MHz
        if (reset)
            hori_count_next = 0;
        else 
            if(hori_count_reg == HORI_MAX)                              // End of horizontal scan
                hori_count_next = 0;
            else
                hori_count_next = hori_count_reg + 1;                   // If not at the end of horizontal scan, check next pixel
                
    // Logic for Vertical Counter
    always @(posedge out_25MHz or posedge reset)                        // Pixel Tick 25MHz
            if (reset)
                vert_count_next = 0;
            else 
                if(hori_count_reg == HORI_MAX)                          // Check if at end of horizontal scan
                //begin
                    if((vert_count_reg == VERT_MAX))                    // Then check if at vertical max, 
                        vert_count_next = 0;                            // if so go back to 0 (top of disp)
                //end
                        
                    else
                        vert_count_next = vert_count_reg + 1;           // If not at end of vertical disp but at 
                                                                        // end of horizontal disp, go to next line
    
    // Horizontal Sync asserted within the horizontal retrace area
    assign hori_sync_next = (hori_count_reg >= (HORI_DISP_AREA +        // Horizontal Sync occurs during Retrace
         HORI_BACK_PORCH) && hori_count_reg <= (HORI_DISP_AREA +        // which is after the DISP_AREA + Back Porch
                           HORI_BACK_PORCH + HORI_RETRACE - 1));        // up until Front Porch - 1
   
   // Vertical Sync asserted within the Vertical retrace area
   assign vert_sync_next = (vert_count_reg >= (VERT_DISP_AREA +         // Vertical Sync occurs during Retrace
        VERT_BACK_PORCH) && vert_count_reg <= (VERT_DISP_AREA +         // which is after the DISP_AREA + Back Porch
                          VERT_BACK_PORCH + VERT_RETRACE - 1));         // up until Front Porch - 1
                          
  assign video_ON = (hori_count_reg < HORI_DISP_AREA) &&                // Video on only within x of 0-639 (<640)
                      (vert_count_reg < VERT_DISP_AREA);                // and y of 0-479 (<480)      
                                                                        
    // Outputs
    assign hori_sync = hori_sync_reg;
    assign vert_sync = vert_sync_reg;
    assign pixel_x = hori_count_reg;
    assign pixel_y = vert_count_reg;
    assign pixel_tick = out_25MHz;
    
endmodule
