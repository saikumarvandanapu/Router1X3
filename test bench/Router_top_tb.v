Title:Router_top_module test bench





module router_top_module_tb;
reg clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
reg [7:0]data_in;
wire [7:0]data_out_0,data_out_1,data_out_2;
wire valid_out_0,valid_out_1,valid_out_2;
wire error,busy;
integer i;

router_top	dut(clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,valid_out_0,valid_out_1,valid_out_2,error,busy,data_out_0,data_out_1,data_out_2);

initial
begin
clk=1'b0;
forever
#5 clk=~clk;
end

task reset;
	begin
		@(negedge clk)
		resetn=0;
		@(negedge clk)
		resetn=1;
	end
endtask

task initialize;
	begin
		{resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in}=0;
	end
endtask

task pkt_gen(input [5:0]x);
	reg [7:0]payload_data;
	reg [7:0]parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
begin	
	wait(!busy);
	@(negedge clk)
	payload_len=x;
	addr=2'b00;
	header={payload_len,addr};
	data_in=header;
	pkt_valid=1;
	parity=0;
	parity=parity^data_in;
	for(i=0;i<payload_len;i=i+1)
	begin
		wait(~busy);
		@(negedge clk)
		payload_data={$random}%256;
		data_in=payload_data;
		parity=parity^data_in;
	end
		wait(!busy);
		@(negedge clk)
		pkt_valid=0;
		data_in=parity;
end
endtask

initial
begin
initialize;
reset;
fork
	pkt_gen(6'd6);
	begin
		wait(valid_out_0);
		@(negedge clk)
		read_enb_0=1'b1;
	end
join
$finish;
end

endmodule
