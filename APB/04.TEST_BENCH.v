module tb_apb;

    parameter DATA = 32;
    parameter ADDR = 32;

    reg  pclk;
    reg  presetn;
    reg  transfer;
    reg  rw;
    reg  
    reg  [ADDR-1:0] addr_in;
    reg  [DATA-1:0] data_in;
    wire [DATA-1:0] prdata;

    Top #(.DATA(DATA), .ADDR(ADDR)) dut (
        .pclk   (pclk),
        .presetn(presetn),
      .transfer(transfer),
        .rw     (rw),
        .addr_in(addr_in),
        .data_in(data_in),
        .prdata (prdata)
    );

    // Clock
    initial pclk = 0;
    always #5 pclk = ~pclk;

    initial begin
        $dumpfile("Waves.vcd");
        $dumpvars;

        // Reset
        presetn = 0;
        transfer = 0;
        rw = 0;
        addr_in = 0;
        data_in = 0;
        #15 presetn = 1;

        // Write
      apb_write(8'h0A, 32'hAAAA);
      apb_write(8'h0B, 32'hBBBB);
      apb_write(8'h0C, 32'hCCCC);

        // Read
        apb_read(8'h0A);
        apb_read(8'h0B);
        apb_read(8'h0C);

        #50 $finish;
    end

    // APB write request
    task apb_write(input [ADDR-1:0] addr, input [DATA-1:0] data);
    begin
        @(posedge pclk);
        addr_in = addr;
        data_in = data;
        rw = 1;
        transfer = 1;

        @(posedge pclk);
        transfer = 0; 
      repeat(3) @(posedge pclk);
      $display("---WRITE--- Addr=%0h Data=%0h", addr, data);
    end
    endtask

    // APB read request
    task apb_read(input [ADDR-1:0] addr);
    begin
        @(posedge pclk);
        addr_in = addr;
        rw = 0;
        transfer = 1;

        @(posedge pclk);
        transfer = 0; 

        
        repeat(3) @(posedge pclk);
      $display("---READ---  Addr=%0h Data=%0h", addr, prdata);
    end
    endtask
endmodule
