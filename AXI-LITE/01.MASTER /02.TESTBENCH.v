// Code your testbench here
// or browse Examples
module axi_master_tb;
  
  reg aclk ; 
  reg areset;
  
  reg wr_go;
  reg rd_go;
  
  reg [31:0]waddr;
  reg [31:0]raddr;
  reg [31:0]w_data;
  
  reg awready;
  reg  wready;
  reg bvalid;
  reg [1:0]bresp;
  reg arready;
  reg  [1:0]rresp;
  reg [31:0]rdata;
  reg rvalid;
  
  wire  [31:0]awaddr;
  wire  awvalid;
  wire  [31:0]wdata;
  wire  [1:0]wstrb;
  wire  wvalid;
  wire   bready;
  wire [31:0] araddr;
  wire  arvalid;
  wire  rready; 

  
  
axi_lite_master dut (
  .aclk      (aclk),
  .areset    (areset),

  .wr_go     (wr_go),
  .rd_go     (rd_go),

  .waddr     (waddr),
  .raddr     (raddr),
  .w_data    (w_data),

  .awready   (awready),
  .wready    (wready),
  .bvalid    (bvalid),
  .bresp     (bresp),
  .arready   (arready),
  .rvalid    (rvalid),
  .rdata     (rdata),
  .rresp     (rresp),

  .awaddr    (awaddr),
  .awvalid   (awvalid),
  .wdata     (wdata),
  .wstrb     (wstrb),
  .wvalid    (wvalid),
  .bready    (bready),
  .araddr    (araddr),
  .arvalid   (arvalid),
  .rready    (rready)
  
  
);

    initial begin
      aclk=0;
    forever #5 aclk=~aclk;
  end
  
  initial begin
    areset  = 1;
    wr_go   = 0;
    rd_go   = 0;

    awready = 0;
    wready  = 0;
    bvalid  = 0;
    bresp   = 2'b00;

    arready = 0;
    rvalid  = 0;
    rdata   = 32'h0;
    rresp   = 2'b00;

    #40;
    areset = 0;  
     awready = 0;
     wready = 0;
     bvalid = 0;
    
    
    wr_go=0;    rd_go=0;

    
    
    
   @(posedge aclk);
    waddr  = 32'hAABBAABB;
    w_data = 32'hDADADADA;

    wr_go = 1;
    @(posedge aclk);
    wr_go = 0;
  
    awready = 1;

    wready = 1;


    bvalid = 1;  
    
    #100
    
    
  @(posedge aclk);
    raddr  = 32'hAABBAAbb;
    rdata  = 32'hDADADADA;
    
    rd_go = 1;
    @(posedge aclk);
    rd_go = 0;
  
    arready = 1;

    rvalid = 1;

  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #2000 $finish;
  end
  
  
endmodule
