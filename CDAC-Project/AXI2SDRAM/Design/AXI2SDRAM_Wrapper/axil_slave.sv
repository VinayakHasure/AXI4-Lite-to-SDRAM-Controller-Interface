`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abrar Ul haq Sanadi
// 
// Create Date: 8.08.2024 16:28:13
// Design Name: AXIL-Slave
// Module Name: AXIL_Slave_FSM
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
// Design a AXIL-Slave




   module AXIL_Slave_FSM #(
                                parameter   ADDR_WIDTH = 32,
                                            DATA_WIDTH = 32
                          )   
        (
            input s_axil_clk,
            input s_axil_resetn,

            //Write address channel signals
            input   wire    [ADDR_WIDTH-1:0]     s_axil_awaddr,
            input   wire                         s_axil_awvalid,
            output  reg                          s_axil_awready,  

            //write data channel signals 
            input   wire    [DATA_WIDTH-1:0]     s_axil_wdata,
            input   wire                         s_axil_wvalid,
            input   wire    [DATA_WIDTH/8-1:0]   s_axil_wstrb,
            output  reg                          s_axil_wready,

            //write response signals
            input   wire                        s_axil_bready,
            output  reg     [1:0]               s_axil_bresp ,
            output  reg                         s_axil_bvalid,
            
            //Read address channel signals
            input  wire     [ADDR_WIDTH-1:0]    s_axil_araddr,
            input  wire                         s_axil_arvalid,
            output reg                          s_axil_arready,

            //Read data channel signals
            output reg      [DATA_WIDTH-1:0]    s_axil_rdata,
            output reg      [1:0]               s_axil_rresp,
            output reg                          s_axil_rvalid,
            input  wire                         s_axil_rready,              
        

            output reg                          AXIL_WR_ADDR_EN,    
            output reg                          AXIL_WR_DATA_EN,
            output reg                          AXIL_RD_ADDR_EN,    
            output reg                          AXIL_RD_DATA_EN,

            output reg                          AXIL_RW_EN,             
            output reg                          AXIL_RW_IN,                     //1-->for write and 0--> for read


            output reg      [ADDR_WIDTH-1:0]    AXIL_WR_ADDR_IN,    
            output reg      [DATA_WIDTH-1:0]    AXIL_WR_DATA_IN,  
            output reg      [ADDR_WIDTH-1:0]    AXIL_RD_ADDR_IN, 
            input  wire     [DATA_WIDTH-1:0]    AXIL_RD_DATA_OUT,


            input  wire                         WADDR_FIFO_FULL,
            input  wire                         WADDR_FIFO_EMPTY,
            input  wire                         WDATA_FIFO_FULL,
            input  wire                         WDATA_FIFO_EMPTY,
            input  wire                         RADDR_FIFO_FULL,
            input  wire                         RADDR_FIFO_EMPTY,
            input  wire                         RDATA_FIFO_FULL,
            input  wire                         RDATA_FIFO_EMPTY,
            input  wire                         RW_FIFO_FULL,
            input  wire                         RW_FIFO_EMPTY

        );


        //Registered outputs for write signals
        reg [ADDR_WIDTH-1:0]    reg_awaddr;
        reg                     reg_awready;     
     // reg [DATA_WIDTH-1:0]    reg_wdata;
        reg                     reg_wready;
        reg                     reg_bvalid;

        reg [1:0] w_state;
  
        assign s_axil_awready= reg_awready;
        assign s_axil_wready = reg_wready ;
        assign s_axil_bvalid = reg_bvalid ;  
        assign s_axil_bresp  = 2'b00;       //OKAY



        //Registered outputs for Read signals
        reg [ADDR_WIDTH-1:0]    reg_araddr;
        reg [DATA_WIDTH-1:0]    reg_rdata;
        reg                     reg_rvalid;
        reg                     reg_arready;
        
        reg [1:0] r_state;

        assign s_axil_arready= reg_arready;
        assign s_axil_rvalid = reg_rvalid;
        assign s_axil_rdata  = reg_rdata ;
        assign s_axil_rresp  = 'h0; // OKAY              
     
    //  Slave Memory 
  //      reg [$clog2(ADDR_WIDTH)-1 : 0] [DATA_WIDTH-1 : 0] mem ;
  
        always_ff @(posedge s_axil_clk) begin
            if(~s_axil_resetn) begin
                w_state     <= 2'b00;          //IDLE STATE
                reg_awaddr  <= 'h0;
                reg_awready <= 1'b0;
            //  reg_wdata   <=  'h0;
                reg_wready  <= 1'b0;
                reg_bvalid  <= 1'b0;

                AXIL_WR_ADDR_IN <= 'h0;
                AXIL_WR_ADDR_EN <= 1'b0;
                AXIL_WR_DATA_IN <= 'h0;
                AXIL_WR_DATA_EN <= 1'b0;
                AXIL_RW_EN      <= 1'b0;
                AXIL_RW_IN      <= 1'b0;




            end else begin
                case (w_state)
                    2'b00:  begin   //IDLE
                            reg_awready <= 1'b1;                // we are asserting awready before awvalid to ensure its active system
                            
                            if(s_axil_awvalid & s_axil_awready) begin           //HANDSHAKE 
                                reg_awaddr  <= s_axil_awaddr;
                                
                                if(~WADDR_FIFO_FULL) begin
                                    AXIL_WR_ADDR_EN  <= 1'b1;
                                    AXIL_WR_ADDR_IN  <= reg_awaddr ;                 //register the write_address
                                    reg_awready <=  1'b0;                           //make aw_ready back to zero
                                    w_state     <=  2'b01;    //DATA STATE          //move to Data State                  
                                    reg_wready  <= 1'b1;
                                end
                                else begin
                                    AXIL_WR_ADDR_EN  <= 1'b0;
                                end
                            end
                            else begin
                                reg_awaddr      <= reg_awaddr ;
                                AXIL_WR_ADDR_EN <= 1'b0;
                                AXIL_WR_ADDR_IN <= AXIL_WR_ADDR_IN ;
                                w_state  <= 2'b00;
                            end  
                    end

                    2'b01:  begin   //DATA
                        //  reg_wready  <= 1'b1;   // we are asserting wready before awvalid to ensure its active system
                            AXIL_WR_ADDR_EN <= 1'b0;
                            if(s_axil_wvalid & s_axil_wready) begin             //HANDSHAKE
                        //      reg_wdata  <= s_axil_wdata;
                                if(~WDATA_FIFO_FULL) begin
                                    AXIL_WR_DATA_EN <= 1'b1;
                                    AXIL_RW_EN      <= 1'b1;
                                    AXIL_RW_IN      <= 1'b1;
                                    
                                    for (int i = 0; i < 4; i++) begin
                                        if(s_axil_wstrb[i]) begin
                                            AXIL_WR_DATA_IN [(i * 8) +: 8] <=    s_axil_wdata[(i * 8) +: 8];
                                            //  mem[reg_awaddr-1][(i * 8) +: 8] <= reg_wdata[(i * 8) +: 8];       //writing into the memory
                                        end
                                    end
                                
                                    reg_wready  <= 1'b0;                        //deasserting back wready
                                    
                                    if(s_axil_bready) begin
                                    //    AXIL_WR_DATA_EN <= 1'b0;
                                        reg_bvalid  <= 1'b1;
                                        w_state     <= 2'b11;    //Done State          
                                    end
                                    else begin
                                        w_state     <= 2'b10;                       //RESPONSE STATE    
                                    end
                                end
                            end

                            else begin
                                w_state <= 2'b01;
                                AXIL_WR_DATA_EN <= 1'b0;
                                AXIL_RW_EN      <= 1'b0;
                            end                                                        
                    end

                    2'b10:  begin   //RESPONSE
                            AXIL_WR_DATA_EN <= 1'b0;
                            AXIL_RW_EN      <= 1'b0;
                            if(s_axil_bready) begin
                               reg_bvalid  <= 1'b1;
                               w_state     <= 2'b11;    //Done State          
                            end    
                    end

                    2'b11:  begin   //DONE
                                reg_bvalid <= 1'b0;
                                w_state    <= 2'b00;   //IDLE STATE
                                AXIL_WR_DATA_EN <= 1'b0;
                                AXIL_RW_EN      <= 1'b0;
                            end

                    default : /* default */;
                endcase
            end
        end

//---------------------------------------READ TRANSACTION---------------------------------------------

        always_ff @(posedge s_axil_clk) begin
            if(~s_axil_resetn) begin
                r_state     <= 2'b00; // IDLE
                reg_arready <= 1'b0;
                reg_araddr  <= 'h0;
                reg_rdata   <= 'h0;
                reg_rvalid  <= 1'b0;

                AXIL_RD_ADDR_EN <= 1'b0;
                AXIL_RD_DATA_EN <= 1'b0;
                AXIL_RD_ADDR_IN <= 'h0;
                AXIL_RW_EN      <= 1'b0;
                AXIL_RW_IN      <= 1'b0;

            
            end else begin
                case (r_state)
                    2'b00: begin // IDLE
                            reg_arready <= 1'b1;
                            if (s_axil_arvalid & reg_arready) begin
                                reg_araddr <= s_axil_araddr;
                                if(~RADDR_FIFO_FULL) begin
                                    AXIL_RD_ADDR_EN <= 1'b1;
                                    AXIL_RD_ADDR_IN <= reg_araddr;
                                    AXIL_RW_EN      <= 1'b1;
                                    AXIL_RW_IN      <= 1'b1;

                                    reg_arready <= 1'b0;
                                    r_state <= 2'b01; // RD_DATA
                                end
                                else begin
                                    AXIL_RD_ADDR_EN <= 1'b0; 
                                    AXIL_RW_EN      <= 1'b0; 
                                end
                        end
                        else begin
                            AXIL_RD_ADDR_EN <= 1'b0;
                            AXIL_RW_EN      <= 1'b0; 

                        end
                    end
                    
                    2'b01: begin // RD_DATA
                        AXIL_RD_ADDR_EN <= 1'b0;
                        AXIL_RW_EN      <= 1'b0; 

                        if (s_axil_rready) begin
                            if(~RDATA_FIFO_EMPTY) begin
                                AXIL_RD_DATA_EN <= 1'b1;
                                reg_rdata <= AXIL_RD_DATA_OUT;
                                reg_rvalid <= 1'b1;
                                r_state <= 2'b10; // RD_RESP
                            end
                            else begin
                                r_state <= 2'b10;
                            end
                        end
                    end
                    
                    2'b10: begin // RD_RESP
                            AXIL_RD_DATA_EN <= 1'b0;
                            reg_rvalid <= 1'b0;
                            r_state <= 2'b00; // IDLE
                    end

                    default : /* default */;
                endcase
            end
        end

//------------------------------------------------------------------------------------------------------


endmodule : AXIL_Slave_FSM