`timescale 1ns / 10ps

module stopwatch_control_Unit (
    input i_clk,
    input i_rst,
    input i_sw_setMode, 
    input i_btn_runStop,
    input i_btn_clear,
    output reg run_o,
    output reg clear_o
);
    // parameter : 외부에서도 입력받을 수 있는 변수
    // localparam : 내부에서만 유의미 
    localparam STOP = 2'b00;
    localparam RUN = 2'b01;
    localparam CLEAR = 2'b10;

    reg [1:0] state, state_next;

    // state register 
    always @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            state <= STOP;
        end else begin
            if(i_sw_setMode == 1'b0) begin
                state <= state_next;
            end 
            else begin
                state <= STOP; 
            end
        end
    end

    // next state comb logic 
    always @(*) begin
        state_next = state;
        if (i_sw_setMode == 1'b0) begin
            case (state)
            STOP: begin
                if (i_btn_runStop == 1'b1) begin
                    state_next = RUN;
                end else if (i_btn_clear == 1'b1) begin
                    state_next = CLEAR;
                end else state_next = STOP;
            end
            RUN: begin
                if (i_btn_runStop == 1'b1) begin
                    state_next = STOP;
                end else state_next = RUN;
            end
            CLEAR: state_next = STOP;
            endcase
        end
    end

    // output comb logic 
    always @(*) begin
        run_o   = 1'b0;
        clear_o = 1'b0;
        if (i_sw_setMode == 1'b0) begin
            case (state)
            STOP: begin
                run_o   = 1'b0;
                clear_o = 1'b0;
            end
            RUN: begin
                run_o   = 1'b1;
                clear_o = 1'b0;
            end
            CLEAR: begin
                run_o   = 1'b0;
                clear_o = 1'b1;
            end
        endcase
        end

    end

endmodule

/* 

module select_Mode (
    input i_mode_clk,
    input i_mode_rst,
    input i_mode_sw, 
    output reg displayState_o 
);
    
    localparam SECMILLISEC = 1'b0;
    localparam HOURMIN = 1'b1; 

    reg displayState, displayState_n;

    always@(posedge i_mode_clk, posedge i_mode_rst) begin
        if (i_mode_rst) begin
            displayState <= SECMILLISEC;
        end else begin
            displayState <= displayState_n; 
        end
    end

    always @(*) begin
        displayState_n = displayState; 
        case (displayState)
            SECMILLISEC : begin
                if (i_mode_sw == 1'b1) begin
                    displayState_n = HOURMIN; 
                end 
                else displayState_n = SECMILLISEC; 
            end
            HOURMIN : begin
                if (i_mode_sw == 1'b0) begin
                    displayState_n = SECMILLISEC; 
                end
                else displayState_n = HOURMIN; 
            end
        endcase
    end
    
    always @(*) begin
        displayState_o = 1'b0; 
        case (displayState)
            SECMILLISEC : begin
                displayState_o = 1'b0; 
            end
            HOURMIN : begin
                displayState_o = 1'b1; 
            end
        endcase
    end

endmodule */ 