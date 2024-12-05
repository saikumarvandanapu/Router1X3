Title: fsm test bench










module	router_fsm_tb;
reg clk,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg [1:0]data_in;
wire busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;

router_fsm  dut(clk,resetn,data_in,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,
write_enb_reg,rst_int_reg,lfd_state,busy);

initial
begin
clk=1'b0;
forever
#5 clk=~clk;
end

task reset();
	begin
		@(negedge clk)
		resetn=1'b0;
		@(negedge clk)
		resetn=1'b1;
	end
endtask

task t1();
	begin
		@(negedge clk)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clk)
		@(negedge clk)
		fifo_full=1'b0;
		pkt_valid=1'b0;
		@(negedge clk)
		@(negedge clk)
		fifo_full=1'b0;
	end
endtask

task t2();
	begin
		@(negedge clk)
		pkt_valid=1'b1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clk)
		@(negedge clk)
		fifo_full=1'b1;
		@(negedge clk)
		fifo_full=1'b0;
		@(negedge clk)
		parity_done=0;
		low_pkt_valid=1;
		@(negedge clk)
		@(negedge clk)
		fifo_full=0;
	end
endtask
task t3();
	begin
		@(negedge clk)
		pkt_valid=1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clk)
		@(negedge clk)
		fifo_full=1;
		@(negedge clk)
		fifo_full=0;
		@(negedge clk)
		parity_done=0;
		low_pkt_valid=0;
		@(negedge clk)
		fifo_full=0;
		pkt_valid=0;
		@(negedge clk)
		@(negedge clk)
		fifo_full=0;
	end
endtask

task t4();
	begin
		@(negedge clk)
		pkt_valid=1;
		data_in=2'b01;
		fifo_empty_1=1'b1;
		@(negedge clk)
		@(negedge clk)
		fifo_full=0;
		pkt_valid=0;
		@(negedge clk)
		@(negedge clk)
		fifo_full=1;
		@(negedge clk)
		fifo_full=0;
		@(negedge clk)
		parity_done=1;
	end
endtask

initial
begin
reset;
t1;
//t2;
//t3;
//t4;
$finish;
end
endmodule
		
