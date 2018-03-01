function [ neigh ] = refPrepare( buf_up,buf_le,B_i,B_j,w_B,midValue,N)
%REFPREPARE Summary of this function goes here
%   Detailed explanation goes here
    if(N==8)
        neigh(1:2)=buf_up(B_j*2-1:B_j*2);
        neigh(3:4)= buf_le(1:2);
        if(B_j == w_B)
            neigh(5:6)= neigh(2);
        else
            neigh(5:6)= buf_up(B_j*2+1:B_j*2+2);
        end
        if(B_j>1 && B_i>1)
            neigh(7) = buf_up(B_j*2-2);
        else
            neigh(7) = midValue;
        end
    elseif(N==16)
        neigh(1:4)= buf_up(B_j*4-3:B_j*4);
        neigh(5:8)= buf_le(1:4);

        if(B_j == w_B)
            neigh(9:12)= neigh(4);
        else
            neigh(9:12)= buf_up((B_j+1)*4-3:(B_j+1)*4);
        end
        if(B_j>1 && B_i>1)
            neigh(13) = buf_up(B_j*4-1);
        else
            neigh(13) = midValue;
        end
    end
end

