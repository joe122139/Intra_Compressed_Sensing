/*
    NAME:
        stdcore_bbfifo.v
        
    DESCRIPTION:
        Block first in first out, random accessible inside each block
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        14.12.13    stdcore_bfifo -> stdcore_bbfifo
        
*/

`timescale 1ns/1ps

module stdcore_bbfifo
#(
parameter                       DW = 1,
parameter                       DEPTH = 1,
parameter                       WMASK = 0
)
(  
  clk,
  arst_n,
  rst_n,
  
  p,
  p_waddr,      // 
  p_waddr_,     // 
  p_we_n,       
  p_be_n,
  p_pblk,       // push block size
  p_vc,         // vacancy
  
  c,
  c_raddr,      // 
  c_raddr_,     // 
  c_re_n,       
  c_pblk,       // pull block size
  c_st          // storage
  
);

`define CLOG2(N) (\
  (N) <= 1<< 0 ?  0 : (N) <= 1<< 1 ?  1 : (N) <= 1<< 2 ?  2 : (N) <= 1<< 3 ?  3 : \
  (N) <= 1<< 4 ?  4 : (N) <= 1<< 5 ?  5 : (N) <= 1<< 6 ?  6 : (N) <= 1<< 7 ?  7 : \
  (N) <= 1<< 8 ?  8 : (N) <= 1<< 9 ?  9 : (N) <= 1<<10 ? 10 : (N) <= 1<<11 ? 11 : \
  (N) <= 1<<12 ? 12 : (N) <= 1<<13 ? 13 : (N) <= 1<<14 ? 14 : (N) <= 1<<15 ? 15 : 0)
localparam                      AW = `CLOG2(DEPTH);
`undef  CLOG2

input                   clk;
input                   arst_n;
input                   rst_n;

input   [DW-1:0]        p;
input   [AW-1:0]        p_waddr;
input   [AW-1:0]        p_waddr_;
input                   p_we_n;
input   [DW-1:0]        p_be_n;
input   [AW  :0]        p_pblk;
output  [AW  :0]        p_vc;

output  [DW-1:0]        c;
input   [AW-1:0]        c_raddr;
input   [AW-1:0]        c_raddr_;
input                   c_re_n;
input   [AW  :0]        c_pblk;
output  [AW  :0]        c_st;


reg     [AW-1:0]        p_baddr, c_baddr;
wire    [AW-1:0]        p_baddr_, c_baddr_;
reg     [AW  :0]        p_vc;
reg     [AW  :0]        c_st;

wire    [AW  :0]        c_st_;

reg     [DEPTH-1:0]     nonzeros, nonzeros_;
reg                     nonzero;

wire    [DW-1:0]        rf_rdata;
reg     [AW-1:0]        rf_waddr, rf_raddr;


assign  p_baddr_ = (p_baddr + p_pblk >= DEPTH) ? (p_baddr + p_pblk - DEPTH) : p_baddr + p_pblk;
assign  c_baddr_ = (c_baddr + c_pblk >= DEPTH) ? (c_baddr + c_pblk - DEPTH) : c_baddr + c_pblk;

reg     [AW-1:0]        p_waddr_d, c_raddr_d;

always @ (posedge clk) begin
  p_waddr_d <= p_waddr_;
  c_raddr_d <= c_raddr_;
  if(!p_we_n && p_waddr_d != p_waddr) begin $display("!p_we_n && p_waddr_d != p_waddr %m"); $stop; end
  if(!c_re_n && c_raddr_d != c_raddr) begin $display("!c_re_n && c_raddr_d != c_raddr %m"); $stop; end
end


assign  c = nonzero ? rf_rdata : 0;

//assign  rf_waddr = (p_waddr + p_baddr >= DEPTH) ? (p_waddr + p_baddr - DEPTH) : (p_waddr + p_baddr);
//assign  rf_raddr = (c_raddr + c_baddr >= DEPTH) ? (c_raddr + c_baddr - DEPTH) : (c_raddr + c_baddr);

assign  c_st_ = c_st + p_pblk - c_pblk;

always @ (posedge clk or negedge arst_n)
  if(!arst_n) begin
    p_baddr <= 0;
    c_baddr <= 0;
    p_vc <= 0;
    c_st <= 0;
    nonzeros <= 0;
    nonzero <= 0;
    rf_waddr <= 0;
    rf_raddr <= 0;
  end
  else if(!rst_n) begin
    p_baddr <= 0;
    c_baddr <= 0;
    p_vc <= 0;
    c_st <= 0;
    nonzeros <= 0;
    nonzero <= 0;
    rf_waddr <= 0;
    rf_raddr <= 0;
  end
  else begin
    rf_waddr <= (p_waddr_ + p_baddr_ >= DEPTH) ? (p_waddr_ + p_baddr_ - DEPTH) : (p_waddr_ + p_baddr_);
    rf_raddr <= (c_raddr_ + c_baddr_ >= DEPTH) ? (c_raddr_ + c_baddr_ - DEPTH) : (c_raddr_ + c_baddr_);
    p_baddr <= p_baddr_;
    c_baddr <= c_baddr_;
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

stdcore_b2prf #(.DW(DW),.DEPTH(DEPTH),.WMASK(WMASK),.AW(AW)) rf(
  
  .wclk     (clk),
  .wdata    (p),
  .waddr    (rf_waddr),
  .we_n     (p_we_n),
  .be_n     (p_be_n),
  
  .rclk     (clk),
  .rdata    (rf_rdata),
  .raddr    (rf_raddr),
  .re_n     (c_re_n)
  
);


//synopsys translate_off
always @ (posedge clk) begin
  if(!p_we_n && p_waddr >= p_vc) $display("ERROR: p_waddr exceeds vacancy at %m @ %t", $time);
  if(!c_re_n && c_raddr >= c_st) $display("ERROR: c_raddr exceeds stock at %m @ %t", $time);
end
//synopsys translate_on


endmodule



