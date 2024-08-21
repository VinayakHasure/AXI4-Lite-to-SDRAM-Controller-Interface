`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abrar Ul haq Sanadi
// 
// Create Date: 10.08.2024 16:28:13
// Design Name: Asynchronous Fifo
// Module Name: async_fifo
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


module async_fifo
  #(parameter integer DATA_SIZE = 32, DEPTH = 250, WIDTH=8)
    (
                input rd_clk,
                input wr_clk,
                
                input reset_n,

                input rd_en,
                input wr_en,
                
                
                output fifo_full,
                output fifo_empty,
        
                input   [DATA_SIZE-1:0]   data_in,
                output  [DATA_SIZE-1:0]   data_out
                
    );

reg [DATA_SIZE-1:0] FIFO [0:DEPTH-1];
reg [WIDTH-1:0]wr_ptr;
reg [WIDTH-1:0]rd_ptr;

reg [WIDTH-1:0]rd_ptr1;
reg [WIDTH-1:0]rd_ptr2;
reg [WIDTH-1:0]rd_ptr3;

reg [WIDTH-1:0]wr_ptr1;
reg [WIDTH-1:0]wr_ptr2;
reg [WIDTH-1:0]wr_ptr3;


reg [DATA_SIZE-1:0]temp_data_out ;

    //write into fifo logic 
    always @(posedge wr_clk or negedge reset_n)
    begin
        if(~reset_n)
            begin
                FIFO[wr_ptr] <= 'b0;
                wr_ptr       <= 'b0;
            end
        else if(wr_en && !fifo_full)
            begin
                FIFO[wr_ptr] <= data_in ;
                if(data_in) begin
                    wr_ptr       <= wr_ptr + 1 ;
                end
            end
    end   
   
    // read from fifo logic 
    always @(posedge rd_clk or negedge reset_n)
    begin
        if(!reset_n)
            begin
                temp_data_out   <= 'b0;
                rd_ptr          <= 'b0;   
            end
            
        else if (rd_en && !fifo_empty)
            begin
                temp_data_out   <= FIFO[rd_ptr];
                rd_ptr          <= rd_ptr + 1;
             end
    end
    assign data_out = temp_data_out;
    
    //deploy the synchronizers
    //read pointer synchroniser in the write clock domain
    // we are delaying the rd_ptr by two clk cycles wrt wr_clk so as to avoid the metastability issues
    
    always @(posedge wr_clk or negedge reset_n)
    begin
        if(!reset_n)
        begin
            rd_ptr  <= 'b0;
            rd_ptr1 <= 'b0;
            rd_ptr2 <= 'b0;
            rd_ptr3 <= 'b0;
        end
        else
        begin
      //      rd_ptr  <= rd_ptr;
            rd_ptr1 <= rd_ptr;
            rd_ptr2 <= rd_ptr1;
            rd_ptr3 <= rd_ptr2;
        end
    end
    
    //write pointer synchoniser in the read clock domain
    //we are synchroizing the write pointer in the read domain wrt rd_ptr so as to avoid the metastability issues
    always @(posedge rd_clk or negedge reset_n)
    begin
        if(!reset_n)
        begin
            wr_ptr <=  'b0;
            wr_ptr1 <= 'b0;
            wr_ptr2 <= 'b0;
            wr_ptr3 <= 'b0;
        end
        else
        begin
       //     wr_ptr  <= wr_ptr;
            wr_ptr1 <= wr_ptr;
            wr_ptr2  <= wr_ptr1;
            wr_ptr3  <= wr_ptr2;
        end
    end
    
    
    assign fifo_full =  (rd_ptr3 + DEPTH == wr_ptr) ;
    assign fifo_empty = (rd_ptr == wr_ptr3 );

endmodule