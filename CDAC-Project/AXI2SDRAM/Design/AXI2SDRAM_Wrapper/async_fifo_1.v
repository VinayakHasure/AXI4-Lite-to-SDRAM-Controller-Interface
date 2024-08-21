`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abrar Ul haq Sanadi
// 
// Create Date: 11.08.2024 16:28:13
// Design Name: Asynchronous Fifo
// Module Name: async_fifo_1
// Project Name: AXIL-SDRAM controller Interface
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
// Design a async_fifo


module async_fifo_1#(parameter SIZE=32,WIDTH=6,DEPTH=60)(
        input rd_clk,
        input wr_clk,
        input reset_n,
        input rd_en,
        input wr_en,
        input data_in,
        output data_out,
        output fifo_empty,
        output fifo_full
    );
    
    reg data_out_reg;
    reg [WIDTH-1:0] rd_ptr;
    reg [WIDTH-1:0] wr_ptr;
    reg Data [DEPTH-1:0];
    
    
    reg [WIDTH-1:0] temp_rd_ptr;
    reg [WIDTH-1:0] temp_wr_ptr;
    reg [WIDTH-1:0] temp_rd_ptr_1;
    reg [WIDTH-1:0] temp_rd_ptr_2;
    reg [WIDTH-1:0] temp_wr_ptr_1;
    reg [WIDTH-1:0] temp_wr_ptr_2;
    
    //fifo write operation
    always@(posedge wr_clk,negedge reset_n)
    begin
        if(!reset_n) begin
            wr_ptr<=0;
            Data[wr_ptr+1]<='h00;
        end 
        else if(wr_en && !fifo_full) begin
            Data[wr_ptr]<=data_in;
            wr_ptr<=wr_ptr+1;
        end
    end
    
    //fifo read operation
    always@(posedge rd_clk,negedge reset_n)
    begin
        if(!reset_n) begin
            rd_ptr<=0;
            data_out_reg<=0; 
        end  
        else if(rd_en && !fifo_empty) begin
            data_out_reg<=Data[rd_ptr];
            rd_ptr<=rd_ptr+1;
        end
    end
    
    always@(posedge rd_clk,negedge reset_n)
    begin
        if(!reset_n) begin
             temp_wr_ptr<=0;
             temp_wr_ptr_1<=0;
             temp_wr_ptr_2<=0;
        end  
        else begin
            temp_wr_ptr<=wr_ptr;
            temp_wr_ptr_1<=temp_wr_ptr;
            temp_wr_ptr_2<=temp_wr_ptr_1;
        end
    end
    
    always@(posedge wr_clk,negedge reset_n)
    begin
        if(!reset_n) begin
             temp_rd_ptr<=0;
             temp_rd_ptr_1<=0;
             temp_rd_ptr_2<=0;
        end  
        else begin
            temp_rd_ptr<=rd_ptr;
            temp_rd_ptr_1<=temp_rd_ptr;
            temp_rd_ptr_2<=temp_rd_ptr_1;
        end
    end
    
    assign data_out = data_out_reg;
    assign fifo_full = (wr_ptr  == temp_rd_ptr_2 + DEPTH);
    assign fifo_empty = (temp_wr_ptr_2 == rd_ptr);
    
endmodule
