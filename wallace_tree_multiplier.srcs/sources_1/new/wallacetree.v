`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 12:24:08
// Design Name: 
// Module Name: wallacetree
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


module wallacetree #(parameter n=4)(
    input [3:0] a,
    input [3:0] b,
    output [7:0] y
    );
    function integer range(input integer dummy);
        automatic integer count,sac,it,stage;
        begin
        count = 4; sac = 16'b0; it = 0; stage = 16'b0;
        while(count>2) begin
            count=(count/3)*2 + (count%3);
            sac=sac+count;
            stage=stage+1;
        end
        range={sac,stage};
        end
    endfunction
    integer start =0;
    integer finish=2*(4/3)+4%3;
    wire [31:0]temp=range(0);
    localparam sac=temp[31:16];
    localparam stage=temp[15:0];
    genvar i,j;
    wire[6:0] p [3:0];
    wire [7:0] ip[sac:0];
    for(i=0; i<4; i=i+1) begin 
        for(j=0; j<7; j=j+1) begin
            if(j>=i && j<i+4)
                assign p[i][j] = a[j-i]&b[i];
            else 
                assign p[i][j]=0;
        end
    end
    generate 
        for(i=0;i<2*(4-(4/3));i=i+1) begin
            if(i<4/3) begin
                assign ip[2*i+1][0]=0;
                assign ip[2*i][7]=0;
            end
            for(j=0;j<7;j=j+1) begin
                if (i<4/3)
                    fulladder fa(p[3*i][j],p[3*i+1][j],p[3*i+2][j],ip[2*i][j],ip[2*i+1][j+1]);
                else
                    assign ip[(4/3)+i][j]=p[2*(4/3)+i][j];
             end
        end 
    endgenerate
    generate
        for(i=0;i<stage;i=i+1) begin
            for(i=start;i<finish;i=i+1) begin 
                if(i<finish/3) begin
                    assign ip[finish+2*i+1][0]=0;
                    assign ip[finish+2*i][7]=0;
                end
                for(j=0;j<7;j=j+1) begin
                    fulladder fa(ip[3*i][j],ip[3*i+1][j],ip[3*i+2][j],ip[finish][j],ip[finish+1][j+1]);
                end
            end
        end
    endgenerate     
endmodule
