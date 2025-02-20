//=========== VGA Components for 640x480p ===========//
// To change resolution, google the parameters and change them appropriately //
module hsync(
    input clk,
    output reg hsync_out,
    output reg blank_out,
    output reg newline_out,
    output reg [10:0] pixel_count
);

    parameter TOTAL_COUNTER = 800;
    parameter SYNC = 96;
    parameter BACKPORCH = 48;
    parameter DISPLAY = 640;
    parameter FRONTPORCH = 16;

    reg [10:0] counter;

    assign pixel_count = counter;

    // ������� ��������
    always @ (posedge clk) begin
        if (counter < TOTAL_COUNTER)
            counter <= counter + 11'b0000000001;
        else
            counter <= 11'b0000000000;
    end

    // ��������� ������� �������������� �������������
    always @ (posedge clk) begin
        if (counter < (DISPLAY + FRONTPORCH))
            hsync_out <= 1;
        else if (counter >= (DISPLAY + FRONTPORCH) && counter < (DISPLAY + FRONTPORCH + SYNC))
            hsync_out <= 0;
        else if (counter >= (DISPLAY + FRONTPORCH + SYNC))
            hsync_out <= 1;
    end

    // ��������� ������� ����������� (������� ������� �� ����� �����������)
    always @ (posedge clk) begin
        if (counter < DISPLAY)
            blank_out <= 0;
        else
            blank_out <= 1;
    end

    // ��������� ������� ����� ������
    always @ (posedge clk) begin
        if (counter == 0)
            newline_out <= 1;
        else
            newline_out <= 0;
    end

endmodule


module vsync(
    input newline_in,
    output reg vsync_out,
    output reg blank_out,
    output reg [10:0] pixel_count
);

    parameter TOTAL_COUNTER = 525;
    parameter SYNC = 2;
    parameter BACKPORCH = 33;
    parameter DISPLAY = 480;
    parameter FRONTPORCH = 10;

    reg [10:0] counter;

    assign pixel_count = counter;

    // ������� �����
    always @ (posedge newline_in) begin
        if (counter < TOTAL_COUNTER)
            counter <= counter + 11'b0000000001;
        else
            counter <= 11'b0000000000;
    end

    // ��������� ������� ������������ �������������
    always @ (posedge newline_in) begin
        if (counter < (DISPLAY + FRONTPORCH))
            vsync_out <= 1;
        else if (counter >= (DISPLAY + FRONTPORCH) && counter < (DISPLAY + FRONTPORCH + SYNC))
            vsync_out <= 0;
        else if (counter >= (DISPLAY + FRONTPORCH + SYNC))
            vsync_out <= 1;
    end

    // ��������� ������� ����������� (������� ������� �� ����� �����������)
    always @ (posedge newline_in) begin
        if (counter < DISPLAY)
            blank_out <= 0;
        else
            blank_out <= 1;
    end

endmodule


module data(
    input clk,
    input done,
    input hblank,
    input vblank,
    input [10:0] horizontal_count,
    input [10:0] vertical_count,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    input [23:0] f0, input [23:0] f1, input [23:0] f2, input [23:0] f3,
    input [23:0] f4, input [23:0] f5, input [23:0] f6, input [23:0] f7,
    input [23:0] f8, input [23:0] f9, input [23:0] f10, input [23:0] f11,
    input [23:0] f12, input [23:0] f13, input [23:0] f14, input [23:0] f15
);

    reg [3:0] r_reg, g_reg, b_reg;

    wire [47:0] scaled_f0, scaled_f1, scaled_f2, scaled_f3,
                scaled_f4, scaled_f5, scaled_f6, scaled_f7,
                scaled_f8, scaled_f9, scaled_f10, scaled_f11,
                scaled_f12, scaled_f13, scaled_f14, scaled_f15;

    // �������� �������������� ��� ��������������� �������� f0-f15
    assign scaled_f0 = ({{24{f0[23]}}, f0} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f1 = ({{24{f1[23]}}, f1} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f2 = ({{24{f2[23]}}, f2} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f3 = ({{24{f3[23]}}, f3} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f4 = ({{24{f4[23]}}, f4} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f5 = ({{24{f5[23]}}, f5} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f6 = ({{24{f6[23]}}, f6} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f7 = ({{24{f7[23]}}, f7} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f8 = ({{24{f8[23]}}, f8} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f9 = ({{24{f9[23]}}, f9} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f10 = ({{24{f10[23]}}, f10} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f11 = ({{24{f11[23]}}, f11} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f12 = ({{24{f12[23]}}, f12} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f13 = ({{24{f13[23]}}, f13} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f14 = ({{24{f14[23]}}, f14} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;
    assign scaled_f15 = ({{24{f15[23]}}, f15} * (48'b1111_1111_1111_1111_1111_1111_1111_1111_1110_0010_0000) + {10'b0, 24'd480, 14'b0}) >>> 14;

    assign r = r_reg;
    assign g = g_reg;
    assign b = b_reg;

    // ���������� ������ ��������
    always @ (posedge clk) begin
        if (hblank == 1 || vblank == 1) begin
            r_reg <= 4'b0;
            g_reg <= 4'b0;
            b_reg <= 4'b0;
        end
        // Column 0
        else if (horizontal_count < 40) begin
            r_reg <= (vertical_count > scaled_f8) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f8) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f8) ? 4'b0000 : 4'b0;
        end
        // Column 1
        else if (horizontal_count > 40 && horizontal_count < 80) begin
            r_reg <= (vertical_count > scaled_f9) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f9) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f9) ? 4'b0000 : 4'b0;
        end
        // Column 2
        else if (horizontal_count > 80 && horizontal_count < 120) begin
            r_reg <= (vertical_count > scaled_f10) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f10) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f10) ? 4'b0000 : 4'b0;
        end
        // Column 3
        else if (horizontal_count > 120 && horizontal_count < 160) begin
            r_reg <= (vertical_count > scaled_f11) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f11) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f11) ? 4'b0000 : 4'b0;
        end
        // Column 4
        else if (horizontal_count > 160 && horizontal_count < 200) begin
            r_reg <= (vertical_count > scaled_f12) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f12) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f12) ? 4'b0000 : 4'b0;
        end
        // Column 5
        else if (horizontal_count > 200 && horizontal_count < 240) begin
            r_reg <= (vertical_count > scaled_f13) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f13) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f13) ? 4'b0000 : 4'b0;
        end
        // Column 6
        else if (horizontal_count > 240 && horizontal_count < 280) begin
            r_reg <= (vertical_count > scaled_f14) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f14) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f14) ? 4'b0000 : 4'b0;
        end
        // Column 7
        else if (horizontal_count > 280 && horizontal_count < 320) begin
            r_reg <= (vertical_count > scaled_f15) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f15) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f15) ? 4'b0000 : 4'b0;
        end
        // Column 8
        else if (horizontal_count > 320 && horizontal_count < 360) begin
            r_reg <= (vertical_count > scaled_f0) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f0) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f0) ? 4'b0000 : 4'b0;
        end
        // Column 9
        else if (horizontal_count > 360 && horizontal_count < 400) begin
            r_reg <= (vertical_count > scaled_f1) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f1) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f1) ? 4'b0000 : 4'b0;
        end
        // Column 10
        else if (horizontal_count > 400 && horizontal_count < 440) begin
            r_reg <= (vertical_count > scaled_f2) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f2) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f2) ? 4'b0000 : 4'b0;
        end
        // Column 11
        else if (horizontal_count > 440 && horizontal_count < 480) begin
            r_reg <= (vertical_count > scaled_f3) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f3) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f3) ? 4'b0000 : 4'b0;
        end
        // Column 12
        else if (horizontal_count > 480 && horizontal_count < 520) begin
            r_reg <= (vertical_count > scaled_f4) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f4) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f4) ? 4'b0000 : 4'b0;
        end
        // Column 13
        else if (horizontal_count > 520 && horizontal_count < 560) begin
            r_reg <= (vertical_count > scaled_f5) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f5) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f5) ? 4'b0000 : 4'b0;
        end
        // Column 14
        else if (horizontal_count > 560 && horizontal_count < 600) begin
            r_reg <= (vertical_count > scaled_f6) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f6) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f6) ? 4'b0000 : 4'b0;
        end
        // Column 15
        else if (horizontal_count > 600 && horizontal_count < 640) begin
            r_reg <= (vertical_count > scaled_f7) ? 4'b1100 : 4'b0;
            g_reg <= (vertical_count > scaled_f7) ? 4'b0000 : 4'b0;
            b_reg <= (vertical_count > scaled_f7) ? 4'b0000 : 4'b0;
        end
        else begin
            r_reg <= 4'b1111;
            g_reg <= 4'b1111;
            b_reg <= 4'b1111;
        end
    end

endmodule


module VGA_generator(
    input clk,
    input done,
    output vsync,
    output hsync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    input [23:0] f0, input [23:0] f1, input [23:0] f2, input [23:0] f3,
    input [23:0] f4, input [23:0] f5, input [23:0] f6, input [23:0] f7,
    input [23:0] f8, input [23:0] f9, input [23:0] f10, input [23:0] f11,
    input [23:0] f12, input [23:0] f13, input [23:0] f14, input [23:0] f15
);

    wire hblank, vblank, newline;
    wire [10:0] horizontal_count, vertical_count;

    reg [23:0] f0_reg, f1_reg, f2_reg, f3_reg,
               f4_reg, f5_reg, f6_reg, f7_reg,
               f8_reg, f9_reg, f10_reg, f11_reg,
               f12_reg, f13_reg, f14_reg, f15_reg,
               f0_display, f1_display, f2_display, f3_display,
               f4_display, f5_display, f6_display, f7_display,
               f8_display, f9_display, f10_display, f11_display,
               f12_display, f13_display, f14_display, f15_display;

    vsync vertical(newline, vsync, vblank, vertical_count);
    hsync horizontal(clk, hsync, hblank, newline, horizontal_count);

    // �������� ������ FFT ��� ����������
    always @ (posedge clk) begin
        if (done) begin
            f0_reg <= f0;
            f1_reg <= f1;
            f2_reg <= f2;
            f3_reg <= f3;
            f4_reg <= f4;
            f5_reg <= f5;
            f6_reg <= f6;
            f7_reg <= f7;
            f8_reg <= f8;
            f9_reg <= f9;
            f10_reg <= f10;
            f11_reg <= f11;
            f12_reg <= f12;
            f13_reg <= f13;
            f14_reg <= f14;
            f15_reg <= f15;
        end
    end

    // ���������� ������������ ������
    always @ (posedge clk) begin
        if (horizontal_count > 640 && vertical_count > 480) begin
            f0_display <= f0_reg[23] ? 24'b0 : f0_reg;
            f1_display <= f1_reg[23] ? 24'b0 : f1_reg;
            f2_display <= f2_reg[23] ? 24'b0 : f2_reg;
            f3_display <= f3_reg[23] ? 24'b0 : f3_reg;
            f4_display <= f4_reg[23] ? 24'b0 : f4_reg;
            f5_display <= f5_reg[23] ? 24'b0 : f5_reg;
            f6_display <= f6_reg[23] ? 24'b0 : f6_reg;
            f7_display <= f7_reg[23] ? 24'b0 : f7_reg;
            f8_display <= f8_reg[23] ? 24'b0 : f8_reg;
            f9_display <= f9_reg[23] ? 24'b0 : f9_reg;
            f10_display <= f10_reg[23] ? 24'b0 : f10_reg;
            f11_display <= f11_reg[23] ? 24'b0 : f11_reg;
            f12_display <= f12_reg[23] ? 24'b0 : f12_reg;
            f13_display <= f13_reg[23] ? 24'b0 : f13_reg;
            f14_display <= f14_reg[23] ? 24'b0 : f14_reg;
            f15_display <= f15_reg[23] ? 24'b0 : f15_reg;
        end
        else begin
            f0_display <= f0_display;
            f1_display <= f1_display;
            f2_display <= f2_display;
            f3_display <= f3_display;
            f4_display <= f4_display;
            f5_display <= f5_display;
            f6_display <= f6_display;
            f7_display <= f7_display;
            f8_display <= f8_display;
            f9_display <= f9_display;
            f10_display <= f10_display;
            f11_display <= f11_display;
            f12_display <= f12_display;
            f13_display <= f13_display;
            f14_display <= f14_display;
            f15_display <= f15_display;
        end
    end

    data display(
        .clk(clk),
        .done(done),
        .hblank(hblank),
        .vblank(vblank),
        .horizontal_count(horizontal_count),
        .vertical_count(vertical_count),
        .r(r),
        .g(g),
        .b(b),
        .f0(f0_display), .f1(f1_display), .f2(f2_display), .f3(f3_display),
        .f4(f4_display), .f5(f5_display), .f6(f6_display), .f7(f7_display),
        .f8(f8_display), .f9(f9_display), .f10(f10_display), .f11(f11_display),
        .f12(f12_display), .f13(f13_display), .f14(f14_display), .f15(f15_display)
    );

endmodule
