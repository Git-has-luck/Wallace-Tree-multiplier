`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 00:12:07
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
    input [n-1:0] a,
    input [n-1:0] b,
    output [2*n-1:0] y
    );
    typedef reg[31:0] array2d[31:0];
    function automatic int range(input int count);
        integer sac,stage;
        begin
        sac =0; stage =0;
        while(count>2) begin
            count=(count/3)*2 + (count%3);
            sac=sac+count;
            stage=stage+1;
        end
        range={sac[15:0],stage[15:0]};
        end
    endfunction
    localparam [31:0]temp=range(n);
    localparam [15:0] sac = temp[31:16];
    localparam [15:0] stage=temp[15:0];
    function automatic array2d array(input int count);
        array2d arr;
        integer it,sac;
        begin 
        it=1;sac=0;arr[0]=0;
        while (count>2) begin
            count=(count/3)*2 + (count%3);
            sac=sac+count;
            arr[it]=sac[31:0];
            it++;
        end
        array=arr;
        end
    endfunction
    localparam array2d arr=array(n);
    genvar i,j,k; 
    wire[2*n-2:0] p [n-1:0];
    wire [2*n-1:0] ip[sac-1:0];
    for(i=0; i<n; i++) begin 
        for(j=0; j<2*n-1; j++) begin
            if(j>=i && j<i+n)
                assign p[i][j] = a[j-i]&b[i];
            else 
                assign p[i][j]=0;
        end
    end
    generate 
        for(i=0;i<n/3+n%3;i++) begin
            if(i<n/3) begin
                assign ip[2*i+1][0]=0;
                assign ip[2*i][2*n-1]=0;
                assign ip[2*i+1][2*n-1]=0;
            end
            else 
                assign ip[(n/3)+i][2*n-1]=0;
            for(j=0;j<2*n-1;j++) begin 
                if (i<n/3) begin
                    if(j==3*i) begin
                        assign ip[2*i][j]=p[3*i][j];
                        assign ip[2*i+1][j+1]=0;
                        assign ip[2*i+1][j]=0;
                    end
                    else if(j==3*i+1)
                        halfadder ha(p[3*i][j],p[3*i+1][j],ip[2*i][j],ip[2*i+1][j+1]);
                    else if(j==3*i+n+1) begin
                        assign ip[2*i][j]=p[3*i+2][j];
                        assign ip[2*i+1][j+1]=0;
                    end
                    else if(j==3*i+n)
                        halfadder ha(p[3*i+1][j],p[3*i+2][j],ip[2*i][j],ip[2*i+1][j+1]);
                    else if((j>3*i+1)&&(j<3*i+n))
                        fulladder fa(p[3*i][j],p[3*i+1][j],p[3*i+2][j],ip[2*i][j],ip[2*i+1][j+1]);
                    else begin
                        assign ip[2*i][j]=0;
                        assign ip[2*i+1][j]=0;
                    end
                end
                else
                    assign ip[(n/3)+i][j]=p[2*(n/3)+i][j];
             end
        end 
    endgenerate
    generate
        for(k=0;k<stage-1;k++) begin
            for(i=0;i < (arr[k+1] - arr[k]) /3 + (arr[k+1] - arr[k]) %3 ;i++) begin 
                if(i < ( arr[k+1]- arr[k]) /3 ) begin
                    assign ip[arr[k+1]+2*i+1][0]=0;
                    assign ip[arr[k+1]+2*i][2*n-1]=0;
                end
                else 
                    assign ip[arr[k+1]+ (arr[k+1]- arr[k]) /3 +i][2*n-1]=ip[arr[k]+2*((arr[k+1]- arr[k]) /3)+i][2*n-1];
                for(j=0;j<2*n-1;j++) begin
                    if (i < ( arr[k+1]- arr[k]) /3 )
                        fulladder fa(ip[arr[k]+3*i][j],ip[arr[k]+3*i+1][j],ip[arr[k]+3*i+2][j],ip[arr[k+1]+2*i][j],ip[arr[k+1]+2*i+1][j+1]);
                    else
                        assign ip[arr[k+1]+ (arr[k+1]- arr[k]) /3 +i][j]=ip[arr[k]+2*((arr[k+1]- arr[k]) /3)+i][j];
                end
            end
        end
    endgenerate 
    wire cout;
    nbitadder #(2*n)add(ip[sac-1],ip[sac-2],y,cout);    
endmodule

