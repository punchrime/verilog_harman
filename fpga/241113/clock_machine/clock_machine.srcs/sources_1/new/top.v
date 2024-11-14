`timescale 1ns / 10ps

module top(
    input i_clk, 
    input i_rst, 
    input [2:0] i_btn,  
    input i_sw_fndMode, 
    input i_sw_setMode, 
    output [3:0] fndCom_o, 
    output [7:0] fndFont_o 
);

    wire [6:0] w_msec, w_sec, w_min, w_hour; 

    top_control_datapath U_top_control_datapath(
        .i_clk(i_clk), 
        .i_rst(i_rst),
        .i_sw_setMode(i_sw_setMode),
        .i_btn(i_btn),
        .msec_o(w_msec), 
        .sec_o(w_sec), 
        .min_o(w_min),
        .hour_o(w_hour) 
    ); 
        

    fnd_controller U_fnd_controller(
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