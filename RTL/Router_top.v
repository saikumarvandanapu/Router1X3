Title: Router Top Module
Author: Saikumar


module router_sync(clk,reset_in,detect_add,write_en_reg,read_en_0,read_en_1,read_en_2,empty_0,empty_1,empty_2,
full_0,full_1,full_2,data_in,write_en,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,valid_out_0,valid_out_1,valid_out_2);
input clk,reset_in,detect_add,write_en_reg,read_en_0,read_en_1,read_en_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0]data_in;
output reg [2:0]write_en;
output reg soft_rst_0,soft_rst_1,soft_rst_2;
output reg fifo_full;
output valid_out_0,valid_out_1,valid_out_2;

reg [1:0]temp_reg; //to store the data and based on it generates the write_en;
reg [4:0]timer_0,timer_1,timer_2; //for 30 clk pulses of each fifo;

//capturing address if detect_add is 1
always@(posedge clk)
	begin
		if(!reset_in)
			temp_reg<=2'b00;
		else if(detect_add)
				temp_reg<=data_in;
	end

//write enable logic
always@(*)
	begin
		if(write_en_reg)
			begin
				case(temp_reg)
				2'b00:write_en=3'b001;
				2'b01:write_en=3'b010;
				2'b10:write_en=3'b100;
				default:write_en=3'b000;
				endcase
			end
		else
			write_en=3'b000;
	end
	
//fifo_full logic
always@(*)
	begin
		case(temp_reg)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
		2'b10:fifo_full=full_2;
		default:fifo_full=1'b0;
		endcase
	end

//soft reset_0 logic
always@(posedge clk)
	begin
		soft_rst_0<=1'b0;
		timer_0<=5'd0;
		if(!reset_in)
			begin
				soft_rst_0<=1'b0;
				timer_0<=5'd0;
			end
		else if(valid_out_0)
				begin
					if(!read_en_0)
						begin
							if(timer_0==5'd29)
							begin
								soft_rst_0<=1'b1;
								timer_0<=5'd0;
							end
								else
									begin
										soft_rst_0<=1'b0;
										timer_0<=timer_0+5'd1;
									end
						end
				end
	end
	
//soft reset_1 logic
always@(posedge clk)
	begin
		soft_rst_1<=1'b0;
		timer_1<=5'd0;
		if(!reset_in)
			begin
				soft_rst_1<=1'b0;
				timer_1<=5'd0;
			end
		else if(valid_out_1)
				begin
					if(!read_en_1)
						begin
							if(timer_1==5'd29)
							begin
								soft_rst_1<=1'b1;
								timer_1<=5'd0;
							end
								else
									begin
										soft_rst_1<=1'b0;
										timer_1<=timer_1+5'd1;
									end
						end
				end
	end
	
//soft reset_2 logic
always@(posedge clk)
	begin
		soft_rst_2<=1'b0;
		timer_2<=5'd0;
		if(!reset_in)
			begin
				soft_rst_2<=1'b0;
				timer_2<=5'd0;
			end
		else if(valid_out_2)
				begin
					if(!read_en_2)
						begin
							if(timer_2==5'd29)
							begin
								soft_rst_2<=1'b1;
								timer_2<=5'd0;
							end
								else
									begin
										soft_rst_2<=1'b0;
										timer_2<=timer_2+5'd1;
									end
						end
				end
	end

//valid_out value is 1 only if empty is 0
assign valid_out_0=~empty_0;
assign valid_out_1=~empty_1;
assign valid_out_2=~empty_2;

endmodule						
				
