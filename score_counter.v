`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 07:02:05 PM
// Design Name: 
// Module Name: score_counter
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


module score_counter(
    input clk,
    input reset,
    input d_inc,
    input d_clr,
    output [3:0] dig0,
    output [3:0] dig1
    );
    
    
    reg [3:0] r_dig0, r_dig1, dig0_next, dig1_next; // transistion state 
    
    //register control
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            r_dig1 <=0;
            r_dig0 <=0;
        end
      
        else
        begin
            r_dig1 <= dig1_next;
            r_dig0 <= dig0_next;
        end        
    end
    // next state logic 
    always @(posedge clk or posedge reset) 
    begin
        dig0_next <= r_dig0;
        dig1_next <= r_dig1;
    
        if(d_clr) 
        begin
            dig0_next <= 0;
            dig1_next <= 0;
        end
       
        else if (d_inc)
            if (r_dig0 == 9) //overflow at dig0 place
            begin
                dig0_next <= 0;
             
            if(r_dig1 == 9) // overflow at digit1 place
                dig1_next <= 0;
            else
                dig1_next <= r_dig1 + 1;
        end
        
        else 
            dig0_next <= r_dig0 + 1;
    end
    
    assign dig0 = r_dig0;
    assign dig1 = r_dig1;
    

endmodule
