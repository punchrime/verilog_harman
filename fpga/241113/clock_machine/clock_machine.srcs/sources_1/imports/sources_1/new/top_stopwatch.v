`timescale 1ns / 10ps

module top_stopwatch (
    input i_clk,
    input i_rst,
    input i_btn_runStop,
    input i_btn_clear,
    input i_sw_fndMode,
    input i_sw_setMode, 
    output [3:0] fndCom_o,
    output [7:0] fndFont_o
);

    wire w_btn_runStop, w_btn_clear;
    wire w_runStop, w_clear;
    wire [6:0] w_msec, w_sec, w_min, w_hour;
    // wire w_displayState, w_sec_tick;

    button_detector U_btn_runStop (
        .clk  (i_clk),
        .reset(i_rst),
        .i_btn(i_btn_runStop),
        .o_btn(w_btn_runStop)
    );

    button_detector U_btn_clear (
        .clk  (i_clk),
        .reset(i_rst),
        .i_btn(i_btn_clear),
        .o_btn(w_btn_clear)
    );

    stopwatch_control_Unit U_control_unit (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_sw_setMode(i_sw_setMode), 
        .i_btn_runStop(w_btn_runStop),
        .i_btn_clear(w_btn_clear),
        .run_o(w_runStop),
        .clear_o(w_clear)
    );

/* 
    select_Mode U_select_Mode (
        .i_mode_clk(i_clk),
        .i_mode_rst(i_rst),
        .i_mode_sw(i_sw_mode),
        .displayState_o(w_displayState)
    ); */ 

    stopWatch_datapath U_datapath (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_runStop(w_runStop),
        .i_clear(w_clear),
        .msec_o(w_msec),
        .sec_o(w_sec),
        .min_o(w_min),
        .hour_o(w_hour)
        // .sec_tick_o(w_sec_tick) 
    );

    stopwatch_fnd_controller U_fnd_controller (
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

