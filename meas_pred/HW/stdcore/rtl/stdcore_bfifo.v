/*
    NAME:
        stdcore_bfifo.v
        
    DESCRIPTION:
        Block first in first out, random accessible inside each block
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        14.08.01    Initial
        
*/

`timescale 1ns/1ps

module stdcore_bfifo(
  
  clk,
  arst_n,
  rst_n,
  
  p,
  p_waddr,      // 
  p_we_n,       
  p_pblk,       // push block size
  p_vc,         // vacancy
  
  c,
  c_raddr,      // 
  c_re_n,       
  c_pblk,       // pull block size
  c_st          // storage
  
);

parameter               DW = 1;
parameter               AW = 1;
parameter               DEPTH = 1;      // IMPORTANT: DEPTH must be the integer multiple of all possible block sizes!


input                   clk;
input                   arst_n;
input                   rst_n;

input   [DW-1:0]        p;
input   [AW-1:0]        p_waddr;
input                   p_we_n;
input   [AW  :0]        p_pblk;
output  [AW  :0]        p_vc;

output  [DW-1:0]        c;
input   [AW-1:0]        c_raddr;
input                   c_re_n;
input   [AW  :0]        c_pblk;
output  [AW  :0]        c_st;


reg     [AW-1:0]        p_baddr, c_baddr;
reg     [AW  :0]        p_vc;
reg     [AW  :0]        c_st;

wire    [AW  :0]        c_st_;

reg     [DEPTH-1:0]     nonzeros, nonzeros_;
reg                     nonzero;

wire    [DW-1:0]        rf_rdata;
wire    [AW-1:0]        rf_waddr, rf_raddr;


assign  c = nonzero ? rf_rdata : 0;

`ifdef BFIFO_ADV
assign  rf_waddr = (p_waddr + p_baddr >= DEPTH) ? (p_waddr + p_baddr - DEPTH) : (p_waddr + p_baddr);
assign  rf_raddr = (c_raddr + c_baddr >= DEPTH) ? (c_raddr + c_baddr - DEPTH) : (c_raddr + c_baddr);
`else
assign  rf_waddr = p_waddr | p_baddr;
assign  rf_raddr = c_raddr | c_baddr;
`endif

assign  c_st_ = c_st + p_pblk - c_pblk;

always @ (posedge clk or negedge arst_n)
  if(!arst_n) begin
    p_baddr <= 0;
    c_baddr <= 0;
    p_vc <= 0;
    c_st <= 0;
    nonzeros <= 0;
    nonzero <= 0;
  end
  else if(!rst_n) begin
    p_baddr <= 0;
    c_baddr <= 0;
    p_vc <= 0;
    c_st <= 0;
    nonzeros <= 0;
    nonzero <= 0;
  end
  else begin
    p_baddr <= (p_baddr + p_pblk >= DEPTH) ? (p_baddr + p_pblk - DEPTH) : p_baddr + p_pblk;
    c_baddr <= (c_baddr + c_pblk >= DEPTH) ? (c_baddr + c_pblk - DEPTH) : c_baddr + c_pblk;
    c_st <= c_st_;
    p_vc <= DEPTH - c_st_;
    nonzeros <= nonzeros_;
    if(!c_re_n)
      nonzero <= nonzeros[rf_raddr];
  end

always @ (*) begin: znz
  integer   i;
  nonzeros_ = nonzeros;
  if(!p_we_n)
    nonzeros_[rf_waddr] = 1'b1;
  if(c_pblk)
    for(i = 0; i < DEPTH; i = i + 1)
      if((i >= c_baddr && i < c_baddr + c_pblk) || (c_baddr + c_pblk > DEPTH && i < c_baddr + c_pblk - DEPTH))
        nonzeros_[i] = 1'b0;
end


stdcore_2prf #(DW,AW,DEPTH) rf(
  
  .wclk     (clk),
  .wdata    (p),
  .waddr    (rf_waddr),
  .we_n     (p_we_n),
  
  .rclk     (clk),
  .rdata    (rf_rdata),
  .raddr    (rf_raddr),
  .re_n     (c_re_n)
  
);


//synopsys translate_off
always @ (posedge clk) begin
`ifdef BFIFO_ADV
`else
  if(!p_we_n && rf_waddr != p_waddr + p_baddr) $display("ERROR: unaligned p_waddr at %m @ %t", $time);
  if(!c_re_n && rf_raddr != c_raddr + c_baddr) $display("ERROR: unaligned c_raddr at %m @ %t", $time);
  if( p_baddr + p_pblk > DEPTH) $display("ERROR: unaligned p_pblk at %m @ %t", $time);
  if( c_baddr + c_pblk > DEPTH) $display("ERROR: unaligned c_pblk at %m @ %t", $time);
`endif
  if(!p_we_n && p_waddr >= p_vc) $display("ERROR: p_waddr exceeds vacancy at %m @ %t", $time);
  if(!c_re_n && c_raddr >= c_st) $display("ERROR: c_raddr exceeds stock at %m @ %t", $time);
end

initial begin
  $display("ERROR: stdcore_bfifo instantiated as %m. This module is obseleted. Use stdcore_bbfifo instead!");
end
//synopsys translate_on


endmodule



