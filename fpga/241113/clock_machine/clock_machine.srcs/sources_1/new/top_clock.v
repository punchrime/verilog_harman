`timescale 1ns / 10ps

module top_clock(
    input i_clk,
    input i_rst, 
    input i_btn_setTime, 
    input i_btn_upTime, 
    input i_btn_downTime, 
    input i_sw_fndMode, 
    input i_sw_setMode, 
    output [3:0] fndCom_o,
    output [7:0] fndFont_o 
);

    wire w_btn_setTime, w_btn_upTime, w_btn_downTime; 
    wire w_runClock, w_setHour, w_setMin, w_setSec; 
    wire [6:0] w_msec, w_sec, w_min, w_hour;

    button_detector U_btn_setTime (
        .clk  (i_clk),
        .reset(i_rst),
        .i_btn(i_btn_setTime),
        .o_btn(w_btn_setTime)
    );

    button_detector U_btn_upTime (
        .clk  (i_clk),
        .reset(i_rst),
        .i_btn(i_btn_upTime),
        .o_btn(w_btn_upTime)
    );

    button_detector U_btn_downTime (
        .clk  (i_clk),
        .reset(i_rst),
        .i_btn(i_btn_downTime),
        .o_btn(w_btn_downTime)
    );

    clock_control_unit U_clock_control_unit(
        .i_clk(i_clk), 
        .i_rst(i_rst),
        .i_sw_setMode(i_sw_setMode), 
        .i_btn_setTime(w_btn_setTime),
        .i_btn_upTime(w_btn_upTime),
        .i_btn_downTime(w_btn_downTime), 
        .runClock_o(w_runClock), 
        .setHour_o(w_setHour),
        .setMin_o(w_setMin),
        .setSec_o(w_setSec),
        .upTime_o(w_upTime),
        .downTime_o(w_downTime)
    );

    clock_datapath U_clock_datapath(
        .i_clk(i_clk), 
        .i_rst(i_rst), 
        .i_runClock(w_runClock),
        .i_setHour(w_setHour),
        .i_setMin(w_setMin),
        .i_setSec(w_setSec), 
        .i_upTime(w_upTime),
        .i_downTime(w_downTime),
        .msec_o(w_msec), 
        .sec_o(w_sec), 
        .min_o(w_min),
        .hour_o(w_hour) 
    ); 

    clock_fnd_controller U_clock_fnd_controller(
        .i_con_clk(i_clk),
        .i_con_reset(i_rst),
        .i_con_fnd_mode(i_sw_fndMode),
        .i_con_mSec(w_msec),
        .i_con_sec(w_sec),
        .i_con_min(w_min),
        .i_con_hour(w_hour),
        .con_fndCom_o(fndCom_o),
        .con_fndFont_o(fndFont_o)
    ); 

endmodule
