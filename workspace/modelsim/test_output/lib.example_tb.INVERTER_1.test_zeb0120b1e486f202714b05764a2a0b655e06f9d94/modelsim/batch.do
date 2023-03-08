onerror {quit -code 1}
source "C:/Users/Mani/Documents/Projects/FPGA/Training_SPI_slave/workspace/modelsim/test_output/lib.example_tb.INVERTER_1.test_zeb0120b1e486f202714b05764a2a0b655e06f9d94/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
