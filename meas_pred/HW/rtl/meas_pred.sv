`timescale 1ns/1ps
module meas_pred #(

	parameter
	BLK_N = 4,
	PIX_N = BLK_N*BLK_N,
	MEA_N  = PIX_N/2,
	PIX_WID = 8,
	MEA_WID = $clog2(PIX_N)+PIX_WID,
	QSTEP_WID = 3,
	PREDICTOR_N = 2,
	PIC_WID_IN_PIX = 8192,
	PIC_HT_IN_PIX = 4096,
	PIC_WID_IN_BLK = PIC_WID_IN_PIX/BLK_N,
	PIC_HT_IN_BLK = PIC_HT_IN_PIX/BLK_N,
	PIC_WID_IN_BLK_LEN = $clog2(PIC_WID_IN_BLK),
	PIC_HT_IN_BLK_LEN = $clog2(PIC_HT_IN_BLK),
	N_STAGES = 4
	)
(
	input	logic									clk,rst_n,arst_n,en_o,en_i,
	input 	logic 	signed 	[MEA_WID:0] 			y[0:MEA_N-1],
	input	logic			[QSTEP_WID-1:0]			Qstep,
	output	logic	signed 	[MEA_WID:0] 			y_resQ[0:MEA_N-1],
	output	logic	signed [0:1]					code
);



logic 				signed 	[MEA_WID:0]				y_p[0:PREDICTOR_N][0:MEA_N-1];
logic 				[MEA_WID+$clog2(PIX_N):0] 		sad_ca[0:2];  // 0:top, 1:left  2:ave, 
logic				signed 	[MEA_WID:0] 			y_res[0:MEA_N-1];
logic				[PIC_WID_IN_BLK_LEN-1:0]		cor_X;
logic				[PIC_HT_IN_BLK_LEN-1:0]			cor_Y;
logic				signed 	[MEA_WID:0] 			y_rec[0:MEA_N-1];
logic 				signed 	[MEA_WID:0] 			y_cand[0:MEA_N-1];

FSM #(.PIC_WID_IN_PIX(PIC_WID_IN_PIX),.PIC_HT_IN_PIX(PIC_HT_IN_PIX))c_FSM(.*);
//use following matrix A as example 
/*A = 
   1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
     1     0     0    -1     1     0     0    -1     1     0     0    -1     1     0     0    -1
     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1     1    -1    -1     1
     0    -1     1     0     0    -1     1     0     0    -1     1     0     0    -1     1     0
     1     1     1     1     0     0     0     0     0     0     0     0    -1    -1    -1    -1
     1     0     0    -1     0     0     0     0     0     0     0     0    -1     0     0     1
*/

//random_Bin_Matrix

	
typedef struct {
	logic	[PIC_WID_IN_BLK_LEN-1:0]			cor_X;
	logic 	[PIC_HT_IN_BLK-1:0]					cor_Y;
} pip_data;

typedef struct {
	logic 	[MEA_WID:0] 					y_buf[0:PREDICTOR_N-1];
} buf_data;

	logic	[PIX_WID-1:0] 					x_buf_le,x_buf_bot,x_ave_top;


typedef struct {
	logic	[PIX_WID+1:0]					s_3,s_4;
	logic	[PIX_WID+2:0]					s_6,s_7;
	logic	[PIX_WID+3:0]					s_12,s_11;
	logic	[PIX_WID+4:0]					s_13,s_14;
	logic 	[PIX_WID-1:0]					x_pred;

} pred_data;

	pred_data 				pred[0:2];		//0 up, 1:left 2:constant 1 
	logic [PIX_WID-1:0]  ave_le,ave_bot;
	assign ave_le =  x_buf_le;
	assign ave_bot = x_ave_top;
always_comb begin
	pred[0].x_pred = ave_bot;
	pred[1].x_pred = ave_le;
	pred[2].x_pred = 128;

	pred[0].s_3 = (pred[0].x_pred<<1)+pred[0].x_pred;
	pred[0].s_4 = pred[0].x_pred<<2;
	pred[0].s_6 = pred[0].s_3<<1;
	pred[0].s_7 = pred[0].s_3+pred[0].s_4;
	pred[0].s_12 = pred[0].s_6<<1;
	pred[0].s_11 = pred[0].s_4+pred[0].s_7;
	pred[0].s_13 = pred[0].s_6+pred[0].s_7;
	pred[0].s_14 = pred[0].s_7<<1;

	pred[1].s_3 = (pred[1].x_pred<<1)+pred[1].x_pred;
	pred[1].s_4 = pred[1].x_pred<<2;
	pred[1].s_6 = pred[1].s_3<<1;
	pred[1].s_7 = pred[1].s_3+pred[1].s_4;
	pred[1].s_12 = pred[1].s_6<<1;
	pred[1].s_11 = pred[1].s_4+pred[1].s_7;
	pred[1].s_13 = pred[1].s_6+pred[1].s_7;
	pred[1].s_14 = pred[1].s_7<<1;

	pred[2].s_3 = (pred[2].x_pred<<1)+pred[2].x_pred;
	pred[2].s_4 = pred[2].x_pred<<2;
	pred[2].s_6 = pred[2].s_3<<1;
	pred[2].s_7 = pred[2].s_3+pred[2].s_4;
	pred[2].s_12 = pred[2].s_6<<1;
	pred[2].s_11 = pred[2].s_4+pred[2].s_7;
	pred[2].s_13 = pred[2].s_6+pred[2].s_7;
	pred[2].s_14 = pred[2].s_7<<1;
	end

always_comb begin
	code = -1;

	if(stages[1].cor_X == 0 && stages[1].cor_Y==0) begin
		code = -1;
	end
	else if (stages[1].cor_X !=0 && stages[1].cor_Y==0)  begin		//Top line in an image
		if(sad_ca[1]<sad_ca[2]) begin
			code = 0;
		end else begin
			code = -1;
		end
	end
	else if	(stages[1].cor_X == 0 && stages[1].cor_Y!=0) begin   	//Left column in an image
		if(sad_ca[0]<sad_ca[2]) begin
			code = 1;
		end else begin
			code = -1;
		end
	end
	else begin//other blocks
		if(sad_ca[1]<sad_ca[0] && sad_ca[1]<sad_ca[2])	begin
			code = 0;
		end
		else if(sad_ca[0]<sad_ca[2]) begin
			code = 1;
		end
		else begin
			code = -1;
		end
	end
end
	generate 
		for (genvar i=0; i < MEA_N; i = i+1) begin:y_mea
			always_comb begin
				//init.
				if(i==0 || i==1) begin
					y_p[0][i] = pred[0].s_4;
					y_p[1][i] = pred[1].s_4;
					y_p[2][i] = pred[2].s_4; 
				end else begin
					if(i==2 ||i==4 ||i==7 ||i==10) begin
					//pred. bottom colum
						y_p[0][i] = pred[0].s_12;
					//pred. right column
						y_p[1][i] = pred[1].s_12;
						y_p[2][i] = pred[2].s_12;
					end
					if(i==5 || i==9 || i==11) 	begin
						y_p[0][i] = pred[0].s_13;
						y_p[1][i] = pred[1].s_13;
						y_p[2][i] = pred[2].s_13;
					end
					if(i==3) 	begin
						y_p[0][i] = pred[0].s_14;
						y_p[1][i] = pred[1].s_14;
						y_p[2][i] = pred[2].s_14;
					end
					if(i==6) 	begin
						y_p[0][i] = pred[0].s_7;
						y_p[1][i] = pred[1].s_7;
						y_p[2][i] = pred[2].s_7;
					end
					if(i==8) 	begin
						y_p[0][i] = pred[0].s_11;
						y_p[1][i] = pred[1].s_11;
						y_p[2][i] = pred[2].s_11;
					end
				end
				// 
				y_cand[i] = 0;
				

				if(stages[1].cor_X == 0 && stages[1].cor_Y==0) begin
					y_cand[i] = y_p[2][i];
				end
				else if (stages[1].cor_X !=0 && stages[1].cor_Y==0)  begin		//Top line in an image
					if(sad_ca[1]<sad_ca[2]) begin
						y_cand[i] = y_p[1][i];
					end else begin
						y_cand[i] = y_p[2][i];
					end
				end
				else if	(stages[1].cor_X == 0 && stages[1].cor_Y!=0) begin   	//Left column in an image
					if(sad_ca[0]<sad_ca[2]) begin
						y_cand[i] = y_p[0][i];
					end else begin
						y_cand[i] = y_p[2][i];
					end
				end
				else begin//other blocks
					if(sad_ca[1]<sad_ca[0] && sad_ca[1]<sad_ca[2])	begin
						y_cand[i]  = y_p[1][i];
					end
					else if(sad_ca[0]<sad_ca[2]) begin
						y_cand[i]  = y_p[0][i];
					end
					else begin
						y_cand[i]  = y_p[2][i];
					end
				end

				y_res[i] = y[i]-y_cand[i];
			end
		end
	endgenerate



SAD #(.MEA_N(MEA_N)) c_sad_top(.y_1(y),.y_2(y_p[0]),.sad(sad_ca[0]),.*);
SAD #(.MEA_N(MEA_N)) c_sad_le(.y_1(y),.y_2(y_p[1]),.sad(sad_ca[1]),.*);
SAD #(.MEA_N(MEA_N)) c_sad_ave(.y_1(y),.y_2(y_p[2]), .sad(sad_ca[2]),.*);


	//Quantization
	generate 
		for (genvar i=0; i < MEA_N; i = i+1) begin:Y_qr
			assign y_resQ[i]=y_res[i]>>Qstep;
			assign y_rec[i]=(y_resQ[i]<<Qstep)+y_cand[i];
		end
	endgenerate	


	


	pip_data stages[0:N_STAGES];
	buf_data buf_s[0:3];

	//memory controller

	logic [PIC_WID_IN_BLK_LEN-1:0] 	raddr,waddr;
	logic [PIX_WID-1:0] 			rdata,wdata;
	logic re_n,we_n;

	stdcore_2prf #(.AW(PIC_WID_IN_BLK_LEN), .DW(PIX_WID), .DEPTH(1<<PIC_WID_IN_BLK_LEN))sram(
	.wclk(clk),
	.wdata,
	.waddr,
	.we_n,
	.rclk(clk),
	.rdata,
	.raddr,
	.re_n
	);


	logic isBotLine,isFirstLine;



	assign isFirstLine =  cor_Y == 0;
	assign isBotLine = cor_Y ==(PIC_HT_IN_PIX>>$clog2(BLK_N))-1;
	always_comb begin
		re_n = 0;
		if(isFirstLine)
			re_n = 1;
		we_n = 0;
		if(isBotLine)
			we_n =1;
	end
	assign raddr = cor_X;

	assign waddr = stages[2].cor_X;
	assign wdata = x_buf_bot;


	always_ff @(posedge clk or negedge arst_n) begin : proc_store
		if(~arst_n) begin
			for (int i = 0; i<=N_STAGES ; i++) begin
		//		stages[i].cor_X <=0;
		//		stages[i].cor_Y <=0;
		//		stages[i] <={12'd0};
				stages[i] <='{default:0};
			end
			{x_buf_le,x_buf_bot,x_ave_top} <= 0;
			
		end else if(~rst_n)begin
			for (int i = 0; i<=N_STAGES ; i++) begin
				stages[i] <='{default:0};
		//		stages[i] <={12'd0};
			end
			{x_buf_le,x_buf_bot,x_ave_top} <= 0;
		end else begin
			for (int i = 1; i<=N_STAGES ; i++) begin
				stages[i]<=stages[i-1];
			end
				stages[0].cor_X <= cor_X;
				stages[0].cor_Y <= cor_Y;

			
			//x_buf_le <= (((y_rec[0]+y_rec[5])>>1)-y_rec[1])<<1;
			//x_buf_bot<= 	(((y_rec[0]+y_rec[3])>>1)-y_rec[2])<<1;
			
			x_buf_le <= y_rec[1]>>$clog2(BLK_N);
			x_buf_bot<= y_rec[0]>>$clog2(BLK_N);

	 		x_ave_top <= rdata;
		end
	end




endmodule // meas_pred