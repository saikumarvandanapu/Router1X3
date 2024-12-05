Title: Register test bench









module router_regtb;
reg clk,resetn,pkt_valid,fifo_full,rst_in_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0]data_in;
wire parity_done,low_pkt_valid,err;
wire [7:0]d_out;
integer i;

router_reg dut(clk,resetn,pkt_valid,data_in,fifo_full,rst_in_reg,detect_add,
ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,d_out);

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

task packet_generation;
reg [7:0] payload_data, parity, header;
reg [5:0] payload_len;
reg [1:0] addr;
begin
	@(negedge clk)
	payload_len=6'd5;
	addr=2'b10;
	pkt_valid=1;
	detect_add=1;
	header={payload_len,addr};
	data_in=header;
	parity=8'h00^header;
	@(negedge clk)
	detect_add=0;
	lfd_state=1;
	full_state=0;
	fifo_full=0;
	laf_state=0;
	for(i=0; i<payload_len; i=i+1)
		begin
			@(negedge clk)
				lfd_state=0;
				ld_state=1;
				//laf_state=1;
				payload_data={$random}%256;
				data_in=payload_data;
				parity=parity^payload_data;
		end
	@(negedge clk)
	pkt_valid=0;
	data_in=parity;
	@(negedge clk)
	ld_state=0;
end
endtask

task initialize;
begin
{pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_in_reg}=0;
end
endtask
initial
	begin
		initialize;
		reset;
		packet_generation;
		$finish;
	end
endmodule
