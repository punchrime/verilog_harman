`timescale 1ns / 10ps

module clock_datapath (
    input i_clk, 
    input i_rst, 
    input i_runClock,
    input i_setHour,
    input i_setMin,
    input i_setSec, 
    input i_upTime, 
    input i_downTime, 
    output [6:0] msec_o, 
    output [6:0] sec_o, 
    output [6:0] min_o,
    output [6:0] hour_o 
);

    wire w_clk_10Hz, w_mil_tick, w_sec_tick, w_min_tick; 

    // assign sec_tick_o = w_sec_tick;

    clk_div_10Hz U_clk_div(
        .i_div_clk(i_clk),
        .i_div_rst(i_rst), 
        .div_clk_o(w_clk_100Hz)
    );

    time_clock_counter #(
        .TIME_MAX(100),
        .BIT_WIDTH(7),
        .INITIAL_VALUE(0)
    ) U_time_counter_100msec(
        .i_tim_clk(i_clk),
        .i_tim_rst(i_rst),
        .i_tim_tick(w_clk_100Hz),
        .i_tim_runClock(i_runClock), 
        .i_tim_setTime(1'b0), 
        .i_tim_upTime(1'b0), 
        .i_tim_downTime(1'b0), 
        .tim_tick_o(w_mil_tick),
        .tim_timeCnt_o(msec_o) 
    );

    time_clock_counter #(
        .TIME_MAX(60),
        .BIT_WIDTH(7),
        .INITIAL_VALUE(12)
    ) U_time_counter_sec(
        .i_tim_clk(i_clk),
        .i_tim_rst(i_rst),
        .i_tim_tick(w_mil_tick),
        .i_tim_runClock(i_runClock), 
        .i_tim_setTime(i_setSec), 
        .i_tim_upTime(i_upTime), 
        .i_tim_downTime(i_downTime), 
        .tim_tick_o(w_sec_tick),
        .tim_timeCnt_o(sec_o) 
    );

    time_clock_counter #(
        .TIME_MAX(60),
        .BIT_WIDTH(7),
        .INITIAL_VALUE(7)
    ) U_time_counter_min(
        .i_tim_clk(i_clk),
        .i_tim_rst(i_rst),
        .i_tim_tick(w_sec_tick),
        .i_tim_runClock(i_runClock), 
        .i_tim_setTime(i_setMin), 
        .i_tim_upTime(i_upTime), 
        .i_tim_downTime(i_downTime), 
        .tim_tick_o(w_min_tick),
        .tim_timeCnt_o(min_o) 
    );

    time_clock_counter #(
        .TIME_MAX(13),
        .BIT_WIDTH(7),
        .INITIAL_VALUE(7)
    ) U_time_counter_hour(
        .i_tim_clk(i_clk),
        .i_tim_rst(i_rst),
        .i_tim_tick(w_min_tick),
        .i_tim_runClock(i_runClock), 
        .i_tim_setTime(i_setHour), 
        .i_tim_upTime(i_upTime), 
        .i_tim_downTime(i_downTime), 
        .tim_tick_o(),
        .tim_timeCnt_o(hour_o) 
    );
    
    
endmodule

/////////////////////////////////////////////////////////////////////////////////

module clk_div_10Hz(       // 0.1초 
    input i_div_clk,
    input i_div_rst, 
    output div_clk_o
);  

    // reg [$clog2(10) - 1 : 0] r_counter_reg, r_counter_next;          // for simulation 
    reg [$clog2(1_000_000) - 1 : 0] r_counter_reg, r_counter_next; 
    reg r_clk_reg, r_clk_next; 

    assign div_clk_o = r_clk_reg; 

    // sequential logic : non blocking 
    // clk에 따라 next 값이 업데이트된다 
    always @(posedge i_div_clk, posedge i_div_rst) begin
        if (i_div_rst) begin
            r_counter_reg <= 0; 
            r_clk_reg <= 1'b0; 
        end
        else begin
            r_counter_reg <= r_counter_next; 
            r_clk_reg <= r_clk_next; 
        end
    end

    // comb logic : blocking 
    always @(*) begin
        r_clk_next = r_clk_reg; 
        r_counter_next = r_counter_reg; 
        // if (r_counter_reg == 10 - 1) begin  // for simulation 
        if (r_counter_reg == 1_000_000 - 1) begin  // 10Hz 
            r_counter_next = 0;
            r_clk_next = 1'b1;
        end else begin
            r_counter_next = r_counter_reg + 1;
            r_clk_next = 1'b0; 
        end
    end
endmodule 

/////////////////////////////////////////////////////////////////////////////////

module time_clock_counter #(
    parameter TIME_MAX = 60, BIT_WIDTH = 7, INITIAL_VALUE = 12
) (
    input i_tim_clk,
    input i_tim_rst,
    input i_tim_tick, 
    input i_tim_runClock,   
    input i_tim_setTime, 
    input i_tim_upTime, 
    input i_tim_downTime, 
    output tim_tick_o,
    output [BIT_WIDTH - 1 : 0] tim_timeCnt_o 
);
    
    reg [$clog2(TIME_MAX) - 1 : 0] time_counter_reg, time_counter_next; 
    reg time_tick_reg, time_tick_next; 

    assign tim_tick_o = time_tick_reg; 
    assign tim_timeCnt_o = time_counter_reg; 

    always @(posedge i_tim_clk, posedge i_tim_rst) begin
        if (i_tim_rst) begin
            time_counter_reg <= INITIAL_VALUE; 
            time_tick_reg <= 1'b0; 
        end
        else begin
            time_counter_reg <= time_counter_next; 
            time_tick_reg <= time_tick_next; 
        end
    end
    

    always @(*) begin
        time_counter_next = time_counter_reg; 
        time_tick_next = 1'b0; 
        if (i_tim_tick) begin
            if (time_counter_reg == TIME_MAX - 1) begin
                if (i_tim_runClock == 1'b1) begin
                    time_counter_next = 0; 
                    time_tick_next = 1'b1; 
                end
                else begin
                    time_counter_next = time_counter_reg; 
                    time_tick_next = 1'b0; 
                end
            end
            else begin
                if (i_tim_runClock == 1'b1) begin
                    time_counter_next = time_counter_reg + 1; 
                    time_tick_next = 1'b0; 
                end
                else if (i_tim_setTime == 1'b1) begin
                    if (i_tim_upTime == 1'b1) begin
                        time_counter_next = time_counter_reg + 1; 
                    end 
                    else if (i_tim_downTime == 1'b1) begin  
                        time_counter_next = time_counter_reg - 1; 
                    end 
                    else time_counter_next = time_counter_reg; 
                end
                else begin
                    time_counter_next = time_counter_reg; 
                end
            end
        end else begin
            if (i_tim_setTime == 1'b1) begin
                if (i_tim_upTime == 1'b1) begin
                    time_counter_next = time_counter_reg + 1; 
                    if (time_counter_reg == TIME_MAX - 1) begin
                        time_counter_next = 0; 
                    end
                end
                else if (i_tim_downTime == 1'b1) begin
                    time_counter_next = time_counter_reg - 1; 
                    if (time_counter_reg == 0) begin
                        time_counter_next = TIME_MAX - 1; 
                    end
                end
                else time_counter_next = time_counter_reg; 
            end
        end
    end
endmodule
