onerror {quit -code 1}
source "C:/Users/Mani/Documents/Projects/FPGA/Training_SPI_slave/workspace/modelsim/test_output/lib.example_tb.INVERTER_0.test_ze945411b04e73f7c74d3f369c5ef2d26c29678beb/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
