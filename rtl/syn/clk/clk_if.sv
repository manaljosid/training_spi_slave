/**
 * @file clk_if.sv
 *
 * @author Mani Magnusson
 * @date   2023
 *
 * @brief Clock Interface Definition
 */

`default_nettype none

interface CLK_IF #(

);
    // SECTION: Signals

    var logic clk;

    // SECTION: Modports

    modport Input (

        input clk
        
    );


    modport Output (

        output clk

    );
endinterface

`default_nettype wire