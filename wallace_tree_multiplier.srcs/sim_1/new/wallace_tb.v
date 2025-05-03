`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2025 13:02:09
// Design Name: 
// Module Name: wallace_tb
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


module wallace_tb(

    );
    reg [3:0]a,b;
    wire y;
    wallacetree DUT(a,b,y);
    initial begin 
        a=4'd5;b=4'b1010;
        #200 $finish;
    end
endmodule
