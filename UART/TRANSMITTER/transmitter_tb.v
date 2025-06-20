module transmitter_tb;
 reg clk;
 reg reset;
 reg [7:0]data_in;
 wire intx;
 wire [10:0]out_tx;

 reg [1:0]baud_sel;
 baud_generator bg (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .intx(intx),
        .inrx()
    );
 transmitter uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .intx(intx),
        .out_tx(out_tx)
    );
    
    initial begin
   clk=0;
   forever #5 clk=~clk;
end
initial begin
	$dumpfile("transmitter.vcd");
	$dumpvars(); end

initial begin
$display("Time\tclk\trset\tdata\tintx\tout_tx");
$monitor("%0t\t%b\t%b\t%b\t%b\t%b",$time,clk,reset,data_in,intx,out_tx);

reset = 1; baud_sel = 2'b10; // 460800 baud
        #20 reset = 0;

        data_in = 8'b10101010; 
	#200000 $finish;
end 
endmodule

