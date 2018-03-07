`timescale 1ns/1ps

module TB_stdcore_asyncfifo;

//parameter for tb

parameter			P_CLK = 1.5;		//37;	//5;	//5;	//3;	//3;	
parameter			C_CLK = 1.51;		//3;	//37;	//37;	//5;	//5;	
parameter			P_VAL = 2;		//-3;	//1;	//9;	//9;	//-3;
parameter			C_RDY = 3;		//9;	//9;	//1;	//-3;	//9;

parameter           DW = 8;
parameter           DEPTH = 2;	//128;	//2;
parameter           VIRTUAL = 0;
parameter			AW = 	1;	//7;	//1;

reg                 arst_n = 0;
reg                 p_rst_n = 0;
reg                 p_clk;
reg					c_rst_n = 0;
reg					c_clk;

reg     [DW-1:0]    p;
reg                 p_val = 0;
wire                p_rdy;

wire    [DW-1:0]    c;
wire                c_val;
reg                 c_rdy = 0;

reg     [DW-1:0]    chkfifo [0:DEPTH*2-1];
integer             chkptr = 0, chkptw = 0;


initial begin p_clk = 0; forever #P_CLK p_clk = ~p_clk; end
initial begin c_clk = 0; forever #C_CLK c_clk = ~c_clk; end

initial begin
  
  #33 arst_n = 1;
  
end 

initial begin
  
  #50
  
  @(posedge p_clk); @(posedge p_clk);
  p_rst_n = 1;
  
  @(posedge p_clk); @(posedge p_clk);
  
  forever @(posedge p_clk) begin
    #0.5
    p_val = 0;
    if($random % 10 < P_VAL) begin
      p_val = 1;
      p = $random;
      if(p_val&&p_rdy) begin
        chkfifo[chkptw] = p;
        chkptw = (chkptw == DEPTH*2-1) ? 0 : chkptw + 1;
      end
    end
  end
  
end

initial begin

	#50

  @(posedge c_clk); @(posedge c_clk);
  c_rst_n = 1;
  
  @(posedge c_clk); @(posedge c_clk);

  forever @(posedge c_clk) begin
	#0.5
	c_rdy = 0;
    if($random %10 < C_RDY) begin
      c_rdy = 1;
      if(c_val&&c_rdy) begin
        if (chkfifo[chkptr]!=c) begin
          $display("Error @ %t",$time);
          $stop;
        end
        else begin
          /*$write("%02x",c);
          if(chkptr==DEPTH-1)
            $write("\n");*/
        end
        chkptr = (chkptr == DEPTH*2-1) ? 0 : chkptr + 1;
      end
    end
	
  end
  
end

stdcore_asyncfifo	#(DW,DEPTH,VIRTUAL,AW)	ins_stdcore_asyncfifo
	(
		.arst_n		(arst_n),
		
		.p_rst_n	(p_rst_n),
		.p_clk		(p_clk),
		.p			(p),
		.p_val		(p_val),
		.p_rdy		(p_rdy),
		
		.c_rst_n	(c_rst_n),
		.c_clk		(c_clk),
		.c			(c),
		.c_val		(c_val),
		.c_rdy		(c_rdy)
		
	);

endmodule