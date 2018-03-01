module SAD #(
	parameter
	BLK_N = 4,
	PIX_N = BLK_N*BLK_N,
	MEA_N  = PIX_N/2,
	PIX_WID = 8,
	MEA_WID = $clog2(PIX_N)+PIX_WID,
	QSTEP_WID = 3,
	PREDICTOR_N = 2

	)
	(
	input	logic		signed 	[MEA_WID:0] 			y_1[0:MEA_N-1],		//residue 1
	input	logic		signed 	[MEA_WID:0] 			y_2[0:MEA_N-1],		//residue 2
	output  logic 		[MEA_WID+$clog2(PIX_N):0] 		sad
	);

	logic  signed 	[MEA_WID+1:0] 			dif[0:MEA_N-1],d[0:MEA_N-1];
	logic  			[MEA_WID+1:0] 			s_1[0:MEA_N/2-1];
	logic   		[MEA_WID+2:0] 			s_2[0:MEA_N/4-1];


	generate 
		genvar i;
		for (i=0; i < MEA_N; i = i+1) begin:xsad
			always_comb begin
				d[i] = y_1[i]-y_2[i];
				if(d[i]<0) begin
					dif[i]=d[i]*$signed(-1);
				end
				else begin
					dif[i]=d[i];
				end	

				if(i<MEA_N/2)	begin
					s_1[i] = dif[i*2]+dif[i*2+1];
				end
				if(i<MEA_N/4)	begin
					s_2[i] = s_1[i*2]+s_1[i*2+1];
				end
			end
		end
	endgenerate

	always_comb begin
		sad = s_2[0]+s_2[1];
	end


endmodule // SAD