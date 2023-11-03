module memory(clk_i,rst_i,valid_i,wr_rd_i,addr_i,wdata_i,ready_o,rdata_o);
parameter WIDTH=16;
parameter DEPTH=64;
parameter ADDR_SIZE=$clog2(DEPTH);
input clk_i,rst_i,wr_rd_i,valid_i;
input [ADDR_SIZE-1:0]addr_i;
input [WIDTH-1:0]wdata_i;
output reg ready_o;
output reg [WIDTH-1:0]rdata_o;
reg [WIDTH-1:0]mem[DEPTH-1:0];integer i;
always@(posedge clk_i)begin
	if(rst_i)begin
		rdata_o=0;
		ready_o=0;
		for(i=0;i<DEPTH;i=i+1)begin
			mem[i]=0;
		end
	end
	else begin
		if(valid_i)begin
			ready_o=1;
			if(wr_rd_i)begin
				mem[addr_i]=wdata_i;
			end
			else begin
				rdata_o=mem[addr_i];
			end
		end
		else ready_o=0;
	end
end
endmodule
