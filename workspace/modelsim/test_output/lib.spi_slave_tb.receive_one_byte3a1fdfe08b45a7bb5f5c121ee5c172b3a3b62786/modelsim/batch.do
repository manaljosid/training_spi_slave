onerror {quit -code 1}
source "C:/Users/Mani/Documents/Projects/FPGA/Training_SPI_slave/workspace/modelsim/test_output/lib.spi_slave_tb.receive_one_byte3a1fdfe08b45a7bb5f5c121ee5c172b3a3b62786/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
