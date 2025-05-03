`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 04:54:50
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
    parameter n=8;
    reg[n-1:0] a,b;
    wire[2*n-1:0] y;
    wallacetree #(n)DUT(a,b,y);
    initial begin 
    a=8'd117;b=8'd224;
    #10$finish;
    end
endmodule
