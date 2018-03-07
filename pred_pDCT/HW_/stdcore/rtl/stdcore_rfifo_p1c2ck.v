/*
    NAME:
        stdcore_rfifo_p1c2ck.v
        
    DESCRIPTION:
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        14.11.29    Initial.
        
*/

`timescale 1ns/1ps

module stdcore_rfifo_p1c2ck
#(
parameter                       DW = 1,
parameter                       DEPTH = 1
)
(
input                           arst_n,
input                           rst_n,

input                           p_clk,
input                           c_clk,

input       [DW-1:0]            p,
input                           p_val,
output                          p_rdy,

output      [DW-1:0]            c,
output                          c_val,
input                           c_rdy
);


wire        [DW-1:0]            pp;
wire                            pp_val;
wire                            pp_rdy;

wire        [DW-1:0]            cc;
reg                             cc_val;
wire                            cc_rdy;

assign  cc = pp;
assign  pp_rdy = cc_rdy;

always @ (posedge c_clk or negedge arst_n)
  if(!arst_n)
    cc_val <= #0.1 0;
  else if(!rst_n)
    cc_val <= #0.1 0;
  else
    cc_val <= #0.1 !cc_val && pp_val;

stdcore_rfifo #(.DW(DW),.DEPTH(4),.AW(3)) pp_fifo (
  .clk                          (p_clk),
  .arst_n                       (arst_n),
  .rst_n                        (rst_n),
  
  .p                            (p),
  .p_val                        (p_val),
  .p_rdy                        (p_rdy),
  
  .c                            (pp),
  .c_val                        (pp_val),
  .c_rdy                        (pp_rdy)
);

`define CLOG2(N) (\
  (N) <= 1<< 0 ?  0 : (N) <= 1<< 1 ?  1 : (N) <= 1<< 2 ?  2 : (N) <= 1<< 3 ?  3 : \
  (N) <= 1<< 4 ?  4 : (N) <= 1<< 5 ?  5 : (N) <= 1<< 6 ?  6 : (N) <= 1<< 7 ?  7 : \
  (N) <= 1<< 8 ?  8 : (N) <= 1<< 9 ?  9 : (N) <= 1<<10 ? 10 : (N) <= 1<<11 ? 11 : \
  (N) <= 1<<12 ? 12 : (N) <= 1<<13 ? 13 : (N) <= 1<<14 ? 14 : (N) <= 1<<15 ? 15 : 0)
stdcore_rfifo #(.DW(DW),.DEPTH(DEPTH),.AW(`CLOG2(DEPTH+2))) cc_fifo(
`undef CLOG2
  
  .clk                          (c_clk),
  .arst_n                       (arst_n),
  .rst_n                        (rst_n),
  
  .p                            (cc),
  .p_val                        (cc_val),
  .p_rdy                        (cc_rdy),
  
  .c                            (c),
  .c_val                        (c_val),
  .c_rdy                        (c_rdy)
);




endmodule



