/*
    NAME:
        stdcore_asyncfifo.v
        
    DESCRIPTION:
        
    NOTES:
        DEPTH must be the power of 2!!!
        
    TO DO:
        Currently actually usable depth is DEPTH-1, which may be improved.
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        14.11.29    Initial.
        
*/

`timescale 1ns/1ps

module stdcore_asyncfifo
#(
`define CLOG2(N) (\
  (N) <= 1<< 0 ?  0 : (N) <= 1<< 1 ?  1 : (N) <= 1<< 2 ?  2 : (N) <= 1<< 3 ?  3 : \
  (N) <= 1<< 4 ?  4 : (N) <= 1<< 5 ?  5 : (N) <= 1<< 6 ?  6 : (N) <= 1<< 7 ?  7 : \
  (N) <= 1<< 8 ?  8 : (N) <= 1<< 9 ?  9 : (N) <= 1<<10 ? 10 : (N) <= 1<<11 ? 11 : \
  (N) <= 1<<12 ? 12 : (N) <= 1<<13 ? 13 : (N) <= 1<<14 ? 14 : (N) <= 1<<15 ? 15 : 0)
parameter                       DW = 1,
parameter                       DEPTH = 1,
parameter                       VIRTUAL = 0,
parameter                       AW = `CLOG2(DEPTH)
`undef CLOG2
)
(
input                           arst_n,

input                           p_rst_n,
input                           p_clk,
input       [DW-1:0]            p,
input                           p_val,
output                          p_rdy,

input                           c_rst_n,
input                           c_clk,
output  reg [DW-1:0]            c,
output  reg                     c_val,
input                           c_rdy
);


reg     [AW-1:0]                p_addr, p_addr_p1;
reg     [AW-1:0]                p_addr_g, p_addr_p1g;
reg     [AW-1:0]                cp_addr_g;


assign  p_rdy = p_addr_p1g != cp_addr_g;

always @ (*) begin: do_p_
  integer   i;
  p_addr_p1 = (p_addr + 1 == DEPTH) ? 0 : p_addr + 1;
  p_addr_p1g[AW-1] = p_addr_p1[AW-1];
  for(i = AW - 2; i >= 0; i = i - 1)
    p_addr_p1g[i] = p_addr_p1[i+1] ^ p_addr_p1[i];
end

reg     [AW-1:0]                c_addr_g;

always @ (posedge p_clk or negedge arst_n)
  if(!arst_n) begin
    p_addr <= 0;
    p_addr_g <= 0;
    cp_addr_g <= 0;
  end
  else if(!p_rst_n) begin
    p_addr <= 0;
    p_addr_g <= 0;
    cp_addr_g <= 0;
  end
  else begin
    if(p_val && p_rdy) begin
      p_addr <= p_addr_p1;
      p_addr_g <= p_addr_p1g;
    end
    cp_addr_g <= c_addr_g;  // cross domains -> false path c_clk -> p_clk must be set
  end






reg     [AW-1:0]                c_addr, c_addr_p1;
reg     [AW-1:0]                c_addr_p1g;
reg     [AW-1:0]                pc_addr_g;

//assign  c_val = c_addr_g != pc_addr_g;

always @ (*) begin: do_c_
  integer   i;
  c_addr_p1 = (c_addr + 1 == DEPTH) ? 0 : c_addr + 1;
  c_addr_p1g[AW-1] = c_addr_p1[AW-1];
  for(i = AW - 2; i >= 0; i = i - 1)
    c_addr_p1g[i] = c_addr_p1[i+1] ^ c_addr_p1[i];
end

always @ (posedge c_clk or negedge arst_n)
  if(!arst_n) begin
    c_val <= 0;
    c_addr <= 0;
    c_addr_g <= 0;
    pc_addr_g <= 0;
  end
  else if(!c_rst_n) begin
    c_val <= 0;
    c_addr <= 0;
    c_addr_g <= 0;
    pc_addr_g <= 0;
  end
  else begin
    if(c_val && c_rdy) begin
      c_addr <= c_addr_p1;
      c_addr_g <= c_addr_p1g;
      c_val <= c_addr_p1g != pc_addr_g;
    end
    else
      c_val <= c_addr_g != pc_addr_g;
    pc_addr_g <= p_addr_g;  // cross domains -> false path p_clk -> c_clk must be set
  end




generate if(!VIRTUAL) begin: memrw

reg     [DW-1:0]                mem [0:DEPTH-1];

always @ (posedge p_clk)
  if(p_val && p_rdy)
    mem[p_addr] <= p;

always @ (posedge c_clk)
  if(c_val && c_rdy) begin
    if(c_addr_p1g != pc_addr_g) c <= mem[c_addr_p1];
  end
  else
    if(c_addr_g != pc_addr_g) c <= mem[c_addr];

end endgenerate


//synopsys translate_off
initial begin
  if(DEPTH < 2 || DEPTH != (1<<AW)) begin $write("ERROR: DEPTH must be the natural power of 2 for %m\n"); $stop; end
end
//synopsys translate_on


endmodule



