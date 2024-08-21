`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abrar Ul haq Sanadi
// 
// Create Date: 12.08.2024 16:28:13
// Design Name: FIFO Wrapper
// Module Name: FIFO
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
// Design a FIFO Wrapper file


`include "async_fifo.v"
`include "async_fifo_1.v"


module FIFO#(parameter SIZE=32,
		       DEPTH=250
                       )
(
	input logic AXI_CLK,
	input logic SD_CLK,
	input logic ARESETn,

	input logic AXIL_WR_ADDR_EN,	
	input logic AXIL_WR_DATA_EN,
	input logic AXIL_RD_ADDR_EN,	
	input logic AXIL_RD_DATA_EN,

	input logic SD_RD_ADDR_EN,	
	input logic SD_RD_DATA_EN,
	input logic SD_WR_ADDR_EN,	
	input logic SD_WR_DATA_EN,

        input  logic SD_RW_EN,                  //
        input  logic AXIL_RW_EN,                //
        input  logic AXIL_RW_IN,                //
        output logic SD_RW_OUT,  

	input  logic [SIZE-1:0] AXIL_WR_ADDR_IN,	
	input  logic [SIZE-1:0] AXIL_WR_DATA_IN,
	input logic [SIZE-1:0] AXIL_RD_ADDR_IN,	
	output logic [SIZE-1:0] AXIL_RD_DATA_OUT,

	output logic [SIZE-1:0] SD_WR_ADDR_OUT,	
	output logic [SIZE-1:0] SD_WR_DATA_OUT,
	output logic [SIZE-1:0] SD_RD_ADDR_OUT,	
	input  logic [SIZE-1:0] SD_RD_DATA_IN,

	output WADDR_FIFO_FULL,
	output WADDR_FIFO_EMPTY,
	output WDATA_FIFO_FULL,
	output WDATA_FIFO_EMPTY,
	output RADDR_FIFO_FULL,
	output RADDR_FIFO_EMPTY,
	output RDATA_FIFO_FULL,
	output RDATA_FIFO_EMPTY,
        output RW_FIFO_FULL,                    
        output RW_FIFO_EMPTY 
	
);

async_fifo WADDR_FIFO(
        .rd_clk(SD_CLK),				//SD_clk
        .wr_clk(AXI_CLK),				//AXI_clk
        .reset_n(ARESETn),
        .rd_en(SD_WR_ADDR_EN),
        .wr_en(AXIL_WR_ADDR_EN),
        .data_in(AXIL_WR_ADDR_IN),
        .data_out(SD_WR_ADDR_OUT),
        .fifo_empty(WADDR_FIFO_EMPTY),
        .fifo_full(WADDR_FIFO_FULL)
    );



async_fifo WDATA_FIFO(	
        .rd_clk(SD_CLK),				//SD_clk
        .wr_clk(AXI_CLK),				//AXI_clk
        .reset_n(ARESETn),
        .rd_en(SD_WR_DATA_EN),
        .wr_en(AXIL_WR_DATA_EN),
        .data_in(AXIL_WR_DATA_IN),
        .data_out(SD_WR_DATA_OUT),
        .fifo_empty(WDATA_FIFO_EMPTY),
        .fifo_full(WDATA_FIFO_FULL)
    );

async_fifo RADDR_FIFO(
        .rd_clk(SD_CLK),				//AXI_clk
        .wr_clk(AXI_CLK),				//SD_clk
        .reset_n(ARESETn),
        .rd_en(SD_RD_ADDR_EN),
        .wr_en(AXIL_RD_ADDR_EN),
        .data_in(AXIL_RD_ADDR_IN),
        .data_out(SD_RD_ADDR_OUT),
        .fifo_empty(RADDR_FIFO_EMPTY),
        .fifo_full(RADDR_FIFO_FULL)
    );


async_fifo RDATA_FIFO(
        .rd_clk(AXI_CLK),				//AXI_clk
        .wr_clk(SD_CLK),				//SD_clk
        .reset_n(ARESETn),
        .rd_en(AXIL_RD_DATA_EN),
        .wr_en(SD_RD_DATA_EN),
        .data_in(SD_RD_DATA_IN),
        .data_out(AXIL_RD_DATA_OUT),
        .fifo_empty(RDATA_FIFO_EMPTY),
        .fifo_full(RDATA_FIFO_FULL)
    );



async_fifo_1 RW_FIFO(
        .rd_clk(SD_CLK),                               //AXI_clk
        .wr_clk(AXI_CLK),                                //SD_clk
        .reset_n(ARESETn),
        .rd_en(SD_RW_EN),
        .wr_en(AXIL_RW_EN),
        .data_in(AXIL_RW_IN),
        .data_out(SD_RW_OUT),
        .fifo_empty(RW_FIFO_EMPTY),
        .fifo_full(RW_FIFO_FULL)
    );

endmodule : FIFO