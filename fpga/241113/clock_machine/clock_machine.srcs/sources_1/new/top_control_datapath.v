`timescale 1ns / 10ps

module top_control_datapath(
    input i_clk, 
    input i_rst,
    input i_sw_setMode,
    input [2:0] i_btn,
    output [6:0] msec_o, 
    output [6:0] sec_o, 
    output [6:0] min_o,
    output [6:0] hour_o 
);  

    wire w_btn_0, w_btn_1, w_btn_2; 

    wire w_runClock, w_setHour, w_setMin, w_setSec, w_upTime, w_downTime; 
    wire [6:0] w_clock_msec, w_clock_sec, w_clock_min, w_clock_hour;

    wire w_runStop, w_clear; 
    wire [6:0] w_stopwatch_msec, w_stopwatch_sec, w_stopwatch_min, w_stopwatch_hour;  

    button_detector U_btn_0(
        .clk(i_clk),
        .reset(i_rst),
        .i_btn(i_btn[0]),
        .o_btn(w_btn_0)
    );

    button_detector U_btn_1(
        .clk(i_clk),
        .reset(i_rst),
        .i_btn(i_btn[1]),
        .o_btn(w_btn_1)
    );

    button_detector U_btn_2(
        .clk(i_clk),
        .reset(i_rst),
        .i_btn(i_btn[2]),
        .o_btn(w_btn_2)
    );

    clock_control_unit U_clock_control(
        .i_clk(i_clk), 
        .i_rst(i_rst),
        .i_sw_setMode(i_sw_setMode), 
        .i_btn_setTime(w_btn_0),
        .i_btn_upTime(w_btn_1), 
        .i_btn_downTime(w_btn_2), 
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
        .msec_o(w_clock_msec), 
        .sec_o(w_clock_sec), 
        .min_o(w_clock_min),
        .hour_o(w_clock_hour) 
    );

    stopwatch_control_Unit U_stopwatch_control(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_sw_setMode(i_sw_setMode), 
        .i_btn_runStop(w_btn_0),
        .i_btn_clear(w_btn_1),
        .run_o(w_runStop),
        .clear_o(w_clear)
    );

    stopwatch_datapath U_stopwatch_datapath(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_runStop(w_runStop),
        .i_clear(w_clear),
        .msec_o(w_stopwatch_msec),
        .sec_o(w_stopwatch_sec),
        .min_o(w_stopwatch_min),
        .hour_o(w_stopwatch_hour)
    );

    select_fnd_Mode U_select_fndMode(
        .i_sw_setMode(i_sw_setMode), 
        .i_clock_msec(w_clock_msec),
        .i_clock_sec(w_clock_sec),
        .i_clock_min(w_clock_min),
        .i_clock_hour(w_clock_hour),
        .i_stopwatch_msec(w_stopwatch_msec),
        .i_stopwatch_sec(w_stopwatch_sec),
        .i_stopwatch_min(w_stopwatch_min),
        .i_stopwatch_hour(w_stopwatch_hour),
        .mode_msec_o(msec_o),
        .mode_sec_o(sec_o), 
        .mode_min_o(min_o), 
        .mode_hour_o(hour_o) 
    );


endmodule

module select_fnd_Mode(
    input i_sw_setMode, 
    input [6:0] i_clock_msec,
    input [6:0] i_clock_sec,
    input [6:0] i_clock_min,
    input [6:0] i_clock_hour,
    input [6:0] i_stopwatch_msec,
    input [6:0] i_stopwatch_sec,
    input [6:0] i_stopwatch_min,
    input [6:0] i_stopwatch_hour,
    output reg [6:0] mode_msec_o,
    output reg [6:0] mode_sec_o, 
    output reg [6:0] mode_min_o, 
    output reg [6:0] mode_hour_o 
);
    always@(*) begin
        case(i_sw_setMode) 
            1'b0 : begin
                mode_msec_o = i_stopwatch_msec; 
                mode_sec_o = i_stopwatch_sec; 
                mode_min_o = i_stopwatch_min; 
                mode_hour_o = i_stopwatch_hour; 
            end
            1'b1 : begin
                mode_msec_o = i_clock_msec; 
                mode_sec_o = i_clock_sec; 
                mode_min_o = i_clock_min; 
                mode_hour_o = i_clock_hour; 
            end
        endcase
    end
endmodule 
