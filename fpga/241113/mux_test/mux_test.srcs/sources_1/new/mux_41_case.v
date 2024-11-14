`timescale 1ns / 1ps

module mux_41_case(
    input [3:0] a,
    input [3:0] b, 
    input [3:0] c,
    input [3:0] d, 
    input [1:0] sel,
    output reg [3:0] y 
);

    always @(sel, a, b, c, d) begin
        case(sel) 
            0 : y = a; 
            1 : y = b;
            2 : y = c; 
            3 : y = d; 
            default : y = 4'bx; 
        endcase
    end
endmodule
