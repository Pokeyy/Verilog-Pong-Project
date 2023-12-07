`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 07:41:53 PM
// Design Name: 
// Module Name: top_pong
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

module pong_top(
    input clk,              // 100MHz
    input reset,            // btnR
    input key_clk,          // PS2_CLK
    input key_data,         // PS2_DATA
    output key_uart,        // UART_RXD_OUT
    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb       // to DAC, to VGA Connector
    );
    
    // state declarations for 4 states
    parameter newgame = 2'b00;
    parameter play    = 2'b01;
    parameter newball = 2'b10;
    parameter over    = 2'b11;
           
        
    // signal declaration
    reg [1:0] state_reg, state_next;
    wire [9:0] w_x, w_y;
    wire w_vid_on, w_p_tick, graph_on, hit, miss;
    wire [3:0] text_on;
    wire [11:0] graph_rgb, text_rgb;
    reg [11:0] rgb_reg, rgb_next;
    wire [3:0] dig0, dig1;
    reg gra_still, d_inc, d_clr, timer_start;
    wire timer_tick, timer_up;
    reg [1:0] ball_reg, ball_next;
    wire [3:0] keyboard_key; //[3:2] are left player; [1:0] are right player
    
    
    // Module Instantiations
    vga_controller vga_unit(
        .clk_100MHz(clk),
        .reset(reset),
        .video_on(w_vid_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y));
    
    pong_text text_unit(
        .clk(clk),
        .x(w_x),
        .y(w_y),
        .dig0(dig0),
        .dig1(dig1),
        .ball(ball_reg),
        .text_on(text_on),
        .text_rgb(text_rgb));
        
    pong_graph graph_unit(
        .clk(clk),
        .reset(reset),
        .btn(keyboard_key),
        .gra_still(gra_still),
        .video_on(w_vid_on),
        .x(w_x),
        .y(w_y),
        .hit(hit),
        .miss(miss),
        .graph_on(graph_on),
        .graph_rgb(graph_rgb));
    
    // 60 Hz tick when screen is refreshed
    assign timer_tick = (w_x == 0) && (w_y == 0);
    timer timer_unit(
        .clk(clk),
        .reset(reset),
        .timer_tick(timer_tick),
        .timer_start(timer_start),
        .timer_up(timer_up));
    
    score_counter counter_unit(
        .clk(clk),
        .reset(reset),
        .d_inc(d_inc),
        .d_clr(d_clr),
        .dig0(dig0),
        .dig1(dig1));
       
    keyboard keyboard_unit(
        .keyboard_clk(clk),
        .keyboard_kclk(key_clk),
        .keyboard_kdata(key_data),
        .keyboard_uart_rxd(key_uart),
        .keyboard_out(keyboard_key));
        
    // FSMD state and registers
    always @(posedge clk or posedge reset)
        if(reset) begin
            state_reg <= newgame;
            ball_reg <= 0;
            rgb_reg <= 0;
        end
    
        else begin
            state_reg <= state_next;
            ball_reg <= ball_next;
            if(w_p_tick)
                rgb_reg <= rgb_next;
        end
    
    // FSMD next state logic
    always @* begin
        gra_still = 1'b1;
        timer_start = 1'b0;
        d_inc = 1'b0;
        d_clr = 1'b0;
        state_next = state_reg;
        ball_next = ball_reg;
        
        case(state_reg)
            newgame: begin
                ball_next = 2'b11;          // three balls
                d_clr = 1'b1;               // clear score
                
                if((keyboard_key[1:0] != 0) || (keyboard_key[3:2] != 0)) begin      // button pressed
                    state_next = play;
                    ball_next = ball_reg - 1;    
                end
            end
            
            play: begin
                gra_still = 1'b0;   // animated screen
                
                if(hit)
                    d_inc = 1'b1;   // increment score
                
                else if(miss) begin
                    if(ball_reg == 0)
                        state_next = over;
                    
                    else
                        state_next = newball;
                    
                    timer_start = 1'b1;     // 2 sec timer
                    ball_next = ball_reg - 1;
                end
            end
            
            newball: // wait for 2 sec and until button pressed
            if(timer_up && ((keyboard_key[1:0] != 0) || (keyboard_key[3:2] != 0)))
                state_next = play;
                
            over:   // wait 2 sec to display game over
                if(timer_up)
                    state_next = newgame;
        endcase           
    end
    
    // rgb multiplexing
    always @*
        if(~w_vid_on)
            rgb_next = 12'h000; // blank
        
        else
            if(text_on[3] || ((state_reg == newgame) && text_on[1]) || ((state_reg == over) && text_on[0]))
                rgb_next = text_rgb;    // colors in pong_text
            
            else if(graph_on)
                rgb_next = graph_rgb;   // colors in graph_text
                
            else if(text_on[2])
                rgb_next = text_rgb;    // colors in pong_text
                
            else
                rgb_next = 12'h000;     // black background
    
    // output
    assign rgb = rgb_reg;
    
endmodule
