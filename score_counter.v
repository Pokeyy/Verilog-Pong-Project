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
    input [1:0] d_inc,
    input d_clr,
    output [3:0] dig0,
    output [3:0] dig1,
    output [3:0] dig2,
    output [3:0] dig3
    );
    
    
    reg [3:0] r_dig0, r_dig1, dig0_next, dig1_next; // transistion state 
    reg [3:0] r_dig2, r_dig3, dig2_next, dig3_next; // transistion state 
    
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
    always @* 
    begin
        dig0_next <= r_dig0;
        dig1_next <= r_dig1;
        dig2_next <= r_dig2;
        dig3_next <= r_dig3;
    
        if(d_clr) 
        begin
            dig0_next <= 0;
            dig1_next <= 0;
            dig2_next <= 0;
            dig3_next <= 0;
        end
       
        else if (d_inc[0])
        begin
            if (r_dig0 == 9) //overflow at dig0 place
                dig0_next <= 0;
             
            if(r_dig1 == 9) // overflow at digit1 place
                dig1_next <= 0;
            else
                dig1_next <= r_dig1 + 1;
        end
       
        else if (d_inc[1])
        begin
            if (r_dig2 == 9) //overflow at dig0 place
                dig2_next <= 0;
             
            if(r_dig3 == 9) // overflow at digit1 place
                dig3_next <= 0;
            else
                dig3_next <= r_dig3 + 1;
        end
        
        else 
        begin
            dig0_next <= r_dig0 + 1;
            dig2_next <= r_dig2 + 1;
        end
    end
    
    assign dig0 = r_dig0;
    assign dig1 = r_dig1;
    assign dig2 = r_dig2;
    assign dig3 = r_dig3;
    

endmodule
