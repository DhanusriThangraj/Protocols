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

module transmitter (
    input clk_1,
    input reset,
    input [7:0] data_in,
    input intx,
    output reg tx_line
);

reg [3:0] count;
reg [10:0] shift_reg;
reg [2:0] state;

parameter IDLE = 3'd0, LOAD = 3'd1, SEND = 3'd2;

always @(posedge clk_1 or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        tx_line <= 1'b1;
    end else begin
        case (state)
            IDLE: begin
                if (intx) begin
                    shift_reg[0] <= 0; // Start
                    shift_reg[8:1] <= data_in; // Data
                    shift_reg[9] <= ^data_in; // Odd Parity
                    shift_reg[10] <= 1'b1; // Stop
                    count <= 0;
                    state <= SEND;
                end
            end

            SEND: begin
                if (intx) begin
                    tx_line <= shift_reg[count];
                    count <= count + 1;
                    if (count == 10)
                        state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
module receiver (
    input clk_2,
    input reset,
    input rx_line,
    input inrx,
    output reg [7:0] out_rx,
    output reg error
);

reg [3:0] count;
reg [2:0] state;
reg [7:0] temp_rx;
reg parity_bit;

parameter IDLE = 3'd0, START = 3'd1, DATA = 3'd2, PARITY = 3'd3, STOP = 3'd4;

always @(posedge clk_2 or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        out_rx <= 0;
        error <= 0;
    end else if (inrx) begin
        case (state)
            IDLE: begin
                if (rx_line == 0) begin
                    count <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
                temp_rx[count] <= rx_line;
                count <= count + 1;
                if (count == 7)
                    state <= PARITY;
            end

            PARITY: begin
                parity_bit <= rx_line;
                if (parity_bit !== (^temp_rx))
                    error <= 1;
                else
                    error <= 0;
                state <= STOP;
            end

            STOP: beginmodule baud_generator(
    input clk, reset,
    input [1:0] baud_sel,
    output reg intx,
    output reg inrx
);
//frequency=150 MHz
reg [31:0] baud_partition_tx = 0;
reg [31:0] baud_partition_rx = 0;
reg [31:0] count_tx = 0;
reg [31:0] count_rx = 0;

always @(*) begin
    case (baud_sel)
        2'b00: begin baud_partition_tx = 31250; baud_partition_rx = 31250; end
        2'b01: begin baud_partition_tx = 7813;  baud_partition_rx = 7813;  end
        2'b10: begin baud_partition_tx = 325;   baud_partition_rx = 325;   end
        2'b11: begin baud_partition_tx = 162;   baud_partition_rx = 162;   end
    endcase
end
	
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        intx <= 0;
        count_tx <= 0;
    end else if (count_tx == baud_partition_tx - 1) begin
        intx <= 1;
        count_tx <= 0;
    end else begin
        intx <= 0;
        count_tx <= count_tx + 1;
    end
end

always @ (posedge clk or posedge reset) begin
    if (reset) begin

                if (rx_line == 1) begin
                    out_rx <= temp_rx;
                end else begin
                    error <= 1;
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule
