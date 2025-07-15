`timescale 1ns/1ps

module uart_tb;

    reg clk_1 = 0;
    reg clk_2 = 0;
    reg reset;
    reg [1:0] baud_sel;
    reg [7:0] data;
    wire intx, inrx;
    wire tx_line;
    wire [7:0] out_rx;
    wire error;

    always #10 clk_1 = ~clk_1;     // 50 MHz
    always #12.5 clk_2 = ~clk_2;   // 40 MHz

    baud_generator bg (
        .clk_1(clk_1), .clk_2(clk_2),
        .reset(reset),
        .baud_sel(baud_sel),
        .intx(intx),
        .inrx(inrx)
    );

    transmitter tx (
        .clk_1(clk_1),
        .reset(reset),
        .data_in(data),
        .intx(intx),
        .tx_line(tx_line)
    );

    receiver rx (
        .clk_2(clk_2),
        .reset(reset),
        .rx_line(tx_line),
        .inrx(inrx),
        .out_rx(out_rx),
        .error(error)
    );

    initial begin
        $dumpfile("UART_WAVE.vcd");
        $dumpvars(0, uart_tb);

        reset = 1;
        baud_sel = 2'b11; // 19200
        data = 8'b1111_1010;
        #100;
        reset = 0;

        #10000000;

        $display("Transmitted Data: %b", data);
        $display("Received Data   : %b", out_rx);
        $display("Parity Error    : %b", error);

        #100000;
        $finish;
    end

endmodule
