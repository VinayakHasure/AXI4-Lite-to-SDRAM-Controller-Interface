`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abrar Ul haq Sanadi
// 
// Create Date: 12.08.2024 16:28:13
// Design Name: FIFO SDRAM Interface
// Module Name: fifo_sdram_cntrl
// Project Name: AXIL-SDRAM Controller Interface
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
// Design a FIFO SDRAM Interface



module fifo_sdram_cntrl#(parameter 
                            ADDR_WIDTH  = 32,
                            HADDR_WIDTH = 24,
                            DATA_WIDTH = 16         //16 bits of data for 16M16
                         )
(
    //signals w.r.t. FIFO Side    
    input   logic SD_clk,
    input   logic ARESETn,

    output  logic SD_RD_ADDR_EN,
    output  logic SD_RD_DATA_EN,
    output  logic SD_WR_ADDR_EN,   
    output  logic SD_WR_DATA_EN,   

    output  logic SD_RW_EN,        
    input   logic SD_RW_OUT,

    input   logic [ADDR_WIDTH-1:0] SD_WR_ADDR_OUT, //
    input   logic [ADDR_WIDTH-1:0] SD_WR_DATA_OUT,  //

    input   logic [ADDR_WIDTH-1:0] SD_RD_ADDR_OUT,     
    output  logic [ADDR_WIDTH-1:0] SD_RD_DATA_IN,         //sent from the controller to RD data fifo

    input  logic WADDR_FIFO_FULL,
    input  logic WADDR_FIFO_EMPTY,
    input  logic WDATA_FIFO_EMPTY,
    input  logic WDATA_FIFO_FULL,
    input  logic RADDR_FIFO_FULL,
    input  logic RADDR_FIFO_EMPTY,
    input  logic RDATA_FIFO_FULL,
    input  logic RDATA_FIFO_EMPTY,
    input  logic RW_FIFO_FULL,                    
    input  logic RW_FIFO_EMPTY ,



    //signals on contoller side
    output  logic [HADDR_WIDTH-1:0]       wr_addr,        
    output  logic [15:0]                  wr_data,
    output  logic                         wr_enable,          

    output  logic [HADDR_WIDTH-1:0]       rd_addr,
    input   logic [15:0]                  rd_data,
    output  logic                         rd_enable,
    input   logic                         rd_ready,

    input   logic                         busy

);


//    assign clk = SD_clk;

    reg i;
    reg [3:0] count;
    reg count_itr;
    reg count_itr_1;
    reg [15:0] temp_data; 


     reg [1:0] [HADDR_WIDTH-1:0]   reg_sr_addr ;               
     reg [1:0] [DATA_WIDTH-1:0]    reg_sd_wr_data_out;             //base_address + 1

    
    reg [2:0] nxt_state;

    always@(posedge SD_clk) begin
        if(~ARESETn) begin
            wr_addr     <= 'h0;
            wr_data     <= 'h0;
            wr_enable   <= 1'b0;
            rd_addr     <= 'h0;
            rd_enable   <= 1'b0;
            SD_RD_DATA_IN <= 'b0;
            SD_RD_ADDR_EN <= 1'b0;
            SD_RD_DATA_EN <= 1'b0;
            SD_WR_ADDR_EN <= 1'b0;   
            SD_WR_DATA_EN <= 1'b0;  
            SD_RW_EN    <= 1'b0;
            count_itr   <= 1'b0;
            count_itr_1 <= 1'b0;
            i           <= 1'b0;
            nxt_state   <=3'b000;
            temp_data <='b0;
            count <= 'b0;
        end

        else begin
            case (nxt_state)
                3'b000: begin
                    if(!busy) begin
                        SD_RW_EN <= 1'b1;
                        nxt_state<= 3'b001 ; 
                    end   
                    else begin
                        nxt_state <= 3'b000;
                    end
                    SD_RD_DATA_EN <= 1'b0;
                    count_itr   <= 1'b0;
                    count_itr_1 <= 1'b0;
                    wr_enable <=0;
                    rd_enable <=0;
                end


                3'b001: begin   //Read_Write Control State
                    if(SD_RW_OUT==1)begin               // got for write operation 
                        if(!WADDR_FIFO_EMPTY) begin
                            SD_WR_ADDR_EN <= 1'b1;
                            nxt_state <= 3'b010;        //  Write  Address
                        end
                        else begin
                            nxt_state <= 3'b000;   //change cm     
                        end
                    end
                 
                    else begin
                        //READ OPERATION STATES
                        if(~RADDR_FIFO_EMPTY) begin
                            SD_RD_ADDR_EN <= 1'b1;
                            nxt_state <= 3'b100;        //go for read operation 
                        end
                        else begin
                            nxt_state <= 3'b000;    //change cm  
                        end
                    end
                    SD_RW_EN <= 1'b0;               //change cm  
                end


                3'b010 : begin  //Write_Address State
                        SD_WR_ADDR_EN    <= 1'b0;
                        reg_sr_addr[0]   <= SD_WR_ADDR_OUT[23:0];                   //BASE ADDRESS
                        reg_sr_addr[1]   <= SD_WR_ADDR_OUT[23:0] + 'h000001 ;       //BASE ADDRESS + 1         
                        
                        if(~WDATA_FIFO_EMPTY) begin
                            SD_WR_DATA_EN <= 1'b1;
                            nxt_state <= 3'b011;    //write data state    
                        end    

                        else begin
                            reg_sr_addr[0]   <= reg_sr_addr[0] ;
                            reg_sr_addr[1]   <= reg_sr_addr[1] ;
                            nxt_state <= 3'b010;
                        end
                end


                3'b011 : begin              // Write data state
                        SD_WR_DATA_EN <= 1'b0;
                        reg_sd_wr_data_out[0] <= SD_WR_DATA_OUT[15:0];              //1st chunk LSB 16 bits out of 32 bit data 
                        reg_sd_wr_data_out[1] <= SD_WR_DATA_OUT[31:16];             //2nd chunk MSB 16 bits from 32 bit of data
                        nxt_state <= 3'b101;        //IDLE STATE
                end


//------------------------------------------------------------------------------------------
                3'b100: begin                   // Read Operation States ---> ADRESS STATE
                        SD_RD_ADDR_EN <= 1'b0;
                        reg_sr_addr[0] <= SD_RD_ADDR_OUT[23:0];
                        reg_sr_addr[1] <= SD_RD_ADDR_OUT[23:0] + 'h000001;
                        nxt_state <=   3'b101 ; //transmit and Recieve state
                        count_itr <= 1'b0;
                        i <= 1'b0;
                end

                3'b101 : begin          //TRANSMIT AND RECIEVE STATE
                        
                            if(SD_RW_OUT==1) begin        //write
                                wr_addr <= reg_sr_addr[i];
                                wr_data <= reg_sd_wr_data_out[i];               
                            end
                            else begin
                                rd_addr   <= reg_sr_addr[i];
                            end
                            count <= 4'b0;
                            i <= i+1;
                            wr_enable <=0;
                            rd_enable <=0;
                            nxt_state <= 3'b110;
                end
            

                3'b110: begin
                        if(count!='hA && SD_RW_OUT==1)
                        wr_enable <= SD_RW_OUT;
                        else begin
                        if(count!='hA)
                            rd_enable <= 1'b1;
                        end

                            if(count < 4'b1010) begin                    //wait for 10 clk cycles between two writes
                                count <= count + 1'b1;
                                if(count>=4'b0100) begin                 //we have to keep asserted wr or rd enable for 4 two clk cycles
                                    wr_addr<=0;
                                    rd_addr<=0;
                                    wr_data<=0;
                                    wr_enable <= 1'b0;
                                    rd_enable <= 1'b0;
                                end
                                // if(count>=4'b0101) begin                 //we have to keep asserted wr or rd enable for 2 two clk cycles
                                //     wr_enable <= 1'b0;
                                //     rd_enable <= 1'b0;
                                // end
                                nxt_state <= 3'b110;
                                
                            if(rd_ready) begin
                                nxt_state <= 3'b111;
                            end
                        end
                       
                            else begin
                                count <= 4'b0;

                                if(count_itr==1)begin
                                    nxt_state <= 3'b000;        //IDLE
                                end
                                else begin
                                    count_itr <= count_itr + 1'b1;
                                    nxt_state <= 3'b101;
                                end
                            end
                    end

                3'b111: begin                                   //For reading data from sdram cnrtoland storing in fifo
                        if(~RDATA_FIFO_FULL)begin
                            if(count_itr_1==1)begin
                                SD_RD_DATA_EN <= 1'b1;
                                SD_RD_DATA_IN <= {rd_data, temp_data};
                                nxt_state <= 3'b000; 
                                i<=0;                           
                            end
                            else begin
                                count_itr_1 <= count_itr_1 + 1'b1;
                                temp_data <= rd_data;             
                                nxt_state <= 3'b101;
                            end

                        end
                end            

          //  default : /* default */;
            endcase
        end
    end
 
endmodule : fifo_sdram_cntrl
