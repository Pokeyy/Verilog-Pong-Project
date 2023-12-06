`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 06:10:02 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
        input clk,
        input btn_in_1,
        input btn_in_2,
        output btn_out_1,
        output btn_out_2
    );
    
    reg [4:0] cnt0, cnt1;
    reg iv0 = 0,iv1 = 0;
    reg out0, out1;
    
    always@(posedge(clk))
    begin
        if(btn_in_1 == iv0)
        begin
            if (cnt0 == 19)
                out0 <= btn_in_1;
            else
                cnt0 <= cnt0+1;
          end
        else begin
            cnt0 <= 4'b00000;
            iv0 <= btn_in_1;
        end
        if (btn_in_2 == iv1)begin
            if (cnt1 == 19)
                out1 <= btn_in_2;
            else
                cnt1 <= cnt1+1;
        end
        else
        begin
            cnt1 <= 4'b00000;
            iv1 <= btn_in_2;
        end
    end
  
    assign btn_out_1 = out0;
    assign btn_out_2 = out1;
   
endmodule
