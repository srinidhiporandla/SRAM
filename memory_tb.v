`include "memory_ex.v"
module tb();
parameter WIDTH=16;
parameter DEPTH=64;
parameter ADDR_SIZE=$clog2(DEPTH);
reg clk_i,rst_i,wr_rd_i,valid_i;
reg [ADDR_SIZE-1:0]addr_i;
reg [WIDTH-1:0]wdata_i;
wire ready_o;
wire [WIDTH-1:0]rdata_o;
integer i,num_loc;
memory dut(clk_i,rst_i,valid_i,wr_rd_i,addr_i,wdata_i,ready_o,rdata_o);
initial begin
	clk_i=0;
	forever #5 clk_i=~clk_i;
end
initial begin
	reset_mem();
	num_loc=$urandom_range(3,15);
	write_mem(0,num_loc);
	num_loc=$urandom_range(0,10);
	read_mem(10,num_loc);
	#100;
	$finish;

end
task reset_mem();
begin
	rst_i=1;
	valid_i=0;
	addr_i=0;
	wr_rd_i=0;
	wdata_i=0;
	@(posedge clk_i);
	rst_i=0;

end
endtask
task write_mem(input [ADDR_SIZE-1:0]start_loc,input [ADDR_SIZE:0]num_loc);
begin
	for(i=start_loc;i<start_loc+num_loc;i=i+1)begin	
			@(posedge clk_i);
			addr_i=i;
			wdata_i=$random;
			wr_rd_i=1;
			valid_i=1;
			wait(ready_o==1);
	end
		@(posedge clk_i);
		valid_i=0;

end
endtask
task read_mem(input [ADDR_SIZE-1:0]start_loc,input [ADDR_SIZE:0]num_loc);
begin
	for(i=start_loc;i<start_loc+num_loc;i=i+1)begin
			@(posedge clk_i);	
			addr_i=i;
			wr_rd_i=0;
			valid_i=1;
			wait(ready_o==1);
	end
		@(posedge clk_i);
		valid_i=0;

end
endtask

endmodule

