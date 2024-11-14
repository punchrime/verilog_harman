`timescale 1ns / 10ps

module clock_control_unit(
    input i_clk, 
    input i_rst,
    input i_sw_setMode, 
    input i_btn_setTime,
    input i_btn_upTime, 
    input i_btn_downTime, 
    output reg runClock_o, 
    output reg setHour_o,
    output reg setMin_o,
    output reg setSec_o, 
    output reg upTime_o,
    output reg downTime_o 
);

    localparam IDLE = 3'b000; 
    localparam SET_HOUR = 3'b001; 
    localparam SET_MIN = 3'b010; 
    localparam SET_SEC = 3'b011; 

    localparam IDLE_TIME = 2'b00; 
    localparam UP_TIME = 2'b01; 
    localparam DOWN_TIME = 2'b10;

    reg [2:0] state, state_n; 
    reg [1:0] timeState, timeState_n; 

    always @(posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            state <= IDLE; 
            timeState <= IDLE_TIME; 
        end        
        else begin
            if (i_sw_setMode == 1'b1) begin
                timeState <= timeState_n; 
                state <= state_n; 
            end
            else begin
                state <= IDLE; 
                timeState <= IDLE_TIME; 
            end 
        end
    end

    always@(*) begin
        state_n = state;
        timeState_n = timeState; 
        if (i_sw_setMode == 1'b1) begin
            case (state)
            IDLE : begin
                if (i_btn_setTime == 1'b1) begin
                    state_n = SET_HOUR; 
                    timeState_n = IDLE_TIME; 
                end
                else state_n = IDLE; 
            end
            SET_HOUR : begin
                if (i_btn_setTime == 1'b1) begin
                    state_n = SET_MIN; 
                end
                else begin
                    state_n = SET_HOUR; 
                    if (i_btn_upTime == 1'b1) begin
                        timeState_n = UP_TIME; 
                    end
                    else if (i_btn_downTime == 1'b1) begin
                        timeState_n = DOWN_TIME; 
                    end
                    else timeState_n = IDLE_TIME; 
                end 
            end
            SET_MIN : begin
                if (i_btn_setTime == 1'b1) begin
                    state_n = SET_SEC; 
                end
                else begin
                    state_n = SET_MIN; 
                    if (i_btn_upTime == 1'b1) begin
                        timeState_n = UP_TIME; 
                    end
                    else if (i_btn_downTime == 1'b1) begin
                        timeState_n = DOWN_TIME; 
                    end
                    else timeState_n = IDLE_TIME; 
                end 
            end
            SET_SEC : begin
                if (i_btn_setTime == 1'b1) begin
                    state_n = IDLE; 
                end
                else begin
                    state_n = SET_SEC; 
                    if (i_btn_upTime == 1'b1) begin
                        timeState_n = UP_TIME; 
                    end
                    else if (i_btn_downTime == 1'b1) begin
                        timeState_n = DOWN_TIME; 
                    end
                    else timeState_n = IDLE_TIME; 
                end 
            end 
        endcase
        end
    end

    always@(*) begin
        runClock_o = 1'b1;  
        setHour_o = 1'b0; 
        setMin_o = 1'b0; 
        setSec_o = 1'b0; 
        upTime_o = 1'b0; 
        downTime_o = 1'b0; 
        if (i_sw_setMode) begin
            case (state)
            IDLE : begin
                runClock_o = 1'b1;  
                setHour_o = 1'b0; 
                setMin_o = 1'b0; 
                setSec_o = 1'b0; 
                upTime_o = 1'b0; 
                downTime_o = 1'b0; 
            end
            SET_HOUR : begin
                runClock_o = 1'b0;  
                setHour_o = 1'b1; 
                setMin_o = 1'b0; 
                setSec_o = 1'b0; 
                case(timeState)
                    IDLE_TIME : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                    UP_TIME : begin
                        upTime_o = 1'b1; 
                        downTime_o = 1'b0; 
                    end
                    DOWN_TIME : begin
                        upTime_o = 1'b0;
                        downTime_o = 1'b1; 
                    end
                    default : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                endcase
            end
            SET_MIN : begin
                runClock_o = 1'b0;  
                setHour_o = 1'b0; 
                setMin_o = 1'b1; 
                setSec_o = 1'b0; 
                case(timeState)
                    IDLE_TIME : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                    UP_TIME : begin
                        upTime_o = 1'b1; 
                        downTime_o = 1'b0; 
                    end
                    DOWN_TIME : begin
                        upTime_o = 1'b0;
                        downTime_o = 1'b1; 
                    end
                    default : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                endcase
            end
            SET_SEC : begin
                runClock_o = 1'b0;  
                setHour_o = 1'b0; 
                setMin_o = 1'b0; 
                setSec_o = 1'b1; 
                case(timeState)
                    IDLE_TIME : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                    UP_TIME : begin
                        upTime_o = 1'b1; 
                        downTime_o = 1'b0; 
                    end
                    DOWN_TIME : begin
                        upTime_o = 1'b0;
                        downTime_o = 1'b1; 
                    end
                    default : begin
                        upTime_o = 1'b0; 
                        downTime_o = 1'b0; 
                    end
                endcase
            end 
        endcase
        end

    end
endmodule
