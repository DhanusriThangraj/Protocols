module Slave #(parameter DATA = 32, ADDR =32)(
    input wire             pclk,
    input wire             presetn,
    input wire [ADDR-1:0]  paddr,
    input wire             pwrite,
    input wire [DATA-1:0]  pwdata,
    input wire             psel,
    input wire             penable,

    output reg [DATA-1:0]  prdata,
    output reg             pready
);

    reg [DATA-1:0] mem [0:255];

  always @(posedge pclk or negedge presetn) begin
    if(!presetn) begin
        pready <= 0;
        prdata <= 0;
    end else begin
        if(psel && penable) begin
            pready <= 1;
            if(pwrite)
                mem[paddr] <= pwdata;  
            else
                prdata <= mem[paddr]; 
        end else begin
            pready <= 0;
        end
    end
end
endmodule

