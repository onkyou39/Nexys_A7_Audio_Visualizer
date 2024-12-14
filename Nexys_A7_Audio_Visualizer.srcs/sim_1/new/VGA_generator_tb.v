`timescale 1ns / 1ps

module tb_VGA_generator;

    // Параметры для тестирования
    localparam CLK_PERIOD = 20; // Период тактового сигнала в наносекундах
    localparam NUM_CLKS = 100000; // Количество тактовых циклов для тестирования

    // Сигналы
    reg clk;
    reg reset;
    reg done;
    wire vsync;
    wire hsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;
    reg [23:0] f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15;

    // Инстанцирование модуля VGA_generator
    VGA_generator uut (
        .clk(clk),
        .reset(reset),
        .done(done),
        .vsync(vsync),
        .hsync(hsync),
        .r(r),
        .g(g),
        .b(b),
        .f0(f0),
        .f1(f1),
        .f2(f2),
        .f3(f3),
        .f4(f4),
        .f5(f5),
        .f6(f6),
        .f7(f7),
        .f8(f8),
        .f9(f9),
        .f10(f10),
        .f11(f11),
        .f12(f12),
        .f13(f13),
        .f14(f14),
        .f15(f15)
    );

    // Генерация тактового сигнала
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Инициализация и генерация сигналов
    initial begin
        // Инициализация сигналов
        clk = 0;
        reset = 1;
        done = 0;
        f0 = 24'd0; f1 = 24'd0; f2 = 24'd0; f3 = 24'd0; f4 = 24'd0; f5 = 24'd0; f6 = 24'd0; f7 = 24'd0;
        f8 = 24'd0; f9 = 24'd0; f10 = 24'd0; f11 = 24'd0; f12 = 24'd0; f13 = 24'd0; f14 = 24'd0; f15 = 24'd0;

        // Сброс модуля
        #10;
        reset = 0;

        // Генерация данных
        #100;
        f0 = 24'd100; f1 = 24'd200; f2 = 24'd300; f3 = 24'd400; f4 = 24'd500; f5 = 24'd600; f6 = 24'd700; f7 = 24'd800;
        f8 = 24'd900; f9 = 24'd1000; f10 = 24'd1100; f11 = 24'd1200; f12 = 24'd1300; f13 = 24'd1400; f14 = 24'd1500; f15 = 24'd1600;
        done = 1;

        // Ожидание завершения тестирования
        #(NUM_CLKS * CLK_PERIOD);

        // Завершение тестирования
        $stop;
    end

    // Мониторинг сигналов
    initial begin
        $monitor("Time: %0t, clk: %b, reset: %b, done: %b, vsync: %b, hsync: %b, r: %h, g: %h, b: %h",
                  $time, clk, reset, done, vsync, hsync, r, g, b);
    end

endmodule
