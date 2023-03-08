`timescale 1ns / 1ps
`default_nettype none

`include "vunit_defines.svh"

module spi_slave_tb ();
    parameter byte DATA = '0;
    parameter bit CS_STATE = 0;

    // SECTION: Signals

    logic clk;

    logic dut_sck;
    logic dut_cs;
    logic dut_mosi;
    logic dut_miso;
    logic [7:0] dut_data_in;
    logic [7:0] dut_data_out;
    logic dut_data_ready;
    logic dut_send_cmd = 1'b0;

    // SECTION: Modules

    spi_slave #(
        //.INVERTER ( INVERTER )
        // Insert parameters here
    ) DUT (
        .clk ( clk ),
        .sck ( dut_sck ),
        .cs  ( dut_cs ),
        .mosi ( dut_mosi ),
        .miso ( dut_miso ),
        .data_in ( dut_data_in ),
        .data_out ( dut_data_out ),
        .data_ready ( dut_data_ready ),
        .send_cmd ( dut_send_cmd )
    );

    // SECTION: Test Logic

    always begin
        #5; // Set clk to 100 MHz (period = 1/(2 x frequency))
        clk <= !clk;
	 end

    `TEST_SUITE begin
        `TEST_SUITE_SETUP begin
            clk = 1'b0;
			dut_mosi = 1'b0;
            dut_sck = 1'b0;
        end

        `TEST_CASE("receive_one_byte") begin
            dut_cs = 1'b0;
            send_byte(77, dut_mosi, dut_sck, 1000000);
            dut_cs = 1'b1;
            @(posedge clk iff dut_data_ready == 1'b1);
            `CHECK_EQUAL(dut_data_out, 77);
        end
    end

    `WATCHDOG(0.1ms);

    task automatic send_byte(input integer data, ref logic mosi, ref logic sck, input integer sck_rate);
		integer time_per_bit;
		time_per_bit = (10**9 / sck_rate);
		#(time_per_bit * 1ns);

		for (int i=0; i<8; i++) begin
            sck = 1'b0;
			mosi = data[i];
            #((time_per_bit / 2) * 1ns);
			sck = 1'b1;
			#((time_per_bit / 2) * 1ns);
		end
    endtask

    task automatic receive_byte(ref logic miso, ref logic sck, output byte data);
        data = 0;
        var logic [$bits($size(data))-1:0] index = 0;
        while (index != $size(data) - 1) begin
            @(posedge sck) begin
                data <= {mosi, data[$size(data)-1:1]};
                index <= index + 1;
            end
        end
    endtask 

    task automatic miso_send(ref logic data_in, ref logic send_cmd);
        var logic [$size(data_in)-1:0] data = 0;
        randomize(data);
        data_in <= data;
        send_cmd <= 1'b1;
    endtask
    
endmodule

`default_nettype wire
