/*
    NAME:
        stdcore_2prf.v
        
    DESCRIPTION:
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        11.07.07    Initial.
        
*/

`timescale 1ns/1ps

module stdcore_2prf(
  
  wclk,
  wdata,
  waddr,
  we_n,
  
  rclk,
  rdata,
  raddr,
  re_n
  
);

parameter           DW = 1;
parameter           AW = 1;
parameter           DEPTH = 1;


input               wclk;
input   [DW-1:0]    wdata;
input   [AW-1:0]    waddr;
input               we_n;
  
input               rclk;
output  [DW-1:0]    rdata;
input   [AW-1:0]    raddr;
input               re_n;

`ifdef SMIC40LL

`define RF2P(W,D,M,N) \
wire    [W-1:0] rdata_``N, wdata_``N; \
rf_2p_``W``x``D``m``M m``N (    \
  .QA           (rdata_``N),    \
  .DB           (wdata_``N),    \
  .CLKA         (rclk),         \
  .CENA         (re_n),         \
  .AA           (raddr),        \
  .CLKB         (wclk),         \
  .CENB         (we_n),         \
  .AB           (waddr),        \
  .EMAA         (3'd2),         \
  .EMAB         (3'd2),         \
  .RET1N        (1'b1),         \
  .COLLDISN     (1'b1)          \
); \
initial $display("INFO: SMIC40LL rf_2p_%0dx%0dm%0d instantiated as %m.m%0d",W,D,M,N);

`define RF2PB(W,D,M,N) \
wire    [W-1:0] rdata_``N, wdata_``N; \
rf_2p_``W``x``D``m``M``b m``N (    \
  .QA           (rdata_``N),    \
  .DB           (wdata_``N),    \
  .CLKA         (rclk),         \
  .CENA         (re_n),         \
  .AA           (raddr),        \
  .CLKB         (wclk),         \
  .CENB         (we_n),         \
  .WENB         (W'b0),         \
  .AB           (waddr),        \
  .EMAA         (3'd2),         \
  .EMAB         (3'd2),         \
  .RET1N        (1'b1),         \
  .COLLDISN     (1'b1)          \
); \
initial $display("INFO: SMIC40LL rf_2p_%0dx%0dm%0db instantiated as %m.m%0d",W,D,M,N);

`define SRDP(W,D,M,N) \
wire    [W-1:0] rdata_``N, wdata_``N; \
dp_``W``x``D``m``M m``N (    \
  .QA           (rdata_``N),    \
  .DB           (wdata_``N),    \
  .CLKA         (rclk),         \
  .CENA         (re_n),         \
  .AA           (raddr),        \
  .CLKB         (wclk),         \
  .CENB         (we_n),         \
  .AB           (waddr),        \
  .EMAA         (3'd2),         \
  .EMAWA        (2'd0),         \
  .EMAB         (3'd2),         \
  .EMAWB        (2'd0),         \
  .RET1N        (1'b1),         \
  .COLLDISN     (1'b1),          \
  .QB           (),             \
  .DA           (W'b0),         \
  .WENA         (1'b1),         \
  .WENB         (1'b0),         \
  .TAA(), .TAB(), .TDA(), .TDB(), .TCENA(1'b1), .TCENB(1'b1), .TENA(1'b1), .TENB(1'b1), \
  .TWENA(1'b1), .TWENB(1'b1), .SEA(1'b0), .SEB(1'b0), .SIA(), .SIB(), .DFTRAMBYP(1'b0), \
  .CENYA(), .CENYB(), .WENYA(), .WENYB(), .AYA(), .AYB(), .SOA(), .SOB()    \
); \
initial $display("INFO: SMIC40LL dp_%0dx%0dm%0d instantiated as %m.m%0d",W,D,M,N);

`define SRDPB(W,D,M,N) \
wire    [W-1:0] rdata_``N, wdata_``N; \
dp_``W``x``D``m``M``b m``N (       \
  .QA           (rdata_``N),    \
  .DB           (wdata_``N),    \
  .CLKA         (rclk),         \
  .CENA         (re_n),         \
  .AA           (raddr),        \
  .CLKB         (wclk),         \
  .CENB         (we_n),         \
  .AB           (waddr),        \
  .EMAA         (3'd2),         \
  .EMAWA        (2'd0),         \
  .EMAB         (3'd2),         \
  .EMAWB        (2'd0),         \
  .RET1N        (1'b1),         \
  .COLLDISN     (1'b1),         \
  .QB           (),             \
  .DA           (W'b0),         \
  .GWENA        (1'b1),         \
  .WENA         ({W{1'b1}),     \
  .GWENB        (1'b0),         \
  .WENB         (W'b0),         \
  .TAA(), .TAB(), .TDA(), .TDB(), .TCENA(1'b1), .TCENB(1'b1), .TENA(1'b1), .TENB(1'b1), \
  .TGWENA(1'b1), .TGWENB(1'b1), .TWENA({W{1'b1}}), .TWENB({W{1'b1}}), .SEA(1'b0), .SEB(1'b0), .SIA(), .SIB(), .DFTRAMBYP(1'b0), \
  .CENYA(), .CENYB(), .WENYA(), .WENYB(), .GWENYA(), .GWENYB(), .AYA(), .AYB(), .SOA(), .SOB() \
); \
initial $display("INFO: SMIC40LL dp_%0dx%0dm%0db instantiated as %m.m%0d",W,D,M,N);

`define SINGLE  assign                  wdata_0  = wdata; assign rdata =                  rdata_0 ;
`define DOUBLE  assign {        wdata_1,wdata_0} = wdata; assign rdata = {        rdata_1,rdata_0};
`define TRIPLE  assign {wdata_2,wdata_1,wdata_0} = wdata; assign rdata = {rdata_2,rdata_1,rdata_0};

generate
  if (DW ==   8 && DEPTH ==  512) begin `RF2P(  8,512,1,0) `SINGLE end else
  if (DW ==  16 && DEPTH ==  128) begin `RF2P( 16,128,1,0) `SINGLE end else
  if (DW ==  20 && DEPTH ==  128) begin `RF2P( 20,128,1,0) `SINGLE end else
  if (DW ==  16 && DEPTH ==  256) begin `RF2P( 16,256,1,0) `SINGLE end else
  if (DW ==  40 && DEPTH ==  254) begin `RF2P( 40,256,1,0) `SINGLE end else
  if (DW ==  44 && DEPTH ==  128) begin `RF2P( 48,128,1,0) `SINGLE end else
  if (DW ==  80 && DEPTH ==  192) begin `RF2P( 80,192,1,0) `SINGLE end else
  if (DW == 256 && DEPTH ==  128) begin `RF2P(128,128,1,0) `RF2P(128,128,1,1) `DOUBLE end else
  if (DW == 256 && DEPTH ==  256) begin `RF2P(128,256,1,0) `RF2P(128,256,1,1) `DOUBLE end else
  if (DW == 260 && DEPTH ==  256) begin `RF2P(128,256,1,0) `RF2P(128,256,1,1) `RF2P(16,256,1,2) `TRIPLE end else
  if (DW == 261 && DEPTH ==  256) begin `RF2P(128,256,1,0) `RF2P(128,256,1,1) `RF2P(16,256,1,2) `TRIPLE end else
  if (DW == 262 && DEPTH ==  256) begin `RF2P(128,256,1,0) `RF2P(128,256,1,1) `RF2P(16,256,1,2) `TRIPLE end else
  if (DW == 160 && DEPTH ==  384) begin `RF2PB(80,384,2,0) `RF2PB(80,384,2,1) `DOUBLE end else
  if (DW == 176 && DEPTH ==  384) begin `RF2PB(80,384,2,0) `RF2PB(96,384,2,1) `DOUBLE end else
  if (DW == 256 && DEPTH ==  272 || DEPTH == 384)
                                  begin `RF2PB(80,384,2,0) `RF2PB(80,384,2,1) `RF2PB(96,384,2,2) `TRIPLE end else
  if (DW == 120 && DEPTH == 1024) begin `RF2PB(60,1024,4,0) `RF2PB(60,1024,4,1) `DOUBLE end else
  if (DW == 176 && DEPTH ==  128) begin `RF2P(128,128,1,0) `RF2P( 48,128,1,1) `DOUBLE end else
`undef  RF2P
`undef  RF2PB
  if (DW ==  10 && DEPTH == 1970) begin `SRDP(10,2048,8,0) `SINGLE end else
  if (DW ==  95 && DEPTH == 2048) begin `SRDP(32,2048,8,0) `SRDP(32,2048,8,1) `SRDP(32,2048,8,2) `TRIPLE end else
`undef  SRDP
`undef  SRDPB
`undef  SINGLE
`undef  DOUBLE
`undef  TRIPLE
  begin: generic
`endif
//synopsys translate_off

reg		[DW-1:0]	rdata_reg;
reg		[DW-1:0]	mem [DEPTH-1:0];

assign  rdata = rdata_reg;

always @ (posedge wclk)
  if ( ~we_n ) begin
    mem[waddr] <= #1 wdata;
    if ( ~re_n && raddr == waddr ) $display("ERROR: R/W address conflict at %m @ %t", $time);
  end

always @ (posedge rclk)
  if ( ~re_n ) begin
    rdata_reg <= #1 mem[raddr];
  end

initial begin
	$display("INFO: stdcore_2prf_%0dx%0d created as %m", DW, DEPTH);
	if ( AW == 1 && DEPTH == 1)
		$display("INFO: parameters may not be properly defined for %m");
end

//synopsys translate_on
`ifdef SMIC40LL
  end
endgenerate
`endif




endmodule



