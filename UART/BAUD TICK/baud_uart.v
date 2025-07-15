module baud_generator #(parameter frequency_tx = 50000000, frequency_rx = 40000000)(
    input clk_1,
    input clk_2,
    input reset,
    input [1:0] baud_sel,
    output reg intx,
    output reg inrx
);

reg [31:0] baud_partition_tx;
reg [31:0] baud_partition_rx;
reg [31:0] count_tx;
reg [31:0] count_rx;

always @(posedge clk_1 or posedge reset) begin
    if (reset) begin
        count_tx <= 0;
        intx <= 0;
    end else begin
        case (baud_sel)
            2'b00: baud_partition_tx = frequency_tx / 4800;
            2'b01: baud_partition_tx = frequency_tx / 9600;
            2'b10: baud_partition_tx = frequency_tx / 19200;
            2'b11: baud_partition_tx = frequency_tx / 38400;
        endcase

        if (count_tx >= baud_partition_tx) begin
            intx <= 1'b1;
            count_tx <= 0;
        end else begin
            intx <= 1'b0;
            count_tx <= count_tx + 1;
        end
    end
end

always @(posedge clk_2 or posedge reset) begin
    if (reset) begin
        count_rx <= 0;
        inrx <= 0;
    end else begin
        case (baud_sel)
            2'b00: baud_partition_rx = frequency_rx / 4800;
            2'b01: baud_partition_rx = frequency_rx / 9600;
            2'b10: baud_partition_rx = frequency_rx / 19200;
            2'b11: baud_partition_rx = frequency_rx / 38400;
        endcase

        if (count_rx >= baud_partition_rx) begin
            inrx <= 1'b1;
            count_rx <= 0;
        end else begin
            inrx <= 1'b0;
            count_rx <= count_rx + 1;
        end
    end
end

endmodule





 




