 module i2c_master_tb;
  reg clk;
  reg reset;
  reg [6:0]addr;
  reg [7:0]reg_addr;
  reg [7:0]data;
  reg go;
  wire sda;
  wire scl;
  
  i2c_master dut (.clk(clk),
                  .reset(reset),
                  .addr(addr),
                  .reg_addr(reg_addr),
                  .data(data),
                  .go(go),
                  .sda(sda),
                  .scl(scl));
  
  
 initial begin
   $dumpfile("dump.vcd");
   $dumpvars();
   
 end
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    clk = 0;
    reset = 1;
    go = 1;
    addr = 7'b1010001; 
    reg_addr=8'b11101010;
    data = 8'h55;        


    #20;
    reset = 0;

   

    #3000;

    $display("I2C Write Transaction Completed!");
  #1; $finish;
  end

endmodule
