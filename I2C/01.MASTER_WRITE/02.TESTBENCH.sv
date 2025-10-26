// Code your testbench here
// or browse Examples
 module i2c_master_tb;
  reg clk;
  reg reset;
  reg [6:0]addr;
  reg [7:0]data;
  reg go;
  wire sda;
  wire scl;
  
  i2c_master dut (.clk(clk),
                  .reset(reset),
                  .addr(addr),
                  .data(data),
                  .go(go),
                  .sda(sda),
                  .scl(scl));
  
  
 initial begin
   $dumpfile("dump.vcd");
   $dumpvars();
   $display("clk\treset\taddr\tdata\tgo\tsda\tscl\t");
   $monitor("%b\t%b\t\t%d\t\t%d\t\t%0b\t%b\t%b\t",clk,reset,addr,data,go,sda,scl);
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
    data = 8'h55;        


    #20;
    reset = 0;

   

    // Wait for the transfer to complete
    #3000;

    $display("I2C Write Transaction Completed!");
  #1; $finish;
  end

endmodule
