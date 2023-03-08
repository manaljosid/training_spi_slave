onerror {quit -code 1}
source "C:/Users/Mani/Documents/Projects/FPGA/Training_SPI_slave/workspace/modelsim/test_output/lib.example_tb.INVERTER_1.test_on5f151973d59fea22fdf3796cfbbffcc74ad7149a/modelsim/common.do"
set failed [vunit_load]
if {$failed} {quit -code 1}
set failed [vunit_run]
if {$failed} {quit -code 1}
quit -code 0
