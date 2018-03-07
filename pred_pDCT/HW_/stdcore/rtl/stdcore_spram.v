/*
    NAME:
        stdcore_spram.v
        
    DESCRIPTION:
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        11.07.07    Initial.
        
*/

`timescale 1ns/1ps

module stdcore_spram(
	clk,
    ce_n,
	we_n,
	rdata,
	wdata,
	addr
);

parameter DW = 1;
parameter AW = 1;
parameter DEPTH = 1;

input	clk;
input   ce_n;
input	we_n;
output	[DW-1:0]	rdata;
input	[DW-1:0]	wdata;
input	[AW-1:0]	addr;

`ifdef SMIC40LL

`define CLOG2(N) (\
  (N) <= 1<< 0 ?  0 : (N) <= 1<< 1 ?  1 : (N) <= 1<< 2 ?  2 : (N) <= 1<< 3 ?  3 : \
  (N) <= 1<< 4 ?  4 : (N) <= 1<< 5 ?  5 : (N) <= 1<< 6 ?  6 : (N) <= 1<< 7 ?  7 : \
  (N) <= 1<< 8 ?  8 : (N) <= 1<< 9 ?  9 : (N) <= 1<<10 ? 10 : (N) <= 1<<11 ? 11 : \
  (N) <= 1<<12 ? 12 : (N) <= 1<<13 ? 13 : (N) <= 1<<14 ? 14 : (N) <= 1<<15 ? 15 : 0)
  
`define RFSP(W,DEP,M,N) \
wire    [W-1:0] rdata_``N, wdata_``N; \
rf_sp_``W``x``DEP``m``M m``N (    \
  .Q            (rdata_``N),    \
  .CLK          (clk),          \
  .CEN          (ce_n),         \
  .WEN          (we_n),         \
  .A            (addr | {(`CLOG2(DEP)){1'b0}}), \
  .D            (wdata_``N),    \
  .EMA          (3'd2),         \
  .EMAW         (2'd2),         \
  .RET1N        (1'b1)          \
); \
initial $display("INFO: SMIC40LL rf_sp_%0dx%0dm%0d instantiated as %m.m%0d",W,DEP,M,N);

`define SINGLE  assign wdata_0 = wdata; assign rdata = rdata_0;
`define DOUBLE  assign {wdata_1,wdata_0} = wdata; assign rdata = {rdata_1,rdata_0};


generate
  if (DW ==  95 && DEPTH ==   64) begin `RFSP(128,128,2,0) `SINGLE end else
  if (DW == 256 && DEPTH ==   64) begin `RFSP(128,128,2,0) `RFSP(128,128,2,1) `DOUBLE end else
  if (DW == 768 && DEPTH ==  128) begin
    `RFSP(128,128,2,0) `RFSP(128,128,2,1) `RFSP(128,128,2,2) `RFSP(128,128,2,3) `RFSP(128,128,2,4) `RFSP(128,128,2,5)
    assign {wdata_5,wdata_4,wdata_3,wdata_2,wdata_1,wdata_0} = wdata; assign rdata = {rdata_5,rdata_4,rdata_3,rdata_2,rdata_1,rdata_0};
  end else
  if (DW == 384 && DEPTH ==  128) begin
    `RFSP(128,128,2,0) `RFSP(128,128,2,1) `RFSP(128,128,2,2)
    assign {wdata_2,wdata_1,wdata_0} = wdata; assign rdata = {rdata_2,rdata_1,rdata_0};
  end else
  if (DW ==  23 && DEPTH ==  960) begin `RFSP(64,1024,4,0) `SINGLE end else
  if (DW ==  95 && DEPTH ==  480) begin `RFSP(96, 512,2,0) `SINGLE end else
//  if (DW == 256 && DEPTH ==  960) begin
//    `RFSP(64,1024,4,0) `RFSP(64,1024,4,1) `RFSP(64,1024,4,2) `RFSP(64,1024,4,3)
//    assign {wdata_3,wdata_2,wdata_1,wdata_0} = wdata; assign rdata = {rdata_3,rdata_2,rdata_1,rdata_0};
//  end else
  if (DW == 320 && DEPTH ==  960) begin
    `RFSP(64,1024,4,0) `RFSP(64,1024,4,1) `RFSP(64,1024,4,2) `RFSP(64,1024,4,3) `RFSP(64,1024,4,4)
    assign {wdata_4,wdata_3,wdata_2,wdata_1,wdata_0} = wdata; assign rdata = {rdata_4,rdata_3,rdata_2,rdata_1,rdata_0};
  end else

`undef  RFSP
`undef  SINGLE
`undef  DOUBLE
  begin: generic
`endif
//synopsys translate_off

reg     [DW-1:0]    rdata_reg;
reg     [DW-1:0]    mem [DEPTH-1:0];

assign  rdata = rdata_reg;  

always @ (posedge clk)
  if(~ce_n) begin
    if(~we_n) begin
      mem[addr] <= #1 wdata;
      rdata_reg <= #1 wdata;
    end
    else begin
      rdata_reg <= #1 mem[addr];
    end
  end
  //else begin
  //  rdata_reg <= #1 {DW{1'bx}};
  //end

initial begin
	$display("INFO: stdcore_spram_%0dx%0d created as %m", DW, DEPTH);
	if ( AW == 1 && DEPTH == 1)
		$display("INFO: parameters may not be properly defined for %m");
end

//synopsys translate_on
`ifdef SMIC40LL
  end
endgenerate
`endif




endmodule



