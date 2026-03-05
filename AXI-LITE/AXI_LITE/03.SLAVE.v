module axi_lite_slave (
  input              aclk,
  input              areset,

  input  [31:0]      awaddr,
  input              awvalid,
  output reg         awready,

  input  [31:0]      wdata,
  input  [3:0]       wstrb,
  input              wvalid,
  output reg         wready,

  output reg         bvalid,
  input              bready,
  output reg [1:0]   bresp,

  input  [31:0]      araddr,
  input              arvalid,
  output reg         arready,

  output reg [31:0]  rdata,
  output reg         rvalid,
  input              rready,
  output reg [1:0]   rresp,
  output reg aw_done, w_done
  
);

  reg [31:0] ram [0:31];
  reg addr_locked;


  
  reg [31:0] awaddr_reg;
  reg [31:0] araddr_reg;



  always @(posedge aclk or posedge areset) begin
    if (areset) begin
      awready <= 0;
      wready  <= 0;
      bvalid  <= 0;
      bresp   <= 2'b00;

      arready <= 0;
      rvalid  <= 0;
      rresp   <= 2'b00;
      rdata   <= 0;

      aw_done <= 0;
      w_done  <= 0;
addr_locked <= 0;
    
    end
    else begin
      /* ---------------- WRITE ADDRESS ---------------- */
   if (awvalid && !awready && !addr_locked) begin
       awready     <= 1;
       awaddr_reg  <= awaddr;
       addr_locked <= 1;   
       aw_done     <= 1;
end
else begin
  awready <= 0;
end

      /* ---------------- WRITE DATA ---------------- */
    if (wvalid && !wready && addr_locked) begin
       wready <= 1;
  if (wstrb[0]) ram[awaddr_reg[6:2]][7:0]   <= wdata[7:0];
  if (wstrb[1]) ram[awaddr_reg[6:2]][15:8]  <= wdata[15:8];
  if (wstrb[2]) ram[awaddr_reg[6:2]][23:16] <= wdata[23:16];
  if (wstrb[3]) ram[awaddr_reg[6:2]][31:24] <= wdata[31:24];

  w_done <= 1;
end
else begin
  wready <= 0;
end


      /* ---------------- WRITE RESPONSE ---------------- */
      if (aw_done && w_done && !bvalid) begin
        bvalid <= 1;
        bresp  <= 2'b00; // OKAY
      end

      if (bvalid && bready) begin
        bvalid  <= 0;
        aw_done <= 0;
        w_done  <= 0;
       addr_locked <= 0;   
      end


      /* ---------------- READ ADDRESS ---------------- */
      if (arvalid && !arready) begin
        arready    <= 1;
        araddr_reg <= araddr;
      end
      else begin
        arready <= 0;
      end

      /* ---------------- READ DATA ---------------- */
      if (arready && arvalid && !rvalid) begin
        rdata  <= ram[araddr_reg[6:2]];
        rvalid <= 1;
        rresp  <= 2'b00; // OKAY
      end

      if (rvalid && rready) begin
        rvalid <= 0;
      end
    end
  end

endmodule
