//The output clock frequency is based on the formula clk_out [Hz] = clk_in [Hz] / (2+2*counter_threshold)

module clkdiv (
    input clk_in,      // ������� �������� ������
    output clk_out      // �������� �������� ������
);

    parameter counter_threshold = 1; // ����� �������� ��� ������� �������
    reg [31:0] clk_counter;          // ������� ��� ������� �������

    // ������� ��� ��������� ��������� ������� (��������� ��� ���������)
    reg clk_out_reg;

    // �������� ��������� ��������� ������� � ��������
    assign clk_out = clk_out_reg;

    // ������������� �������� � ��������� ��������� �������
    initial begin
        clk_counter <= 32'b0;
        clk_out_reg <= 1'b1;
    end

    // �������� ����, ���������� �� ������ ������������� ������ �������� ��������� �������
    always @ (posedge clk_in) begin
        if (clk_counter >= counter_threshold) begin
            // ����� �������� � �������� ��������� ��������� �������
            clk_counter <= 32'b0;
            clk_out_reg <= ~clk_out_reg;
        end else begin
            // ���������� ��������
            clk_counter <= clk_counter + 32'b1;
        end
    end

endmodule