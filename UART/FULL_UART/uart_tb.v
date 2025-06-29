
`timescale 1ns/1ps

module uart_tb;

    reg clk = 0;
    reg reset = 0;
    reg [1:0] baud_sel;
    reg [7:0] data;
    wire intx, inrx;
    wire [10:0] out_tx;
    wire [7:0] out_rx;
  // Clock generation: 150 MHz
    always #5 clk = ~clk;

    // Instantiate baud generator
    baud_generator bg (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .intx(intx),
        .inrx(inrx)
    );

    // Instantiate transmitter
    transmitter tx (
        .clk(clk),
        .reset(reset),
        .data_in(data),
        .intx(intx),
        .out_tx(out_tx)
    );

    // Instantiate receiver
    receiver rx (
        .clk(clk),
        .reset(reset),
        .out_tx(out_tx),
        .inrx(inrx),
        .out_rx(out_rx)
    );

    initial begin
        $dumpfile("uart_wave.vcd");
        $dumpvars(0, uart_tb);
    end

    initial begin
        reset = 1; baud_sel = 2'b10; // 460800 baud
        #20 reset = 0;

        data = 8'b10101010;
        #100000 $finish;
    end

endmodule
