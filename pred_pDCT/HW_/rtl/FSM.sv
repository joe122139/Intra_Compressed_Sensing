`timescale 1ns/1ps
module FSM #(
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
	N_STAGES = 4,
	N_CYC_LUM = PIC_WID_IN_PIX/BLK_N*PIC_HT_IN_PIX/BLK_N, 	
	N_CYC_CHR = PIC_WID_IN_PIX/2/BLK_N*PIC_HT_IN_PIX/2/BLK_N,
	N_CYC_LUM_LEN = $clog2(N_CYC_LUM)
	)

(
	input	logic									clk,rst_n,arst_n,en_o,en_i,
	output 	logic	[PIC_WID_IN_BLK_LEN-1:0]			cor_X,
	output 	logic	[PIC_HT_IN_BLK_LEN-1:0]				cor_Y
	);




enum 	logic	{IDLE,WORK}							state,n_state;
		logic [N_CYC_LUM_LEN-1:0]  				cnt,cnt_;
		logic	[PIC_WID_IN_BLK_LEN-1:0]				X,X_;
		logic	[PIC_HT_IN_BLK_LEN-1:0]					Y,Y_;
		logic										end_of_luma,end_of_chroma_st;
		logic	[1:0]								cIdx;

	 	assign cor_Y = Y;
	 	assign cor_X = X;
logic 								end_of_luma_;

assign end_of_luma_ = !cIdx && cnt == N_CYC_LUM-1;

always_ff @(posedge clk or negedge arst_n) begin
	if(!arst_n)begin
		 state <= IDLE;
		 {cIdx,cnt,X,Y} <=0;
 		 end_of_luma <= 0;
		 end_of_chroma_st <= 0;

	end
	else if(!rst_n)	begin
		 state <= IDLE;
		 {cIdx,cnt,X,Y} <=0;
 		 end_of_luma <= 0;
		 end_of_chroma_st <= 0;
	end
	else	begin
		if( en_o)	begin
			 state <=  n_state;
			 cnt <= cnt_;
			 {X,Y}<={X_,Y_};
			 	if(end_of_luma_)	begin
				cIdx <= 1;
				end
			else if( cIdx==2'b01 &&  cnt == N_CYC_CHR-1)
				cIdx <= 2;
			else if( cIdx==2'b10 &&  cnt == N_CYC_CHR-1)
				cIdx <= 0;
		end
	end
end


always_comb	begin
	n_state = IDLE;
	cnt_ =  cnt;
	X_ = X;
	Y_ = Y;
	
	case (state)
		IDLE:	begin
			if(en_i)
				 n_state = WORK;
		end
		WORK:	begin			//default: WORK
			if((!cIdx &&  cnt != N_CYC_LUM-1) || 
				(|cIdx &&  cnt != N_CYC_CHR-1)) 
					cnt_ =  cnt+1;
				else
					cnt_ = 0;
			
			if(X<(PIC_WID_IN_BLK-1) )
				X_= X+1;
			else begin
				X_= 0;
				if(Y<(PIC_HT_IN_BLK-1))
					Y_=Y+1;
				else
					Y_=0; 
			end
			if(en_i)
				 n_state = WORK;
			
		end
		default: begin
		
		end
			
	endcase
end


endmodule // FSM