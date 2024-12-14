module TOP(
    input clk,          // Входной тактовый сигнал
    input reset,        // Сигнал сброса
    input DOUT,         // Входной сигнал данных
    output LRCLK,       // Выходной сигнал для левого/правого канала
    //output BCLK,        // Выходной сигнал битового такта
    output vsync,       // Выходной сигнал вертикальной синхронизации
    output hsync,       // Выходной сигнал горизонтальной синхронизации
    output [3:0] r,     // Выходной сигнал для красного цвета (4 бита)
    output [3:0] g,     // Выходной сигнал для зеленого цвета (4 бита)
    output [3:0] b,      // Выходной сигнал для синего цвета (4 бита)
    output mic_clk
);

    // Внутренние сигналы
    wire new_t, done, system_clk, vga_clk;
    wire [17:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15;
    wire [23:0] f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15;

    // Инстанцирование модуля clkdiv для генерации vga_clk
    clkdiv #(1) vga_clock(
        .clk_in(clk),
        .clk_out(vga_clk)
    );

    // Инстанцирование модуля clkdiv для генерации system_clk
    clkdiv #(398) main_clock(
        .clk_in(clk),
        .clk_out(system_clk)
    );
    
    clkdiv #(34) mic_clock(
        .clk_in(clk),
        .clk_out(mic_clk)
    );    

    // Инстанцирование модуля mic_translator
   mic_translator main_translator(
        .clk(system_clk),
        .reset(reset),
        .DOUT(DOUT),
        .LRCLK(LRCLK),
        .BCLK(1),
        .new_t(new_t),
        .t0(t0), .t1(t1), .t2(t2), .t3(t3),
        .t4(t4), .t5(t5), .t6(t6), .t7(t7),
        .t8(t8), .t9(t9), .t10(t10), .t11(t11),
        .t12(t12), .t13(t13), .t14(t14), .t15(t15)
    );

    // Инстанцирование модуля FFT_Processor
    FFT_Processor main_processor(
        .clk(system_clk),
        .reset(reset),
        .new_t(new_t),
        .t0(t0), .t1(t1), .t2(t2), .t3(t3),
        .t4(t4), .t5(t5), .t6(t6), .t7(t7),
        .t8(t8), .t9(t9), .t10(t10), .t11(t11),
        .t12(t12), .t13(t13), .t14(t14), .t15(t15),
        .f0(f0), .f1(f1), .f2(f2), .f3(f3),
        .f4(f4), .f5(f5), .f6(f6), .f7(f7),
        .f8(f8), .f9(f9), .f10(f10), .f11(f11),
        .f12(f12), .f13(f13), .f14(f14), .f15(f15),
        .done(done)
    );

    // Инстанцирование модуля VGA_generator
    VGA_generator main_vga(
        .clk(vga_clk),
        .done(done),
        .vsync(vsync),
        .hsync(hsync),
        .r(r),
        .g(g),
        .b(b),
        .f0(f0), .f1(f1), .f2(f2), .f3(f3),
        .f4(f4), .f5(f5), .f6(f6), .f7(f7),
        .f8(f8), .f9(f9), .f10(f10), .f11(f11),
        .f12(f12), .f13(f13), .f14(f14), .f15(f15)
    );

endmodule
