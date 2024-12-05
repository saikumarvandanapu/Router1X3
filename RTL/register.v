Title: Register
Author: saikumar






module router_reg(clk,resetn,pkt_valid,data_in,fifo_full,rst_in_reg,detect_add,
ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,d_out);
input clk,resetn,pkt_valid,fifo_full,rst_in_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0]data_in;
output reg parity_done,low_pkt_valid,err;
output reg [7:0]d_out;

reg [7:0]Internal_parity,Packet_parity,Header_byte,fifo_full_state_byte;


//d_out logic
always@(posedge clk)
	begin
		if(!resetn)
			d_out<=8'd0;
		else if(lfd_state)
			d_out<=Header_byte;
		else if(ld_state && ~fifo_full)
			d_out<=data_in;
		else if(laf_state)
			d_out<=fifo_full_state_byte;
		else
			d_out<=d_out;
	end
	
//Header_byte and fifo_full_state_byte
always@(posedge clk)
	begin
		if(!resetn)
			{Header_byte,fifo_full_state_byte}<=16'b0;
		else
			begin
				if(pkt_valid && detect_add)
					Header_byte<=data_in;
				else if(ld_state && fifo_full)
					fifo_full_state_byte<=data_in;
			end
	end
	
//Internal_parity
always@(posedge clk)
	begin
		if(!resetn)
			Internal_parity<=0;
		else if(detect_add)
			Internal_parity<=0;
		else if(lfd_state)
			Internal_parity<=Header_byte;
		else if(ld_state && pkt_valid && !full_state)
			Internal_parity<=Internal_parity^data_in;
		else if(!pkt_valid && rst_in_reg)
			Internal_parity<=0;
	end

//parity_done logic
always@(posedge clk)
	begin
		if(!resetn)
			parity_done<=0;
		else begin
			if(ld_state && !pkt_valid && !fifo_full)
				parity_done<=1'b1;
			else if(laf_state && !parity_done && low_pkt_valid)
				parity_done<=1;
			else
				begin
					if(detect_add)
						parity_done<=0;
				end
			end
	end
	
//low_pkt_valid logic
always@(posedge clk)
	begin
		if(!resetn)
			low_pkt_valid<=0;
		else
			begin
				if(rst_in_reg)
					low_pkt_valid<=0;
				else if(!pkt_valid && ld_state)
					low_pkt_valid<=1'b1;
			end
	end
	
//Packet_parity logic
always@(posedge clk)
	begin
		if(!resetn)
			Packet_parity<=0;
		else if((ld_state && !pkt_valid && !fifo_full)||
				(laf_state && low_pkt_valid && !parity_done))
				Packet_parity<=data_in;
		else if(!pkt_valid && rst_in_reg)
				Packet_parity<=0;
		else
			begin
				if(detect_add)
					Packet_parity<=0;
			end
	end
	
//error logic
always@(posedge clk)
	begin
		if(!resetn)
			err<=0;
		else
			begin
				if(parity_done==1'b1 && (Internal_parity != Packet_parity))
					err<=1'b1;
				else
					err<=0;
			end
	end
	
endmodule
	
	
