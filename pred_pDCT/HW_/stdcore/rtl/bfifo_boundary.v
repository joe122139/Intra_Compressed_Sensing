`timescale 1ns/1ps

module bfifo_boundary(

	//pblk,

	pic_width_in_luma_samples,
	pic_height_in_luma_samples,
	
	x1,
	y1,
	
	//ubSize,	//unified block size, acceptable sizes are 4, 8, 16, 32, 64
	//unit,	//unit block size, acceptable sizes are 4, 8, 16, 32
	
	add_pblk
	
);

parameter			DW = 8;
parameter			ubSize = 64;
parameter			unit = 4;
//input	[DW-1:0]	pblk;

input	[12:0]		pic_width_in_luma_samples;
input	[12:0]		pic_height_in_luma_samples;
input	[12:0]		x1, y1;
//input	[6:0]		ubSize;
//input	[5:0]		unit;

output	reg	[DW-1:0]	add_pblk;

//calculate the marginal size -> start
reg	[5:0]	y_mar_size_, x_mar_size_;
always @ (*) begin
	if(pic_width_in_luma_samples[2]) 		x_mar_size_ = 4;
	else if(pic_width_in_luma_samples[3])	x_mar_size_ = 8;
	else if(pic_width_in_luma_samples[4])	x_mar_size_ = 16;
	else if(pic_width_in_luma_samples[5])	x_mar_size_ = 32;
	else 									x_mar_size_ = 0;
end

always @ (*) begin
	if(pic_height_in_luma_samples[2]) 		y_mar_size_ = 4;
	else if(pic_height_in_luma_samples[3])	y_mar_size_ = 8;
	else if(pic_height_in_luma_samples[4])	y_mar_size_ = 16;
	else if(pic_height_in_luma_samples[5])	y_mar_size_ = 32;
	else 									y_mar_size_ = 0;
end

wire [5:0]	y_mar_size, x_mar_size;
assign x_mar_size = (x_mar_size_ >= ubSize) ? 0 : x_mar_size_;
assign y_mar_size = (y_mar_size_ >= ubSize) ? 0 : y_mar_size_;
//calculate the marginal size -> end

//get the flag for fake pblk -> start

wire	XisBound, YisBound, XYareBound;
assign XisBound		= ((x1==pic_width_in_luma_samples)&&(y1<pic_height_in_luma_samples));
assign YisBound		= ((y1==pic_height_in_luma_samples)&&(x1<pic_width_in_luma_samples));
assign XYareBound	= ((y1==pic_height_in_luma_samples)&&(x1==pic_width_in_luma_samples));

reg	x_addp_flag, y_addp_flag;
always @ (*) begin
	if(XisBound) begin: XisBoundary
		
		begin: x_addp_flag_xxx
			x_addp_flag = (x_mar_size!=0) ? 1 : 0;
		end
		
		begin: y_addp_flag_xxx
			case(x_mar_size)
				6'd4:	y_addp_flag = (y1[1:0]==0) ? 1 : 0;
				6'd8:	y_addp_flag = (y1[2:0]==0) ? 1 : 0;
				6'd16:	y_addp_flag = (y1[3:0]==0) ? 1 : 0;
				6'd32:	y_addp_flag = (y1[4:0]==0) ? 1 : 0;
				default:y_addp_flag = 0;
			endcase
		end
	end
	
	else if(YisBound) begin: YisBoundary
		
		begin: x_addp_flag_xxx
			case(y_mar_size)
				6'd4:	x_addp_flag = (x1[1:0]==0) ? 1 : 0;
				6'd8:	x_addp_flag = (x1[2:0]==0) ? 1 : 0;
				6'd16:	x_addp_flag = (x1[3:0]==0) ? 1 : 0;
				6'd32:	x_addp_flag = (x1[4:0]==0) ? 1 : 0;
				default:x_addp_flag = 0;
			endcase
		end
		
		begin: y_addp_flag_xxx
			y_addp_flag = (y_mar_size!=0) ? 1 : 0;
		end
	end
	
	else if(XYareBound) begin: XandYareBoundary
		
		begin: XandY_addp_flag_xxx
			if((x_mar_size!=0)||(y_mar_size!=0)) begin
				x_addp_flag = 1; y_addp_flag = 1;
			end
			else begin
				x_addp_flag = 0; y_addp_flag = 0;
			end
		end

	end
	
	else begin
		x_addp_flag = 0; y_addp_flag = 0;
	end
end

wire	addp_flag;
assign addp_flag = x_addp_flag && y_addp_flag;

//get the flag for fake pblk -> end point

//get the fake pblk -> start point

reg	[5:0]	x_comp, y_comp;
always @ (*) begin
	if(x_mar_size!=0) begin
		case(ubSize)
			7'd4:	begin x_comp = 4 - pic_width_in_luma_samples[1:0]; end
			7'd8:	begin x_comp = 8 - pic_width_in_luma_samples[2:0]; end
			7'd16:	begin x_comp = 16 - pic_width_in_luma_samples[3:0]; end
			7'd32:	begin x_comp = 32 - pic_width_in_luma_samples[4:0]; end
			7'd64:	begin x_comp = 64 - pic_width_in_luma_samples[5:0]; end
			default:begin x_comp = 0; end
		endcase
	end
	else begin
		x_comp = 0;
	end
end

always @ (*) begin
	if(y_mar_size!=0) begin
		case(ubSize)
			7'd4:	begin y_comp = 4 - pic_height_in_luma_samples[1:0]; end
			7'd8:	begin y_comp = 8 - pic_height_in_luma_samples[2:0]; end
			7'd16:	begin y_comp = 16 - pic_height_in_luma_samples[3:0]; end
			7'd32:	begin y_comp = 32 - pic_height_in_luma_samples[4:0]; end
			7'd64:	begin y_comp = 64 - pic_height_in_luma_samples[5:0]; end
			default:begin y_comp = 0; end
		endcase
	end
	else begin
		y_comp = 0;
	end
end

reg	[7:0]	add_pblk_R, add_pblk_B;

always @ (*) begin
	case(x_mar_size)
		6'd4:	add_pblk_R = x_comp[5:2];
		6'd8:	add_pblk_R = x_comp[5:1];
		6'd16:	add_pblk_R = x_comp;
		6'd32:	add_pblk_R = {x_comp,1'b0};
		default:add_pblk_R = 0;
	endcase
end
always @ (*) begin
	case(y_mar_size)
		6'd4:	add_pblk_B = y_comp[5:2];
		6'd8:	add_pblk_B = y_comp[5:1];
		6'd16:	add_pblk_B = y_comp;
		6'd32:	add_pblk_B = {y_comp,1'b0};
		default:add_pblk_B = 0;
	endcase	
end

reg	[7:0]	add_pblk_RB_R, add_pblk_RB_B;
always @ (*) begin
	if((x_mar_size<y_mar_size)&&(x_mar_size!=0)) begin
		case(x_mar_size)
			6'd4:	add_pblk_RB_B = y_comp[5:2];
			6'd8:	add_pblk_RB_B = y_comp[5:1];
			6'd16:	add_pblk_RB_B = y_comp;
			6'd32:	add_pblk_RB_B = {y_comp,1'b0};
			default:add_pblk_RB_B = 0;
		endcase
		add_pblk_RB_R = add_pblk_R;
	end
	else if((x_mar_size>y_mar_size)&&(y_mar_size!=0)) begin
		case(y_mar_size)
			6'd4:	add_pblk_RB_R = x_comp[5:2];
			6'd8:	add_pblk_RB_R = x_comp[5:1];
			6'd16:	add_pblk_RB_R = x_comp;
			6'd32:	add_pblk_RB_R = {x_comp,1'b0};
			default:add_pblk_RB_R = 0;
		endcase
		add_pblk_RB_B = add_pblk_B;
	end
	else begin
		add_pblk_RB_R = add_pblk_R; add_pblk_RB_B = add_pblk_B;
	end
end

reg	[5:0]		add_pblk_RB_b0;
reg	[6:0]		add_pblk_RB_b1;
reg	[7:0]		add_pblk_RB_b2;
reg	[8:0]		add_pblk_RB_b3;
reg	[9:0]		add_pblk_RB_b4;
reg	[10:0]		add_pblk_RB_b5;
reg	[11:0]		x_comp_mul_y_comp;
reg	[7:0]		add_pblk_RB;

always @ (*) begin
	add_pblk_RB_b0 		= x_comp[0] ? y_comp : 0;
	add_pblk_RB_b1 		= x_comp[1] ? {y_comp,1'd0} : 0;
	add_pblk_RB_b2 		= x_comp[2] ? {y_comp,2'd0} : 0;
	add_pblk_RB_b3 		= x_comp[3] ? {y_comp,3'd0} : 0;
	add_pblk_RB_b4 		= x_comp[4] ? {y_comp,4'd0} : 0;
	add_pblk_RB_b5 		= x_comp[5] ? {y_comp,5'd0} : 0;
	x_comp_mul_y_comp   = add_pblk_RB_b0 + add_pblk_RB_b1 + add_pblk_RB_b2 + add_pblk_RB_b3 + add_pblk_RB_b4 + add_pblk_RB_b5;
	add_pblk_RB    		= x_comp_mul_y_comp[11:4];
end

reg	[7:0]	add_pblk_u4;

always @ (*) begin
	if(addp_flag) begin
		if(XisBound) begin
			add_pblk_u4 = add_pblk_R;
		end
		else if(YisBound) begin
			add_pblk_u4 = add_pblk_B;
		end
		else if(XYareBound) begin
			add_pblk_u4 = add_pblk_RB_R + add_pblk_RB_B + add_pblk_RB;
		end
		else begin
			add_pblk_u4 = 0;
		end
	end
	else begin
		add_pblk_u4 = 0;
	end
end

always @ (*) begin
	case(unit)
	6'd4:	add_pblk = add_pblk_u4;
	6'd8:	add_pblk = add_pblk_u4[7:2];
	6'd16:	add_pblk = add_pblk_u4[7:4];
	6'd32:	add_pblk = add_pblk_u4[7:6];
	default:add_pblk = 0;
	endcase
end

//get the fake pblk -> end point

//synopsys translate_off
always @ (*) begin
	if(unit > ubSize) $display("ERROR: unit larger than ubSize at %m @ %t", $time);
end
//synopsys translate_on

endmodule
