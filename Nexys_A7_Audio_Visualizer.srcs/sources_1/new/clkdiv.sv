//The output clock frequency is based on the formula clk_out [Hz] = clk_in [Hz] / (2+2*counter_threshold)

module clkdiv (
    input clk_in,      // Входной тактовый сигнал
    output clk_out      // Выходной тактовый сигнал
);

    parameter counter_threshold = 1; // Порог счетчика для деления частоты
    reg [31:0] clk_counter;          // Счетчик для деления частоты

    // Регистр для выходного тактового сигнала (необходим для симуляции)
    reg clk_out_reg;

    // Привязка выходного тактового сигнала к регистру
    assign clk_out = clk_out_reg;

    // Инициализация счетчика и выходного тактового сигнала
    initial begin
        clk_counter <= 32'b0;
        clk_out_reg <= 1'b1;
    end

    // Основной блок, работающий на каждом положительном фронте входного тактового сигнала
    always @ (posedge clk_in) begin
        if (clk_counter >= counter_threshold) begin
            // Сброс счетчика и инверсия выходного тактового сигнала
            clk_counter <= 32'b0;
            clk_out_reg <= ~clk_out_reg;
        end else begin
            // Увеличение счетчика
            clk_counter <= clk_counter + 32'b1;
        end
    end

endmodule