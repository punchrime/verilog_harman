`timescale 1ns / 10ps

module tb_stopwatch_datapath();

    reg i_clk;
    reg i_rst;
    reg i_runStop;
    reg i_clear;
    wire [6:0] msec_o;
    wire [6:0] sec_o;
    wire [6:0] min_o;
    wire [6:0] hour_o;

stopWatch_datapath dut(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_runStop(i_runStop),
    .i_clear(i_clear),
    .msec_o(msec_o),
    .sec_o(sec_o),
    .min_o(min_o),
    .hour_o(hour_o)
);



    always #5 i_clk = ~i_clk; 

    initial begin
        #00 i_clk = 1'b0; i_rst = 1'b1; i_runStop = 1'b0; i_clear = 1'b0; 
        #10 i_rst = 1'b0; 
        #10 i_runStop = 1'b1; 
        /* 
        wait (sec_o == 4);
        @(posedge i_clk) i_runStop = 1'b0; 
        repeat (10) @(posedge i_clk); 
        i_runStop = 1'b1;
        wait (sec_o == 6); 
        i_clear = 1'b1;  */ 
    end

endmodule
