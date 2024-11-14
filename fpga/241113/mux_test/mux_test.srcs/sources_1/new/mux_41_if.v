`timescale 1ns / 1ps
module mux_41_if(
    input [3:0] a,
    input [3:0] b, 
    input [3:0] c,
    input [3:0] d, 
    input [1:0] sel,
    output reg [3:0] y 
);

    always @(sel, a, b, c, d) begin
        if (sel == 2'b00) y = a;
        else if (sel == 2'b01) y = b; 
        else if (sel == 2'b10) y = c;
        else if (sel == 2'b11) y = d; 
        else y = 4'bx; 
    end
    
endmodule
