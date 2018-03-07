/*
    NAME:
        TB_stdcore_rfifo.v
        
    DESCRIPTION:
        
    NOTES:
        
    TO DO:
        
    AUTHOR:
        Dajiang Zhou
        
	REVISION HISTORY:
        14.05.22    Initial
        
*/

`timescale 1ns/1ps

module TB_stdcore_rfifo;


parameter           DW = 8;
parameter           DEPTH = 16;
parameter           PRE = 0;


reg                 clk;
reg                 arst_n = 0;
reg                 rst_n = 0;

reg     [DW-1:0]    p;
reg                 p_val = 0;
wire                p_rdy;

wire    [DW-1:0]    c;
wire                c_val;
reg                 c_rdy = 0;

reg     [DW-1:0]    chkfifo [0:DEPTH*2-1];
integer             chkptr = 0, chkptw = 0;


initial begin clk = 0; forever #5 clk = ~clk; end

initial begin
  
  #33 arst_n = 1;
  
  @(posedge clk); @(posedge clk);
  rst_n = 1;
  
  @(posedge clk); @(posedge clk);
  
  forever @(posedge clk) begin
    #0.5
    p_val = 0;
    c_rdy = 0;
    if($random % 10 < 3) begin
      p_val = 1;
      p = $random;
      if(p_val&&p_rdy) begin
        chkfifo[chkptw] = p;
        chkptw = (chkptw == DEPTH*2-1) ? 0 : chkptw + 1;
      end
    end
    if($random %10 < 3) begin
      c_rdy = 1;
      if(c_val&&c_rdy) begin
        if (chkfifo[chkptr]!=c) begin
          $display("Error @ %t",$time);
          $stop;
        end
        else begin
          $write("%02x",c);
          if(chkptr==DEPTH-1)
            $write("\n");
        end
        chkptr = (chkptr == DEPTH*2-1) ? 0 : chkptr + 1;
      end
    end
  end
  
end


stdcore_rfifo #(DW,DEPTH,PRE) dut(
  .clk(clk),
  .arst_n(arst_n),
  .rst_n(rst_n),
  .p(p),
  .p_val(p_val),
  .p_rdy(p_rdy),
  .c(c),
  .c_val(c_val),
  .c_rdy(c_rdy)
);




endmodule









