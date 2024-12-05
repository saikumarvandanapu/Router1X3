Title: Router Top Module
Author: Saikumar


module router_top(
input clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,
input [7:0]data_in,
output valid_out_0,valid_out_1,valid_out_2,error,busy,
output [7:0]data_out_0,data_out_1,data_out_2
);
wire w,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
wire [2:0]full;
wire [2:0]write_enb;
wire [7:0]data;

//fsm
router_fsm	fsm1(.clk(clk) ,.resetn(resetn) ,.data_in(data_in[1:0]) ,.pkt_valid(pkt_valid) ,.parity_done(w1) ,.soft_reset_0(w2) ,.soft_reset_1(w3) ,.soft_reset_2(w4)
,.fifo_full(w5) ,.low_pkt_valid(w6) ,.fifo_empty_0(w7) ,.fifo_empty_1(w8) ,.fifo_empty_2(w9) ,.detect_add(w10) ,.ld_state(w11) ,.laf_state(w12) ,.full_state(w13)
,.write_enb_reg(w) ,.rst_int_reg(w14) ,.lfd_state(w15) ,.busy(busy));

//synchronizer
router_sync	sync1(.clk(clk) ,.reset_in(resetn) ,.detect_add(w10) ,.write_en_reg(w) ,.read_en_0(read_enb_0) ,.read_en_1(read_enb_1) ,.read_en_2(read_enb_2)
 ,.empty_0(w7) ,.empty_1(w8) ,.empty_2(w9) ,.full_0(full[0]) ,.full_1(full[1]) ,.full_2(full[2]) ,.data_in(data_in[1:0]) ,.write_en(write_enb),
 .soft_rst_0(w2) ,.soft_rst_1(w3) ,.soft_rst_2(w4) ,.fifo_full(w5) ,.valid_out_0(valid_out_0) ,.valid_out_1(valid_out_1) ,.valid_out_2(valid_out_2));

//register
 router_reg	register(.clk(clk) ,.resetn(resetn) ,.pkt_valid(pkt_valid) ,.data_in(data_in) ,.fifo_full(w5) ,.rst_in_reg(w14) ,
 .detect_add(w10) ,.ld_state(w11) ,.laf_state(w12) ,.full_state(w13) ,.lfd_state(w15) ,.parity_done(w1) ,.low_pkt_valid(w6) ,.err(error) ,.d_out(data));
 
 //fifo_1
 router_fifo	fifo1(.clk(clk) ,.resetn(resetn) ,.soft_reset(w2) ,.write_enb(write_enb[0]) ,.read_enb(read_enb_0) ,.lfd_state(w15) ,.data_in(data) ,.data_out(data_out_0) ,
 .full(full[0]) ,.empty(w7));
 
 //fifo_2
 router_fifo	fifo2(.clk(clk) ,.resetn(resetn) ,.soft_reset(w3) ,.write_enb(write_enb[1]) ,.read_enb(read_enb_1) ,.lfd_state(w15) ,.data_in(data) ,.data_out(data_out_1) ,
 .full(full[1]) ,.empty(w8));
 
 //fifo_3
 router_fifo	fifo3(.clk(clk) ,.resetn(resetn) ,.soft_reset(w4) ,.write_enb(write_enb[2]) ,.read_enb(read_enb_2) ,.lfd_state(w15) ,.data_in(data) ,.data_out(data_out_2) ,
 .full(full[2]) ,.empty(w9));
 
 endmodule

						
				
