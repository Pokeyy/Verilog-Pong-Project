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
    input btn_in,
    input btn_out
    );
    
    reg r1,r2,r3;
    
    always@(posedge clk) 
    begin 
    r1 <= btn_in;
    r2 <= r1;
    r3 <= r2;
    end
  
 assign btn_out = r3;
   
endmodule
