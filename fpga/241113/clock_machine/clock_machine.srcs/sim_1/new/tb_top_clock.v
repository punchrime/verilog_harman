`timescale 1ns / 10ps

module tb_top_clock ();

    reg i_clk;
    reg i_rst;
    reg i_btn_setTime;
    reg i_btn_upTime;
    reg i_btn_downTime;
    reg i_sw_mode;
    wire [3:0] fndCom_o;
    wire [7:0] fndFont_o;


    top_clock dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_btn_setTime(i_btn_setTime),
        .i_btn_upTime(i_btn_upTime),
        .i_btn_downTime(i_btn_downTime),
        .i_sw_mode(i_sw_mode),
        .fndCom_o(fndCom_o),
        .fndFont_o(fndFont_o)
    );


    always #5 i_clk = ~i_clk;

    initial begin
        #00 i_clk = 1'b0; i_rst = 1'b1; i_btn_setTime = 1'b0; i_btn_upTime = 1'b0; i_btn_downTime = 1'b0;
        #10 i_rst = 1'b0;
        #10 i_sw_mode = 1'b1;

        // setHour
        #60 i_btn_setTime = 1'b1;
        #60 
        #60 i_btn_upTime = 1'b1;
        #1000 i_btn_upTime = 1'b0;
        #1000 i_btn_setTime = 1'b0;
        #600

        // setMin
        #60 i_btn_setTime = 1'b1;
        #60 
        #60 i_btn_upTime = 1'b1;
        #1000 i_btn_upTime = 1'b0;
        #1000 i_btn_setTime = 1'b0;
        #600

        // setSec
        #60 i_btn_setTime = 1'b1;
        #60 
        #60 i_btn_upTime = 1'b1;
        #1000 i_btn_upTime = 1'b0;
        #1000 i_btn_setTime = 1'b0;
        #600


        // IDLE 
        #60 i_btn_setTime = 1'b1;
        #1000 i_btn_setTime = 1'b0;
    end


endmodule
