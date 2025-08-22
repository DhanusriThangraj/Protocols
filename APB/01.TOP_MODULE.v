`include "master.v"
`include "slave.v"
module Top #(parameter DATA = 32, ADDR = 32)(
    input  wire             pclk,
    input  wire             presetn,

    
    input  wire             transfer,
    input  wire             rw, 
    input  wire [ADDR-1:0]  addr_in,
    input  wire [DATA-1:0]  data_in,
    output wire [DATA-1:0]  prdata
);

  
    wire [ADDR-1:0] paddr;
    wire            pwrite;
    wire [DATA-1:0] pwdata;
    wire            psel;
    wire            penable;
    wire            pready;

    // Master
    Master #(.DATA(DATA), .ADDR(ADDR)) master_inst (
        .pclk   (pclk),
        .presetn(presetn),
        .pready (pready),
        .prdata (prdata),

      .transfer(transfer),
        .rw     (rw),
        .addr_in(addr_in),
        .data_in(data_in),

        .paddr  (paddr),
        .pwrite (pwrite),
        .pwdata (pwdata),
        .psel   (psel),
        .penable(penable)
    );

    // Slave
    Slave #(.DATA(DATA), .ADDR(ADDR)) slave_inst (
        .pclk   (pclk),
        .presetn(presetn),
        .paddr  (paddr),
        .pwrite (pwrite),
        .pwdata (pwdata),
        .psel   (psel),
        .penable(penable),

        .prdata (prdata),
        .pready (pready)
    );
endmodule
