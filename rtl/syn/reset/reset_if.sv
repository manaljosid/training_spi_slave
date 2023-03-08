/**
 * @file reset_if.sv
 *
 * @author Mani Magnusson
 * @date   2023
 *
 * @brief Reset Interface Definition
 */

`default_nettype none

interface RESET_IF #(

);
    // SECTION: Signals

    var logic reset;

    // SECTION: Modports

    modport Input (

        input reset
        
    );


    modport Output (

        output reset

    );
endinterface

`default_nettype wire