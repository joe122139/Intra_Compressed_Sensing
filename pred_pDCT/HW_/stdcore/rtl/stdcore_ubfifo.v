`timescale 1ns/1ps

module stdcore_ubfifo(

	clk,
	arst_n,
	rst_n,
	
	p,
	p_waddr,
	p_we_n,
	p_pblk,
	p_vc,
	
	c,
	c_raddr,
	c_re_n,
	c_pblk,
	c_st,
	
	pic_width_in_luma_samples,
	pic_height_in_luma_samples,
	
	p_x1,	//x1: right pixel position of one block
	p_y1,	//y1: bottom pixel position of one block
	c_x1,
	c_y1
	
	//ubSize,
	//unit
	
);

parameter			DW = 1;
parameter			AW = 1;
parameter			DEPTH = 1;

parameter			RS = 0;

parameter			ubSize = 64;	//unified block size, acceptable sizes are 4, 8, 16, 32, 64
parameter			unit = 4;		//unit block size, acceptable sizes are 4, 8, 16, 32

input				clk;
input				arst_n;
input				rst_n;

input	[DW-1:0]	p;
input	[AW-1:0]	p_waddr;
input				p_we_n;
input	[AW  :0]	p_pblk;
output	reg	[AW  :0]	p_vc;

output	[DW-1:0]	c;
input	[AW-1:0]	c_raddr;
input				c_re_n;
input	[AW  :0]	c_pblk;
output	[AW  :0]	c_st;

input	[12  :0]	pic_width_in_luma_samples;
input	[12  :0]	pic_height_in_luma_samples;

input	[12  :0]	p_x1;
input	[12  :0]	p_y1;
input	[12  :0]	c_x1;
input	[12  :0]	c_y1;

//input	[6   :0]	ubSize;
//input	[5	 :0]	unit;

wire	[AW  :0]	add_p_pblk_;
wire	[AW  :0]	add_c_pblk_;
wire	[AW  :0]	p_upblk;
wire	[AW  :0]	c_upblk;
wire	[AW  :0]	p_vc_pre;

wire	[AW  :0]	add_p_pblk;
wire	[AW  :0]	add_c_pblk;

assign add_p_pblk = (p_pblk!=0) ? (add_p_pblk_>>RS) : 0;
assign add_c_pblk = (c_pblk!=0) ? (add_c_pblk_>>RS) : 0;

//assign p_upblk = !p_we_n ? (p_pblk + add_p_pblk) : 0;
//assign c_upblk = !c_re_n ? (c_pblk + add_c_pblk) : 0;
assign p_upblk = p_pblk + add_p_pblk;
assign c_upblk = c_pblk + add_c_pblk;

wire	[6:0]	max_add_pblk_, max_add_pblk;
assign max_add_pblk_ = 7'd64;
assign max_add_pblk = (max_add_pblk_ >> RS);

always @ (*) begin
	if(p_vc_pre < max_add_pblk)
		p_vc = 0;
	else
		p_vc = p_vc_pre - max_add_pblk;
end

bfifo_boundary	#(AW+1,ubSize,unit)	ins_add_p_pblk
(
	.pic_width_in_luma_samples			(pic_width_in_luma_samples),
	.pic_height_in_luma_samples			(pic_height_in_luma_samples),
	
	.x1									(p_x1),
	.y1									(p_y1),
	//.ubSize							(ubSize),
	//.unit								(unit),
	
	.add_pblk							(add_p_pblk_)
);

bfifo_boundary	#(AW+1,ubSize,unit)	ins_add_c_pblk
(
	.pic_width_in_luma_samples			(pic_width_in_luma_samples),
	.pic_height_in_luma_samples			(pic_height_in_luma_samples),
	
	.x1									(c_x1),
	.y1									(c_y1),
	//.ubSize							(ubSize),
	//.unit								(unit),
	
	.add_pblk							(add_c_pblk_)
);

stdcore_bfifo	#(DW,AW,DEPTH)	ins_bfifo
(
	.clk								(clk),
	.arst_n								(arst_n),
	.rst_n								(rst_n),
	
	.p									(p),
	.p_waddr							(p_waddr),
	.p_we_n								(p_we_n),
	.p_pblk								(p_upblk),
	.p_vc								(p_vc_pre),
	
	.c									(c),
	.c_raddr							(c_raddr),
	.c_re_n								(c_re_n),
	.c_pblk								(c_upblk),
	.c_st								(c_st)
);

endmodule


