module mic_pdm_reader_array (
    input clk,                     // Входной тактовый сигнал
    input reset,                   // Сигнал сброса
    input pdm_data,                // PDM-данные от микрофона
    //output reg [17:0] samples [0:15], // Массив выборок (16 штук по 18 бит)
    output reg new_block,           // Сигнал готовности нового блока
    output [17:0] t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15
);

    parameter DECIMATION_FACTOR = 64;
    parameter NUM_SAMPLES = 16;

    reg [17:0] samples [0:15];
    reg signed [17:0] accumulator; // 18-битный накопитель
    reg [5:0] pdm_counter;
    reg [3:0] sample_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= 0;
            pdm_counter <= 0;
            sample_index <= 0;
            new_block <= 0;
        end else begin
            // Интеграция PDM
            accumulator <= accumulator + (pdm_data ? 1 : -1); // Накопление с 18-битной точностью
            pdm_counter <= pdm_counter + 1;
            // Если накоплен DECIMATION_FACTOR PDM-битов
            if (pdm_counter == (DECIMATION_FACTOR - 1)) begin
                pdm_counter <= 0;
                samples[sample_index] <= accumulator; // Сохранение выборки
                accumulator <= 0;

                if (sample_index == (NUM_SAMPLES - 1)) begin
                    sample_index <= 0;
                    new_block <= 1; // Новый блок данных готов
                end else begin
                    sample_index <= sample_index + 1;
                    new_block <= 0;
                end
            end
        end
    end
    
    assign t0 = samples[0];
    assign t1 = samples[1];
    assign t2 = samples[2];
    assign t3 = samples[3];
    assign t4 = samples[4];
    assign t5 = samples[5];
    assign t6 = samples[6];
    assign t7 = samples[7];
    assign t8 = samples[8];
    assign t9 = samples[9];
    assign t10 = samples[10];
    assign t11 = samples[11];
    assign t12 = samples[12];
    assign t13 = samples[13];
    assign t14 = samples[14];
    assign t15 = samples[15];

endmodule