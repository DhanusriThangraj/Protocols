module Master #(parameter DATA = 32, ADDR = 32)(
    input  wire             pclk,
    input  wire             presetn,
    input  wire             pready,    // from slave
    input  wire [DATA-1:0]  prdata,    // from slave
    
    input  wire             transfer,
    input  wire             rw,        // 1=write, 0=read
    input  wire [ADDR-1:0]  addr_in,
    input  wire [DATA-1:0]  data_in,

 
    output reg  [ADDR-1:0]  paddr,
    output reg              pwrite,
    output reg  [DATA-1:0]  pwdata,
    output reg              psel,
    output reg              penable
);

    parameter IDLE   = 2'b00,
              SETUP  = 2'b01, 
              ACCESS = 2'b10;

    reg [1:0] state, next_state;
  

    always @(*) begin
        case(state)
            IDLE   : next_state = (transfer) ? SETUP : IDLE;
            SETUP  : next_state = ACCESS;
            ACCESS : next_state = (pready&&!transfer)?IDLE:ACCESS;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge pclk or negedge presetn) begin
        if(!presetn)
            state <= IDLE;
        else
            state <= next_state;
    end

  
    always @(*) begin
      
        case(state)
            IDLE  : begin 
                paddr   = 0;
                pwdata  = 0;
                pwrite  = 0;
                psel    = 0;
                penable = 0;    end
            SETUP : begin
                psel    = 1;
                penable = 0;
                paddr   = addr_in;
                pwdata  = data_in;
                pwrite  = rw;
            end
            ACCESS: begin
                psel    = 1;
                penable = 1;
                paddr   = addr_in;
                pwdata  = data_in;
                pwrite  = rw;
            end
        endcase
    end
endmodule
