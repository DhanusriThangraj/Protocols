`timescale 1ns/1ps

module baud_generator_tb;

    reg clk;
    reg reset;
    reg [1:0] baud_sel;
    wire intx, inrx;

  
    baud_generator uut (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .intx(intx),
        .inrx(inrx)
    );
    initial begin
	    $dumpfile("baud_uart.vcd");
	    $dumpvars();
    end
    // Clock generation: 150 MHz => Period = 6.667 ns ≈ 7 ns
    initial #10  clk = 1;
    always #5 clk = ~clk;
  initial begin
        $display("Time\tclk\treset\tbaud_sel\tintx\tinrx");
        $monitor("%0t\t%b\t%b\t%0d\t\t%b\t%b", $time, clk, reset, baud_sel, intx, inrx);
    end

    initial begin
       #10 reset = 1;
        baud_sel = 2'b00;

                #10 reset = 0;

      baud_sel = 2'b01;//4800
    // #500000 baud_sel = 2'b10;//19200
     #500000 baud_sel = 2'b11;//460800
      #500000 baud_sel = 2'b01;//4800
     #500000 baud_sel = 2'b10;//19200
     #500000 baud_sel = 2'b11;//460800

     
     #500000 $finish;
    end

   endmodule

