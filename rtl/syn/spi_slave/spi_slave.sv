/**
 * @file spi_slave.sv
 *
 * @author Mani Magnusson
 * @date   2023
 *
 * @brief SPI Slave - Avalon Master Definition
 */

 // Currently only implements mode 0:
 // Clock polarity zero (asserted at 1, de-asserted at 0)
 // Clock phase zero (MISO asserted at posedge, MOSI asserted at negedge)

 /*
A couple of issues: (I forgot if this is old or not lol)
The register map suggests a 32 bit Avalon address bus and a 32 bit Avalon data bus
The buffers assume a 32 bit stream containing both the Avalon address and Avalon data
The spi_slave.txt file needs to be updated accordingly.

Needs to replace Avalon with AXI-Lite
 */

`timescale 1ns / 1ps
`default_nettype none

module spi_slave #(
    // Parameters
) (
    // Interfaces
    CLK_IF.Input clk_if         ,
    RESET_IF.Input reset_if     ,
    AVALON_IF.Host avalon_if   , //TODO: Replace with AXI-Lite interface

    // SPI signals
    input  var  logic sck       ,
    input  var  logic csn       ,
    input  var  logic mosi      ,
    output var  logic miso                      
    
);  
    // Local signals

    // Register map:
    /* 0 - AVMM_ADDR_0
     * 1 - AVMM_ADDR_1
     * 2 - AVMM_ADDR_2
     * 3 - AVMM_ADDR_3
     * 4 - AVMM_DATA_0
     * 5 - AVMM_DATA_1
     * 6 - AVMM_DATA_2
     * 7 - AVMM_DATA_3
     * 8 - AVMM_CONTROL_WRITE
     * 9 - AVMM_CONTROL_READ
     * 10-15 - RESERVED
     */
    var logic [7:0] spi_register [15:0];

    var logic [3:0] spi_register_pointer = 4'd0;

    // TODO: Figure out the correct sizes for these buffers
    var logic [47:0] spi_mosi_buf = 48'd0;
    var logic [31:0] spi_miso_buf = 32'd0;

    var logic [5:0] index = 6'd8; // Max transfer length is 48 bits

    var logic last_sck;
    var logic last_csn;

    var logic sck_rising;
    var logic sck_falling;
    var logic csn_rising;
    var logic csn_falling;

    typedef enum logic [1:0] {
        SPI_STATE_IDLE, // Waiting for CSn
        SPI_STATE_READ,
        SPI_STATE_WRITE,
        SPI_STATE_CHECK_FIRST_BYTE
    } spi_state_t;

    spi_state_t spi_state;

    assign sck_rising = !last_sck & sck;
    assign sck_falling = last_sck & !sck;

    assign csn_rising = !last_csn & csn;
    assign csn_falling = last_csn & csn;

    always_ff @(posedge clk_if.clk) begin
        if (reset_if.reset) begin
            spi_state <= SPI_STATE_IDLE;
            // Not sure if correct syntax, just fill with zeros
            spi_register <= {16{8'd0}};
        end else begin
            last_sck <= sck;
            last_scn <= csn;
            
            if (csn_rising) begin
                // Set Avalon state to read or write depending on what just happened
            end
            if (csn) begin
                spi_state <= SPI_IDLE;
            end else begin
                case (spi_state)
                    SPI_STATE_IDLE : begin
                        if (csn_falling) begin
                            index <= 6'd8;
                            spi_state <= SPI_STATE_CHECK_FIRST_BYTE;
                        end
                    end

                    SPI_STATE_CHECK_FIRST_BYTE : begin
                        if (sck_rising & (index != 0)) begin
                            index <= index - 1;
                            spi_mosi_buf[index+23] <= mosi;
                        end

                        if (index == 0) begin
                            spi_register_pointer <= spi_miso_buf[27:24];
                            if (spi_mosi_buf[31]) begin
                                index <= 6'd32;
                                spi_state <= SPI_STATE_READ;
                            end else begin
                                index <= 6'd48;
                                spi_state <= SPI_STATE_WRITE;
                            end
                        end
                    end

                    SPI_STATE_WRITE : begin
                        if (sck_rising & (index != 0)) begin
                            index <= index - 1;
                            spi_mosi_buf[index - 1] <= mosi;
                        end

                        if (index == 0) begin
                            // This method can overflow the spi_register_pointer!!!
                            //TODO: Find a better way to stuff data into the register
                            spi_register_pointer = spi_register_pointer + 1;
                            spi_register[spi_register_pointer] <= spi_mosi_buf[23:16];
                            spi_register[spi_register_pointer] <= spi_mosi_buf[15:8];
                        end
                    end

                    SPI_STATE_READ : begin
                        //TODO: Implement this
                    end

                    default : begin
                        spi_state <= SPI_STATE_IDLE;
                    end
                endcase
            end
        end
    end

    // TODO: Replace with AXI-Lite logic
    typedef enum logic [2:0] {
        AVALON_STATE_IDLE,
        AVALON_STATE_READ,
        AVALON_STATE_WRITE
    } avalon_state_t;

    avalon_state_t avalon_state;

    // Avalon transfer
    always_ff @(posedge clk_if.clk) begin
        // Avalon stuff here
    end
endmodule

`default_nettype wire