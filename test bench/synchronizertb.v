Title: Synchronizer test bench



module router_sync_tb;
reg clk,reset_in,detect_add,write_en_reg,read_en_0,read_en_1,read_en_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
reg [1:0]data_in;
wire [2:0]write_en;
wire soft_rst_0,soft_rst_1,soft_rst_2;
wire fifo_full,valid_out_0,valid_out_1,valid_out_2;
router_sync dut(clk,reset_in,detect_add,write_en_reg,read_en_0,read_en_1,read_en_2,empty_0,empty_1,empty_2,
full_0,full_1,full_2,data_in,write_en,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,valid_out_0,valid_out_1,valid_out_2);

initial
begin
clk=1'b0;
forever 
#5 clk=~clk;
end

task reset;
begin
@(negedge clk)
reset_in=0;
@(negedge clk)
reset_in=1;
end
endtask

task initialize;
begin
	detect_add=1'b0;
	data_in=2'b00;
	write_en_reg=1'b0;
	{empty_0,empty_1,empty_2}=3'b111;
	{full_0,full_1,full_2}=3'b000;
	{read_en_0,read_en_1,read_en_2}=3'b000;
end
endtask

task addr(input [1:0]m);
	begin
		@(negedge clk)
		detect_add=1'b1;
		data_in=m;
		@(negedge clk)
		detect_add=1'b0;
	end
endtask

task write;
	begin
		@(negedge clk)
		write_en_reg=1'b1;
		@(negedge clk)
		write_en_reg=1'b0;
	end
endtask

task stimulus;
	begin
		@(negedge clk)
		{full_0,full_1,full_2}=3'b100;
		@(negedge clk)
		{read_en_0,read_en_1,read_en_2}=3'b000;
		@(negedge clk)
		{empty_0,empty_1,empty_2}=3'b011;
	end
endtask

initial
begin
initialize;
reset;
write;
addr(2'b00);
stimulus;
#500 $finish;
end
endmodule
