`include "master.v"
`include "slave.v"

module axi_lite_top (
    input  wire aclk,
    input  wire areset,

    input  wire        wr_go,
    input  wire        rd_go,
    input  wire [31:0] waddr,
    input  wire [31:0] raddr,
    input  wire [31:0] w_data
);

    /* ---------------- AXI WIRES ---------------- */
    wire [31:0] awaddr;
    wire        awvalid;
    wire        awready;

    wire [31:0] wdata;
    wire [3:0]  wstrb;
    wire        wvalid;
    wire        wready;

    wire        bvalid;
    wire        bready;
    wire [1:0]  bresp;

    wire [31:0] araddr;
    wire        arvalid;
    wire        arready;

    wire [31:0] rdata;
    wire        rvalid;
    wire        rready;
    wire [1:0]  rresp;
  
  wire aw_done, w_done;
  
  

    /* ---------------- MASTER ---------------- */
    axi_lite_master u_master (
        .aclk    (aclk),
        .areset  (areset),

        .wr_go   (wr_go),
        .rd_go   (rd_go),
        .waddr   (waddr),
        .raddr   (raddr),
        .w_data  (w_data),

        .awaddr  (awaddr),
        .awvalid (awvalid),
        .awready (awready),

        .wdata   (wdata),
        .wstrb   (wstrb),
        .wvalid  (wvalid),
        .wready  (wready),

        .bvalid  (bvalid),
        .bready  (bready),
        .bresp   (bresp),

        .araddr  (araddr),
        .arvalid (arvalid),
        .arready (arready),

        .rdata   (rdata),
        .rvalid  (rvalid),
        .rready  (rready),
        .rresp   (rresp),
        .aw_done(aw_done),
        .w_done(w_done)
    );

    /* ---------------- SLAVE ---------------- */
    axi_lite_slave u_slave (
        .aclk    (aclk),
        .areset  (areset),

        .awaddr  (awaddr),
        .awvalid (awvalid),
        .awready (awready),

        .wdata   (wdata),
        .wstrb   (wstrb),
        .wvalid  (wvalid),
        .wready  (wready),

        .bvalid  (bvalid),
        .bready  (bready),
        .bresp   (bresp),

        .araddr  (araddr),
        .arvalid (arvalid),
        .arready (arready),

        .rdata   (rdata),
        .rvalid  (rvalid),
        .rready  (rready),
      .rresp   (rresp),
       .aw_done(aw_done),
      .w_done(w_done)
    );

endmodule
