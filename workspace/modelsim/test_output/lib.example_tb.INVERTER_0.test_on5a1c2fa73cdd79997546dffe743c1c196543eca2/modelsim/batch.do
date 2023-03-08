onerror {quit -code 1}
source "C:/Users/Mani/Documents/Projects/FPGA/Training_SPI_slave/workspace/modelsim/test_output/lib.example_tb.INVERTER_0.test_on5a1c2fa73cdd79997546dffe743c1c196543eca2/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
