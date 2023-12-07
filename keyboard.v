`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 03:14:34 PM
// Design Name: 
// Module Name: keyboard
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


module keyboard(
        input keyboard_clk,         // CLK100MHZ
        input keyboard_kclk,        // PS2_CLK
        input keyboard_kdata,       // PS2_DATA
        output keyboard_uart_rxd,   // UART_RXD_OUT
        output [3:0] keyboard_out
    );
    
    
    wire keyboard_kclkf, keyboard_kdataf;
    reg keyboard_clk_tmp = 0;
    reg [7:0] keyboard_datacur;
    reg [7:0] keyboard_dataprev;
    reg [3:0] keyboard_cnt;
    reg [31:0] keyboard_keycode;
    reg keyboard_flag;
    reg [3:0] keyboard_out_tmp = 0;
    
    always@(posedge keyboard_clk)
    begin
        keyboard_clk_tmp = ~keyboard_clk_tmp;
    end
    initial 
    begin
        keyboard_keycode[31:0] <= 32'h00000000;
        keyboard_cnt <= 4'b0000;
        keyboard_flag <= 1'b0;
    end
    
    debounce keyboard_debounce(
        .clk(keyboard_clk_tmp),
        .btn_in_1(keyboard_kclk),
        .btn_in_2(keyboard_kdata),
        .btn_out_1(keyboard_kclkf),
        .btn_out_2(keyboard_kdataf)
    );
        
    always@(negedge(keyboard_kclkf))
    begin
        case(keyboard_cnt)
            0:;//Start bit
            1: keyboard_datacur[0] <= keyboard_kdataf;
            2: keyboard_datacur[1] <= keyboard_kdataf;
            3: keyboard_datacur[2] <= keyboard_kdataf;
            4: keyboard_datacur[3] <= keyboard_kdataf;
            5: keyboard_datacur[4] <= keyboard_kdataf;
            6: keyboard_datacur[5] <= keyboard_kdataf;
            7: keyboard_datacur[6] <= keyboard_kdataf;
            8: keyboard_datacur[7] <= keyboard_kdataf;
            9: keyboard_flag <= 1'b1;
            10: keyboard_flag <= 1'b0;
        
        endcase
            if(keyboard_cnt <= 9)
                keyboard_cnt <= keyboard_cnt+1;
            else if(keyboard_cnt == 10)
                keyboard_cnt <= 0;
            
    end
    
    always @(posedge keyboard_flag)
    begin //write keyboard data into an array
        if (keyboard_dataprev != keyboard_datacur)
        begin
            keyboard_keycode[31:24] <= keyboard_keycode[23:16];
            keyboard_keycode[23:16] <= keyboard_keycode[15:8];
            keyboard_keycode[15:8] <= keyboard_dataprev;
            keyboard_keycode[7:0] <= keyboard_datacur;
            keyboard_dataprev <= keyboard_datacur;
        end
    end
    
    always@(*)
    begin
        //up arrow
        if(keyboard_keycode[15:0] == 16'hE075)
            keyboard_out_tmp[0] <= 1;
        else if(keyboard_keycode[15:0] == 16'hF075)
            keyboard_out_tmp[0] <= 0;
        //down arrow
        if(keyboard_keycode[15:0] == 16'hE072)
            keyboard_out_tmp[1] <= 1;
        else if(keyboard_keycode[15:0] == 16'hF072)
            keyboard_out_tmp[1] <= 0;
        //w
        if(keyboard_keycode[15:8] != 8'hF0 && keyboard_keycode[7:0] == 8'h1D)
            keyboard_out_tmp[2] <= 1;
        else if(keyboard_keycode[15:0] == 16'hF01D)
            keyboard_out_tmp[2] <= 0;
        //s
        if(keyboard_keycode[15:8] != 8'hF0 && keyboard_keycode[7:0] == 8'h1B)
            keyboard_out_tmp[3] <= 1;
        else if(keyboard_keycode[15:0] == 16'hF01B)
            keyboard_out_tmp[3] <= 0;
    end
        
    assign keyboard_out = keyboard_out_tmp;
endmodule
