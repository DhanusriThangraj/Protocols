`timescale 1ns/1ps

module receiver_tb;

    reg clk = 0;
    reg reset = 0;
    reg [1:0] baud_sel;
    reg [10:0] out_tx;
    wire inrx;
    wire [7:0] out_rx;
   
    always #5 clk = ~clk;
    
    // Instantiate Baud Generator
    baud_generator bg (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .intx(), // Not used
        .inrx(inrx)
    );

    // Instantiate Receiver
    receiver uut (
        .clk(clk),
        .reset(reset),
        .out_tx(out_tx),
        .inrx(inrx),
        .out_rx(out_rx)
           );

    initial begin
        $dumpfile("receiver.vcd");
        $dumpvars();
    end
  
    initial begin
        $display("Time\tclk\treset\tinrx\tout_tx\t\tout_rx\t");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%h\t", 
                 $time, clk, reset, inrx, out_tx, out_rx,);
    end

    initial begin
        reset = 1;
        baud_sel = 2'b10;  // 460800 baud rate
        out_tx = 11'b11111111111;  // idle
        #20 reset = 0;

        // Frame 1: 0_10101010_1_1 (correct)
        #100 out_tx = 11'b11010101010;  // data=0xAA, parity=1 (odd)
        #8000;

        // Frame 2: 0_01010101_0_1 (wrong parity)
        out_tx = 11'b10101010100;      // data=0x55, parity=0 (wrong)
        #8000;

        // Frame 3: 0_11110000_1_1 (correct)
        out_tx = 11'b11111000001;      // data=0xF0, parity=1
        #8000;

        // Frame 4: 0_00001111_0_1 (wrong parity)
        out_tx = 11'b10000111100;      // data=0x0F, parity=0 (wrong)
        #8000;

        // Frame 5: 0_11001100_1_1 (correct)
        out_tx = 11'b11100110001;      // data=0xCC, parity=1
        #8000;

        $finish;
    end

endmodule
