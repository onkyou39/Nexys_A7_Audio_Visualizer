`define _NUM_DATA_BITS 31         // Количество битов данных
`define _NUM_SAMPLE_BITS 18        // Количество битов выборки
`define _CALIBRATION {13'd226, 5'd0} // Калибровочное значение

module mic_translator(
    input clk,                     // Входной тактовый сигнал
    input reset,                   // Сигнал сброса
    input DOUT,                     // Входной сигнал данных
    output LRCLK,                   // Выходной сигнал для левого/правого канала
    output BCLK,                    // Выходной сигнал битового такта
    output new_t,                   // Сигнал нового временного блока
    output [17:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15 // Выходные данные (18 бит каждый)
);

    reg [17:0] data_buffer;       // Буфер данных
    reg [6:0] data_counter;        // Счетчик данных
    reg [31:0] bit_cnt;            // Счетчик битов
    reg [17:0] calibrated_data_buffer; // Калиброванный буфер данных

    // Регистры для симуляции
    reg [17:0] t0_reg, t1_reg, t2_reg, t3_reg,
                t4_reg, t5_reg, t6_reg, t7_reg,
                t8_reg, t9_reg, t10_reg, t11_reg,
                t12_reg, t13_reg, t14_reg, t15_reg;
    reg BCLK_reg, LRCLK_reg, new_t_reg;

    // Привязка выходных данных к регистрам
    assign t0 = t0_reg;
    assign t1 = t1_reg;
    assign t2 = t2_reg;
    assign t3 = t3_reg;
    assign t4 = t4_reg;
    assign t5 = t5_reg;
    assign t6 = t6_reg;
    assign t7 = t7_reg;
    assign t8 = t8_reg;
    assign t9 = t9_reg;
    assign t10 = t10_reg;
    assign t11 = t11_reg;
    assign t12 = t12_reg;
    assign t13 = t13_reg;
    assign t14 = t14_reg;
    assign t15 = t15_reg;
    assign BCLK = BCLK_reg;
    assign LRCLK = LRCLK_reg;
    assign new_t = new_t_reg;

    // Калибровка данных
    assign calibrated_data_buffer = data_buffer + `_CALIBRATION;

    // Генерация сигнала BCLK
    always @ (clk, reset) begin
        if (reset == 1'b0) begin
            BCLK_reg <= 1'b1;
        end else begin
            BCLK_reg <= clk;
        end
    end

    // Генерация сигнала LRCLK
    always @ (negedge clk) begin
        if (reset == 1'b0) begin
            LRCLK_reg <= 1'b1;
            bit_cnt <= 32'b0;
        end else if (bit_cnt < `_NUM_DATA_BITS) begin
            LRCLK_reg <= LRCLK_reg;
            bit_cnt <= bit_cnt + 32'b1;
        end else begin
            LRCLK_reg <= ~LRCLK_reg;
            bit_cnt <= 32'b0;
        end
    end

    // Основной блок обработки данных
    always @ (posedge clk) begin
        if (reset == 1'b0) begin
            data_counter <= 7'b0;
            data_buffer <= 18'b0;
            new_t_reg <= 1'b0;
            t15_reg <= 18'b0;
            t14_reg <= 18'b0;
            t13_reg <= 18'b0;
            t12_reg <= 18'b0;
            t11_reg <= 18'b0;
            t10_reg <= 18'b0;
            t9_reg <= 18'b0;
            t8_reg <= 18'b0;
            t7_reg <= 18'b0;
            t6_reg <= 18'b0;
            t5_reg <= 18'b0;
            t4_reg <= 18'b0;
            t3_reg <= 18'b0;
            t2_reg <= 18'b0;
            t1_reg <= 18'b0;
            t0_reg <= 18'b0;
        end else if (data_counter < `_NUM_SAMPLE_BITS) begin
            data_counter <= data_counter + 6'b1;
            data_buffer <= {data_buffer[16:0], DOUT};
            new_t_reg <= 1'b0;
        end else if (data_counter == `_NUM_SAMPLE_BITS) begin
            data_counter <= data_counter + 6'b1;
            data_buffer <= 17'b0;
            if (LRCLK_reg == 0) begin
                new_t_reg <= 1'b1;
                t15_reg <= t14_reg;
                t14_reg <= t13_reg;
                t13_reg <= t12_reg;
                t12_reg <= t11_reg;
                t11_reg <= t10_reg;
                t10_reg <= t9_reg;
                t9_reg <= t8_reg;
                t8_reg <= t7_reg;
                t7_reg <= t6_reg;
                t6_reg <= t5_reg;
                t5_reg <= t4_reg;
                t4_reg <= t3_reg;
                t3_reg <= t2_reg;
                t2_reg <= t1_reg;
                t1_reg <= t0_reg;
                t0_reg <= calibrated_data_buffer; // FFT Processor takes 18 bit 2's complement // use calibrated to remove base offset
            end else begin
                new_t_reg <= 1'b0;
            end
        end else if (data_counter >= `_NUM_DATA_BITS) begin
            data_counter <= 0;
            data_buffer <= 10'b0;
            new_t_reg <= 1'b0;
        end else begin
            data_counter <= data_counter + 6'b1;
        end
    end

endmodule
