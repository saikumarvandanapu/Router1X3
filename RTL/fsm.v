Title: FSM
Author: saikumar



module router_fsm(clk,resetn,data_in,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,
write_enb_reg,rst_int_reg,lfd_state,busy);
input clk,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
fifo_empty_0,fifo_empty_1,fifo_empty_2;
input [1:0]data_in;
output  busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;

reg [1:0]addr;
parameter Decode_address=3'b000,
		  Load_first_data=3'b001,
		  Load_data=3'b010,
		  Fifo_full_state=3'b011,
		  Load_after_full=3'b100,
		  Load_parity=3'b101,
		  Check_parity_error=3'b110,
		  Wait_till_empty=3'b111;
		  
reg [2:0]present_state,next_state;


//present_state logic
always@(posedge clk)
	begin
		if(!resetn)
			present_state<=Decode_address;
		else
		begin
			if((soft_reset_0&&(data_in==2'b00))||(soft_reset_1&&(data_in==2'b01))||(soft_reset_2&&(data_in==2'b10)))
				present_state<=Decode_address;
			else
				present_state<=next_state;
		end
	end
	
//internal variable addr logic
always@(posedge clk)
	begin
		if(!resetn)
			addr<=2'b00;
		else
			begin
			if((soft_reset_0&&(data_in==2'b00))||
			   (soft_reset_1&&(data_in==2'b01))||
			   (soft_reset_2&&(data_in==2'b10)))
			     addr<=2'b00;
			else if(detect_add)
					addr<=data_in;
			end
    end

	
//next_state logic
always@(*)
	begin
		next_state=present_state;
			begin
				case(present_state)
					Decode_address : begin
									if(((pkt_valid)&&(data_in==2'b00)&&fifo_empty_0)||
										((pkt_valid)&&(data_in==2'b01)&&fifo_empty_1)||
										((pkt_valid)&&(data_in==2'b10)&&fifo_empty_2))
										next_state=Load_first_data;
									else if(((pkt_valid)&&(data_in==2'b00)&&(~fifo_empty_0))||
										((pkt_valid)&&(data_in==2'b01)&&(~fifo_empty_1))||
										((pkt_valid)&&(data_in==2'b10)&&(~fifo_empty_2)))
											next_state=Wait_till_empty;
									else
										next_state=Decode_address;
									end
					Load_first_data:next_state=Load_data;
					Load_data      :begin
									if(fifo_full)
										next_state=Fifo_full_state;
									else if((!fifo_full)&&!pkt_valid)
										next_state=Load_parity;
									else
										next_state=Load_data;
									end
					Fifo_full_state:begin
									if(!fifo_full)
										next_state=Load_after_full;
									else
										next_state=Fifo_full_state;
									end
					Load_after_full:begin
									if((!parity_done)&&(!low_pkt_valid))
										next_state=Load_data;
									else if((!parity_done)&&(low_pkt_valid))
										next_state=Load_parity;
									else if(parity_done)
										next_state=Decode_address;
									end
					Wait_till_empty:begin
									if((fifo_empty_0 && addr==2'b00 )||
									   (fifo_empty_1 && addr==2'b01 )||
										(fifo_empty_2 && addr==2'b10 ))
										 next_state=Load_first_data;
									else
										next_state=Wait_till_empty;
									end
					Load_parity: next_state=Check_parity_error;
					Check_parity_error:begin
										if(!fifo_full)
										  next_state=Decode_address;
										else
										  next_state=Fifo_full_state;
										 end
					default: next_state=Decode_address;
				endcase
			end
	end
	
//output signals
assign detect_add=(present_state==Decode_address)?1'b1:1'b0;
assign lfd_state=(present_state==Load_first_data)?1'b1:1'b0;
assign ld_state=(present_state==Load_data)?1'b1:1'b0;
assign full_state=(present_state==Fifo_full_state)?1'b1:1'b0;
assign laf_state=(present_state==Load_after_full)?1'b1:1'b0;
assign rst_int_reg=(present_state==Check_parity_error)?1'b1:1'b0;
assign write_enb_reg=((present_state==Load_data)||
					(present_state==Load_after_full)||
					(present_state==Load_parity))?1'b1:1'b0;
assign busy=((present_state==Load_first_data)||
			(present_state==Fifo_full_state)||
			(present_state==Load_after_full)||
			(present_state==Load_parity)||
			(present_state==Check_parity_error)||
			(present_state==Wait_till_empty))?1'b1:1'b0;


endmodule
										
