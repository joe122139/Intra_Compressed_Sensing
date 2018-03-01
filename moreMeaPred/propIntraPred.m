function [cand_y,cand_mode] = propIntraPred (block_y,B_i,B_j,comp_mode,ave_yo,phi_,neigh,N)
    nonBlk = array_compare(ave_yo,block_y(:,1,B_i,B_j),comp_mode); 
    cand_y = ave_yo;               
    cand_mode=-1; %  default is use original
    minCost = nonBlk; 
    if(B_i==2)
    end
    maxMode= 9;
    if(N==16)
        maxMode =5;
    end
    for m=0:maxMode-1
        cand_x = predModes(m,N,neigh);
        tmp_y = phi_*cand_x';
        cost_cand = array_compare(tmp_y,block_y(:,1,B_i,B_j),comp_mode);     % 1: sse, 0:sad
        if(cost_cand<minCost)
            cand_mode = m;
            minCost = cost_cand;
            cand_y = tmp_y;
        end
    end
end