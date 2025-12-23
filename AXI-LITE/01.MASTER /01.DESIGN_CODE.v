module axi_lite_master(
  input aclk,
  input areset,
  
  input wr_go,
  input rd_go,

  input [31:0] waddr,
  input [31:0] raddr,
  input [31:0] w_data,
  

  output reg [31:0] awaddr,
  output reg        awvalid,
  input             awready,
  
  output reg [31:0] wdata,
  output reg [1:0]  wstrb,
  output reg        wvalid,
  input             wready,
  
  input             bvalid,
  output reg        bready,
  input [1:0]       bresp,
  
  output reg [31:0] araddr,
  output reg        arvalid,
  input             arready,
  
  input [31:0]      rdata,
  input             rvalid,
  output reg        rready,
  input [1:0]       rresp
);

  
  parameter W_IDLE       = 3'b000,
            W_SEND       = 3'b001,
            W_RESP       = 3'b010;

  parameter R_IDLE       = 3'b011,
            R_ADDR       = 3'b100,
            R_DATA       = 3'b101;

  reg [2:0] wstate, wnext_state;
  reg [2:0] rstate, rnext_state;

  reg aw_done, w_done;
  reg [31:0] rdata_reg;

  // CONSTANTS
  always @(*) begin
    wstrb = 4'b1111; // full write
  end

  // WRITE STATE REGISTER
  always @(posedge aclk or posedge areset) begin
    if (areset)
      wstate <= W_IDLE;
    else
      wstate <= wnext_state;
  end

  // WRITE NEXT STATE LOGIC 
  always @(*) begin
    case (wstate)
      W_IDLE :wnext_state = wr_go ? W_SEND : W_IDLE;

      W_SEND :wnext_state = (aw_done && w_done) ? W_RESP : W_SEND;

      W_RESP :wnext_state = (bvalid && bready) ? W_IDLE : W_RESP;

      default :
        wnext_state = W_IDLE;
    endcase
  end

  // WRITE OUTPUT / DATAPATH
  always @(posedge aclk or posedge areset) begin
    if (areset) begin
      awvalid <= 0;
      wvalid  <= 0;
      bready  <= 0;
      aw_done <= 0;
      w_done  <= 0;
      awaddr  <= 0;
      wdata   <= 0;
    end else begin
      case (wstate)

        W_IDLE: begin
          aw_done <= 0;
          w_done  <= 0;
          bready  <= 0;

          if (wr_go) begin
            awaddr  <= waddr;
            wdata   <= w_data;
            awvalid <= 1;
            wvalid  <= 1;
          end
        end

        W_SEND: begin
          if (awvalid && awready) begin
            awvalid <= 0;
            aw_done <= 1;
          end

          if (wvalid && wready) begin
            wvalid <= 0;
            w_done <= 1;
          end

          if (aw_done && w_done)
            bready <= 1;
        end

        W_RESP: begin
          if (bvalid && bready)
            bready <= 0;
        end

      endcase
    end
  end

  // READ STATE REGISTER
  always @(posedge aclk or posedge areset) begin
    if (areset)
      rstate <= R_IDLE;
    else
      rstate <= rnext_state;
  end

  // READ NEXT STATE LOGIC 
  always @(*) begin
    case (rstate)
      R_IDLE :
        rnext_state = rd_go ? R_ADDR : R_IDLE;

      R_ADDR :
        rnext_state = (arvalid && arready) ? R_DATA : R_ADDR;

      R_DATA :
        rnext_state = (rvalid && rready) ? R_IDLE : R_DATA;

      default :
        rnext_state = R_IDLE;
    endcase
  end

  // READ OUTPUT / DATAPATH
  always @(posedge aclk or posedge areset) begin
    if (areset) begin
      arvalid    <= 0;
      rready     <= 0;
      araddr     <= 0;
      rdata_reg  <= 0;
    end else begin
      case (rstate)

        R_IDLE: begin
          if (rd_go) begin
            araddr  <= raddr;
            arvalid <= 1;
          end
        end

        R_ADDR: begin
          if (arvalid && arready) begin
            arvalid <= 0;
            rready  <= 1;
          end
        end

        R_DATA: begin
          if (rvalid && rready) begin
            rdata_reg <= rdata;
            rready    <= 0;
          end
        end

      endcase
    end
  end

endmodule
