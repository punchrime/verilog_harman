`timescale 1ns / 1ps

module mux_41_condition (
    input [3:0] a,
    input [3:0] b, 
    input [3:0] c,
    input [3:0] d, 
    input [1:0] sel,
    output [3:0] y 
);

    assign y = (sel == 0) ? a : 
               (sel == 1) ? b : 
               (sel == 2) ? c : 
               (sel == 3) ? d : 4'bx; 
    
endmodule