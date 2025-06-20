module baud_generator(input clk,reset,
input [1:0]baud_sel,
output reg intx,
output reg inrx);
//frequency=150 mhz
reg [31:0]baud_partition_tx = 0;
reg [31:0]baud_partition_rx = 0;
reg [31:0]count_tx=0;
reg [31:0]count_rx=0;


always @(*) begin
 case (baud_sel)
	 2'b00:begin
	  baud_partition_tx=31250;
	  baud_partition_rx=31250;end
          
	  2'b01:begin
		  baud_partition_tx=7813;
		  baud_partition_rx=7813; end

		  2'b10:begin
			  baud_partition_tx=325;
			  baud_partition_rx=325; end

			  2'b11:begin 
 			  baud_partition_tx=162;
			  baud_partition_rx=162;end

endcase
end


always @ (posedge clk or posedge reset) begin

if (reset) begin
 intx<=0;
 count_tx<=0;
end
else if (count_tx == baud_partition_tx) begin
	intx<=1'b1;
	count_tx<=0;
	end
	else begin
		intx<=0;
		count_tx<=count_tx+1'b1;
		end end

always @ (posedge clk or posedge reset) begin

if (reset) begin
        inrx<=0;
       	count_rx<=0;
end
else if(count_rx == baud_partition_tx) begin
                inrx<=1'b1;
	 	count_rx <=0;

	end
	else begin
		inrx<=0;
		count_rx<=count_rx+1'b1;end
	end

	endmodule





 




