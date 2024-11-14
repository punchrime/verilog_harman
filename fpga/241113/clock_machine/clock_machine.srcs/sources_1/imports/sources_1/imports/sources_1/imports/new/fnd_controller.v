`timescale 1ns / 10ps

module stopwatch_fnd_controller (
    input i_con_clk,
    input i_con_reset,
    input i_con_fnd_mode, 
    input [6:0] i_con_mSec,
    input [6:0] i_con_sec,
    input [6:0] i_con_min,
    input [6:0] i_con_hour, 
    output [3:0] con_fndCom_o,
    output [7:0] con_fndFont_o
);

    wire [3:0] w_mSec_dig01, w_mSec_dig10;
    wire [3:0] w_sec_dig01, w_sec_dig10;
    wire [3:0] w_min_dig01, w_min_dig10;
    wire [3:0] w_hour_dig01, w_hour_dig10; 
    wire [2:0] w_selFnd; 
    wire [3:0] w_bcdData, w_bcd_Sec_MSec, w_bcdData_Min_Hour; 
    wire w_clk;
    wire [3:0] w_dot; 

    wire [3:0] w_mul_x0, w_mul_x1, w_mul_x2, w_mul_x3;
    wire [3:0] w_con_fndCom_o; 

    assign con_fndCom_o = w_con_fndCom_o; 

    clk_divider_stopwatch U_clk_div( 
        .i_div_clk(i_con_clk),
        .i_div_reset(i_con_reset),
        .div_clk_o(w_clk)
    );

    counter_stopwatch U_counter(
        .i_cnt_clk(w_clk), 
        .i_cnt_reset(i_con_reset), 
        .cnt_count_o(w_selFnd)
    );

    decoder_3to8_stopwatch U_3to8 (
        .i_dec_x(w_selFnd),
        .dec_y_o(w_con_fndCom_o)
    );

    digit_splitter_stopwatch U_dig_splitter_mSec(
        .i_dig_dig(i_con_mSec),
        .dig_dig01_o(w_mSec_dig01),
        .dig_dig10_o(w_mSec_dig10)
    );

    digit_splitter_stopwatch U_dig_splitter_sec(
        .i_dig_dig(i_con_sec),
        .dig_dig01_o(w_sec_dig01),
        .dig_dig10_o(w_sec_dig10)
    );

    digit_splitter_stopwatch U_dig_splitter_min(
        .i_dig_dig(i_con_min),
        .dig_dig01_o(w_min_dig01),
        .dig_dig10_o(w_min_dig10)
    );
    
    digit_splitter_stopwatch U_dig_splitter_hour(
        .i_dig_dig(i_con_hour),
        .dig_dig01_o(w_hour_dig01),
        .dig_dig10_o(w_hour_dig10)
    );

    comparator_stopwatch U_mSec_Comp(
        .i_comp_x(i_con_mSec),
        .comp_y_o(w_dot) 
    );

    mux_81_stopwatch U_mux_81_Sec_mSec (
        .i_mul_sel(w_selFnd),
        .i_mul_x0(w_mSec_dig01),
        .i_mul_x1(w_mSec_dig10),
        .i_mul_x2(w_sec_dig01),
        .i_mul_x3(w_sec_dig10),
        .i_mul_x4(4'hf),
        .i_mul_x5(4'hf),
        .i_mul_x6(w_dot),
        .i_mul_x7(4'hf),
        .mul_y_o(w_bcd_Sec_MSec)
    );

    mux_81_stopwatch U_mux_81_Min_Hour (
        .i_mul_sel(w_selFnd),
        .i_mul_x0(w_min_dig01),
        .i_mul_x1(w_min_dig10),
        .i_mul_x2(w_hour_dig01),
        .i_mul_x3(w_hour_dig10),
        .i_mul_x4(4'hf),
        .i_mul_x5(4'hf),
        .i_mul_x6(w_dot),
        .i_mul_x7(4'hf),
        .mul_y_o(w_bcdData_Min_Hour)
    );

    mux_21_stopwatch U_Mux_21(
        .i_mul_sel(i_con_fnd_mode),
        .i_mul_x0(w_bcd_Sec_MSec),
        .i_mul_x1(w_bcdData_Min_Hour),
        .mul_y_o(w_bcdData)
    );

    BCDtoseg_o_decoder_stopwatch U_BCDtoSEG (       
        .i_bcd(w_bcdData),
        .seg_o(con_fndFont_o)
    );

endmodule

//////////////////////////////////////////////////////////////////////
////////////////////////

module clk_divider_stopwatch(
    input i_div_clk,
    input i_div_reset,

    output div_clk_o 
);
    reg [16:0] r_counter;           
    reg r_clk; 

    assign div_clk_o = r_clk; 

    always @(posedge i_div_clk, posedge i_div_reset) begin
        if (i_div_reset) begin
            r_counter <= 0; 
            r_clk <= 1'b0; 
        end 
        else begin
            if (r_counter == 100_000 -1) begin  // 0.1초 
                r_counter <= 0; 
                r_clk <= 1'b1; 
            end 
            else begin
                r_counter <= r_counter + 1; 
                r_clk <= 1'b0; 
            end 
        end 
    end

endmodule

//////////////////////////////////////////////////////////////////////

module counter_stopwatch(
    input wire i_cnt_clk, 
    input wire i_cnt_reset, 
    output reg [2:0] cnt_count_o   
);

    always @(posedge i_cnt_clk, posedge i_cnt_reset) begin
        if (i_cnt_reset) begin
            cnt_count_o <= 0;       // blocking assignment 
        end 
        else begin
            cnt_count_o <= cnt_count_o + 1; 
        end 
    end
    
endmodule

//////////////////////////////////////////////////////////////////////

// BCDtoseg_o_decoder
module BCDtoseg_o_decoder_stopwatch(
    input wire [3:0] i_bcd,
    // input wire i_bcd_dotE,
    // input wire [3:0] i_bcd_dec, 
    output reg  [7:0] seg_o
);

    always @(*) begin
        case (i_bcd)
            4'h0: seg_o = 8'hc0;
            4'h1: seg_o = 8'hf9;
            4'h2: seg_o = 8'ha4;
            4'h3: seg_o = 8'hb0;
            4'h4: seg_o = 8'h99;
            4'h5: seg_o = 8'h92;
            4'h6: seg_o = 8'h82;
            4'h7: seg_o = 8'hf8;
            4'h8: seg_o = 8'h80;
            4'h9: seg_o = 8'h90;
            4'ha: seg_o = 8'h88;
            4'hb: seg_o = 8'h83;
            4'hc: seg_o = 8'hc6;
            4'hd: seg_o = 8'ha1;
            4'he: seg_o = 8'h7f;        // on dot   :  0 -> on  7f = 0111_1111
            4'hf: seg_o = 8'hff;        // all off 
            default: seg_o = 8'hff;
        endcase

    end

endmodule

//////////////////////////////////////////////////////////////////////

// decoder_3to8
module decoder_3to8_stopwatch(
    input [2:0] i_dec_x,
    output reg [3:0] dec_y_o
);    

    always @(i_dec_x) begin
        case (i_dec_x)
            3'b000:   dec_y_o = 4'b1110;
            3'b001:   dec_y_o = 4'b1101;
            3'b010:   dec_y_o = 4'b1011;
            3'b011:   dec_y_o = 4'b0111;
            3'b100:   dec_y_o = 4'b1110;
            3'b101:   dec_y_o = 4'b1101;
            3'b110:   dec_y_o = 4'b1011;
            3'b111:   dec_y_o = 4'b0111;
            default: dec_y_o = 4'b1111;
        endcase
    end
endmodule

//////////////////////////////////////////////////////////////////////

module digit_splitter_stopwatch(
    input [6:0] i_dig_dig,
    output [3:0] dig_dig01_o,
    output [3:0] dig_dig10_o
);

    assign dig_dig01_o = i_dig_dig % 10;
    assign dig_dig10_o = (i_dig_dig / 10) % 10;

endmodule

//////////////////////////////////////////////////////////////////////

module mux_81_stopwatch(
    input  wire [2:0] i_mul_sel,
    input  wire [3:0] i_mul_x0,
    input  wire [3:0] i_mul_x1,
    input  wire [3:0] i_mul_x2,
    input  wire [3:0] i_mul_x3,
    input  wire [3:0] i_mul_x4,
    input  wire [3:0] i_mul_x5,
    input  wire [3:0] i_mul_x6,  
    input  wire [3:0] i_mul_x7,
    output reg  [3:0] mul_y_o
);

    always @(*) begin
        case (i_mul_sel)
            3'b000:   mul_y_o = i_mul_x0;
            3'b001:   mul_y_o = i_mul_x1;
            3'b010:   mul_y_o = i_mul_x2;
            3'b011:   mul_y_o = i_mul_x3;
            3'b100:   mul_y_o = i_mul_x4;
            3'b101:   mul_y_o = i_mul_x5;
            3'b110:   mul_y_o = i_mul_x6;
            3'b111:   mul_y_o = i_mul_x7;
            default: mul_y_o = 4'bx;
        endcase
    end
endmodule

//////////////////////////////////////////////////////////////////////

module mux_21_stopwatch(
    input  wire i_mul_sel,
    input  wire [3:0] i_mul_x0,
    input  wire [3:0] i_mul_x1,
    output reg  [3:0] mul_y_o
);

    always @(*) begin
        case (i_mul_sel)
            3'b000:   mul_y_o = i_mul_x0;
            3'b001:   mul_y_o = i_mul_x1;
            default: mul_y_o = 4'bx;
        endcase
    end
endmodule

//////////////////////////////////////////////////////////////////////

module comparator_stopwatch(
    input [6:0] i_comp_x, 
    // output [3:0] comp_y_o 
    output [3:0] comp_y_o
);  

    assign comp_y_o = (i_comp_x < 50) ? 4'he : 4'hf;            // on : off
    
endmodule

//////////////////////////////////////////////////////////////////////