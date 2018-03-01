function pred_x = predModes(mode,N,neigh)
    p = zeros(N,N);
    n= N*N;
    midValue = 128;
    if(N==8)
        switch mode
            case -1
                pred_x(1:n) = midValue;
            case 0
                pred_x(1:N:n)= neigh(1);
                pred_x(2:N:n)= neigh(1);
                pred_x(3:N:n)= bitshift((neigh(1)*3+neigh(2))+2,-2,'int64');
                pred_x(4:N:n)= bitshift((neigh(1)+neigh(2))+1,-1,'int64');
                pred_x(5:N:n)= bitshift((neigh(1)+neigh(2))+1,-1,'int64');
                pred_x(6:N:n) = bitshift((neigh(2)*3+neigh(1))+2,-2,'int64');
                pred_x(7:N:n)= neigh(2);
                pred_x(8:N:n)= neigh(2);
            case 1
                pred_x(1:2*N) = neigh(3);
                pred_x(2*N+1:3*N) = bitshift((neigh(3)*3+neigh(4))+2,-2,'int64');
                pred_x(3*N+1:5*N) = bitshift(neigh(3)+neigh(4)+1,-1,'int64');
                pred_x(5*N+1:6*N) = bitshift((neigh(4)*3+neigh(3))+2,-2,'int64');
                pred_x(6*N+1:8*N) = neigh(4);
            case 2
                pred_x = zeros(1,n)+bitshift((neigh(1)+neigh(2)+neigh(3)+neigh(4))+2,-2,'int64');
            case 3
                for i=1:8
                    for j=1:8
                        if(i+j<=5)
                            p(i,j)=neigh(1);
                        elseif(i+j<=9)
                            p(i,j)= neigh(2);
                        elseif(i+j<=13)
                            p(i,j)=neigh(5);
                        else
                            p(i,j)=neigh(6);
                        end
                    end
                end
                pt = p';
                pred_x = pt(:)';
            case 4
               for i=1:8
                   for j=1:8
                        if(j>i) 
                           if(j-i>=4 && j>=5)
                               p(i,j)=neigh(2);
                           else
                               p(i,j)=neigh(1);
                           end
                        elseif(j<i)
                            if(i-j>=4)
                                p(i,j)=neigh(4);
                            else
                                p(i,j)=neigh(3);
                            end
                        else
                            p(i,j)= bitshift((neigh(7)*2+neigh(1)+neigh(3))+2,-2,'int64');
                        end 
                   end
               end
                pt = p';
                pred_x = pt(:)';
            case 5
                % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                % a b c d e f g h i j  k  l  m  n  o  p
                for i=1:8
                    for j=1:8
                        if(i<=4)
                            if(j<=4)
                                T = (i-1)*4+j;     
                                if(T==2 || T==3 || T==4 || T==7 || T==8 || T==11 || T==12 || T==16)
                                    p(i,j) = neigh(1);  %A       
                                elseif(T==1 || T==10)   
                                    p(i,j) = bitshift(neigh(1)+neigh(7)+1,-1,'int64');  %Z+A
                                elseif(T==5 || T==14)  
                                    p(i,j) = bitshift(neigh(3)+neigh(7)*2+neigh(1)+2,-2,'int64');    %Q+2Z+A
                                elseif(T==6 || T==15)
                                    p(i,j)=bitshift(neigh(1)*3+neigh(7)+2,-2,'int64');  %3A+Z
                                elseif(T==13)
                                    p(i,j) = neigh(3);
                                elseif(T==9)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(7)+2,-2,'int64');
                                end
                            else
                                T = (i-1)*4+ (j-4);
                                if(T==2 || T==3 || T==4 || T==7 || T==8 || T==11 || T==12 || T==16)
                                    p(i,j) = neigh(2);  %A       
                                elseif(T==1 || T==10)   
                                    p(i,j) = bitshift(neigh(2)+neigh(1)+1,-1,'int64');  %Z+A
                                elseif(T==5 || T==14)  
                                    p(i,j) = bitshift(neigh(1)*3+neigh(2)+2,-2,'int64');    %Q+2Z+A
                                elseif(T==6 || T==15)
                                    p(i,j)=bitshift(neigh(2)*3+neigh(1)+2,-2,'int64');  %3A+Z
                                elseif(T==13 || T==9)
                                    p(i,j) = neigh(1);
                                end
                            end
                        else
                            if(j<=4)
                                T = (i-1-4)*4+ (j);
                                if(T==1 || T==6 || T==10 || T==15 )
                                    p(i,j) = neigh(3);
                                elseif(T==2 || T==11)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(7)+2,-2,'int64');
                                elseif(T==3 || T==12)
                                    p(i,j) = bitshift(neigh(7)+neigh(1)+1,-1,'int64');
                                elseif(T==9 || T ==14)
                                    p(i,j) = bitshift(neigh(4)*3+neigh(3)+2,-2,'int64');
                                elseif(T==16 || T==7)
                                    p(i,j) = bitshift(neigh(3)+neigh(7)*2+neigh(1)+2,-2,'int64');
                                elseif(T==13)
                                    p(i,j)= neigh(4);
                                elseif(T==8)
                                    p(i,j) = bitshift(neigh(7)+neigh(1)*3+2,-2,'int64');
                                elseif(T==5)
                                    p(i,j) = bitshift(neigh(4)+neigh(3)*3+2,-2,'int64');
                                elseif(T==4)
                                    p(i,j)=neigh(1);
                                end
                            else
                                T = (i-1-4)*4 +(j-4);
                                if(T==1 || T==4 || T==6 || T==10 || T==15 || T==13 || T==5 || T==2 || T==11 || T==9 || T ==14)
                                    p(i,j) = neigh(1);
                                elseif(T==3 || T==12)
                                    p(i,j) = bitshift(neigh(1)+neigh(2)+1,-1,'int64');
                                elseif(T==16 || T==7)
                                    p(i,j) = bitshift(neigh(1)*3+neigh(2)+2,-2,'int64');
                                elseif(T==8)
                                    p(i,j) = bitshift(neigh(1)+neigh(2)*3+2,-2,'int64');
                                end
                            end
                        end
                        
                    end
                end
                pt = p';
                pred_x = pt(:)';
            case 6
                % 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
                % a b c d e f g h i j  k  l  m  n  o  p
                for i=1:8
                    for j=1:8
                        if(i<=4)
                            if(j<=4)
                                T = (i-1)*4+j;
                                if(T==5 || (T>=9 && T<=16 && T~=12))
                                    p(i,j) = neigh(3); 
                                elseif(T==1 || T==7)
                                    p(i,j) = bitshift(neigh(3)+neigh(7)+1,-1,'int64');
                                elseif(T==6 || T==12)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(7)+2,-2,'int64');
                                elseif(T==2 || T==8)
                                    p(i,j)= bitshift(neigh(3)+neigh(7)*2+neigh(1)+2,-2,'int64');
                                elseif(T==3)
                                    p(i,j)= bitshift(neigh(3)+neigh(1)*3+2,-2,'int64');
                                elseif(T==4)
                                    p(i,j)= neigh(3);
                                end
                            else
                                T = (i-1)*4+ (j-4);
                                if(T==1 || T==6 || T==7 || T==12)
                                    p(i,j) = neigh(1); 
                                elseif(T==2 || T==8)
                                    p(i,j) = bitshift(neigh(1)*3+neigh(2)+2,-2,'int64');
                                elseif(T==3)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(1)+2,-2,'int64');
                                elseif(T==4)
                                    p(i,j) = neigh(2); 
                                elseif(T==5 || T==11)
                                    p(i,j)= bitshift(neigh(1)*3+neigh(7)+2,-2,'int64');
                                elseif(T==9 || T==15)
                                    p(i,j)= bitshift(neigh(3)+neigh(7)+1,-1,'int64');
                                elseif(T==10 || T==16)
                                    p(i,j)= bitshift(neigh(3)+neigh(7)*2+neigh(1)+2,-2,'int64');
                                elseif(T==13)
                                    p(i,j)= neigh(3);
                                elseif(T==14)
                                     p(i,j)= bitshift(neigh(1)*3+neigh(7)+2,-2,'int64');
                                end
                            end
                        else
                            if(j<=4)
                                T = (i-1-4)*4+ (j);
                                if((T>=9 && T<=16 && T~=12) || T==5)
                                    p(i,j) = neigh(4); 
                                elseif(T==2 || T==8)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(4)+2,-2,'int64');
                                elseif(T==6 || T==12)
                                    p(i,j) = bitshift(neigh(4)*3+neigh(3)+2,-2,'int64');
                                elseif(T==1 || T==7)
                                    p(i,j)= bitshift(neigh(3)+neigh(4)+1,-1,'int64');
                                elseif(T==3 || T==4)
                                    p(i,j) = neigh(3); 
                                end
                            else
                                T = (i-1-4)*4 +(j-4);
                                if((T>=1 && T<=12 && T~=10 && T~=4 && T~=9))
                                    p(i,j) = neigh(3);
                                elseif(T==4 || T==10 || T==16)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(4)+2,-2,'int64');
                                elseif(T==9 || T==15)
                                    p(i,j)= bitshift(neigh(3)+neigh(4)+1,-1,'int64');
                                elseif(T==14)
                                    p(i,j) = bitshift(neigh(4)*3+neigh(3)+2,-2,'int64');
                                end 
                            end
                        end     
                    end
                end
                pt = p';
                pred_x = pt(:)';
            case 7
                for i=1:8
                    for j=1:8
                        if(i<=4)
                            if(j<=4)
                                T = (i-1)*4+j;
                                if(T<=3 || T==5 || T==6 || T==9 || T==10 || T==13)
                                    p(i,j) = neigh(1); 
                                elseif(T==4 || T==11)
                                    p(i,j) = bitshift(neigh(1)+neigh(2)+1,-1,'int64');
                                elseif(T==7 || T==14)
                                    p(i,j) = bitshift(neigh(1)*3+neigh(2)+2,-2,'int64');
                                elseif(T==12 || T==16)
                                    p(i,j)=neigh(2);
                                elseif(T==15 || T==8)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(1)+2,-2,'int64');
                                end
                            else
                                T = (i-1)*4+ (j-4);
                                if(T<=3 || T==5 || T==6 || T==9 || T==10 || T==13)
                                    p(i,j) = neigh(2); 
                                elseif(T==4 || T==11)
                                    p(i,j) = bitshift(neigh(2)+neigh(5)+1,-1,'int64');
                                elseif(T==7 || T==14)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(5)+2,-2,'int64');
                                elseif(T==12 || T==16)
                                    p(i,j)=neigh(5);
                                elseif(T==15 || T==8)
                                    p(i,j) = bitshift(neigh(5)*3+neigh(2)+2,-2,'int64');
                                end
                            end
                        else
                            if(j<=4)
                                T = (i-1-4)*4+ (j);
                                if(T==3 || T==4 || T==7 || T==8 || (T>=10 && T<=15 && T~=13))
                                    p(i,j) = neigh(2);
                                elseif(T==2 || T==9)
                                    p(i,j) = bitshift(neigh(1)+neigh(2)+1,-1,'int64');
                                elseif(T==5 || T==13)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(1)+2,-2,'int64');
                                elseif(T==6)
                                    p(i,j) = bitshift(neigh(1)*3+neigh(2)+2,-2,'int64');
                                elseif(T==16)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(5)+2,-2,'int64');
                                elseif(T==1)
                                    p(i,j)=neigh(1);
                                end
                            else
                                T = (i-1-4)*4 +(j-4);
                                if(T==3 || T==4 || T==7 || T==8 || (T>=10 && T<=15 && T~=13))
                                    p(i,j) = neigh(5);
                                elseif(T==2 || T==9)
                                    p(i,j) = bitshift(neigh(2)+neigh(5)+1,-1,'int64');
                                elseif(T==5 || T==13)
                                    p(i,j) = bitshift(neigh(5)*3+neigh(2)+2,-2,'int64');
                                elseif(T==6)
                                    p(i,j) = bitshift(neigh(2)*3+neigh(5)+2,-2,'int64');
                                elseif(T==16)
                                    p(i,j) = bitshift(neigh(5)*3+neigh(6)+2,-2,'int64');
                                elseif(T==1)
                                    p(i,j)=neigh(2);
                                end 
                            end
                        end
                        
                    end
                end
                pt = p';
                pred_x = pt(:)';
            case 8  %Horizontal Up
                for i=1:8
                    for j=1:8
                        if(i<=4)
                            if(j<=4)
                                T = (i-1)*4+j;
                                if(T>=1 && T<=9 && T~=8)
                                    p(i,j) = neigh(3); 
                                elseif(T>=15)
                                    p(i,j) = neigh(4); 
                                elseif(T==8 || T==10)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(4)+2,-2,'int64');
                                elseif(T==12 || T==14)
                                    p(i,j)= bitshift(neigh(4)*3+neigh(3)+2,-2,'int64');
                                elseif(T==11 || T==13)
                                    p(i,j) = bitshift(neigh(3)+neigh(4)+1,-1,'int64');
                                end
                            else
                                T = (i-1)*4+ (j-4);
                                if(T>=7)
                                    p(i,j) = neigh(4); 
                                elseif(T==3 || T==4)
                                     p(i,j) = bitshift(neigh(3)+neigh(4)+1,-1,'int64');
                                elseif(T==2)
                                    p(i,j) = bitshift(neigh(3)*3+neigh(4)+2,-2,'int64');
                                elseif(T==4 || T==6)
                                    p(i,j)= bitshift(neigh(4)*3+neigh(3)+2,-2,'int64');
                                elseif(T==1)
                                    p(i,j) = neigh(1); 
                                end
                            end
                        else
                            p(i,j) = neigh(4);
                        end
                    end
                end
                pt = p';
                pred_x = pt(:)';
        end
    elseif(N==16)
        switch mode
            case -1
                pred_x(1:n) = midValue;
            case 0
                pred_x(1:N:n)= neigh(1);
                pred_x(2:N:n)= neigh(1);
                pred_x(3:N:n)= bitshift((neigh(1)*3+neigh(2))+2,-2,'int64');
                pred_x(4:N:n)= bitshift((neigh(1)+neigh(2))+1,-1,'int64');
                pred_x(5:N:n)= bitshift((neigh(1)+neigh(2))+1,-1,'int64');
                pred_x(6:N:n) = bitshift((neigh(2)*3+neigh(1))+2,-2,'int64');
                pred_x(7:N:n)= neigh(2);
                pred_x(8:N:n)= neigh(2);
                
                pred_x(1+8:N:n)= neigh(3);
                pred_x(2+8:N:n)= neigh(3);
                pred_x(3+8:N:n)= bitshift((neigh(3)*3+neigh(4))+2,-2,'int64');
                pred_x(4+8:N:n)= bitshift((neigh(3)+neigh(4))+1,-1,'int64');
                pred_x(5+8:N:n)= bitshift((neigh(3)+neigh(4))+1,-1,'int64');
                pred_x(6+8:N:n) = bitshift((neigh(4)*3+neigh(3))+2,-2,'int64');
                pred_x(7+8:N:n)= neigh(4);
                pred_x(8+8:N:n)= neigh(4);
            case 1
                pred_x(1:2*N) = neigh(5);
                pred_x(2*N+1:3*N) = bitshift((neigh(5)*3+neigh(6))+2,-2,'int64');
                pred_x(3*N+1:5*N) = bitshift(neigh(5)+neigh(6)+1,-1,'int64');
                pred_x(5*N+1:6*N) = bitshift((neigh(6)*3+neigh(5))+2,-2,'int64');
                pred_x(6*N+1:8*N) = neigh(6);
                
                pred_x(8*N+1:10*N) = neigh(7);
                pred_x(10*N+1:11*N) = bitshift((neigh(7)*3+neigh(8))+2,-2,'int64');
                pred_x(11*N+1:13*N) = bitshift(neigh(7)+neigh(8)+1,-1,'int64');
                pred_x(13*N+1:14*N) = bitshift((neigh(8)*3+neigh(7))+2,-2,'int64');
                pred_x(14*N+1:16*N) = neigh(8);
            case 2
                pred_x = zeros(1,n)+bitshift((neigh(1)+neigh(2)+neigh(3)+neigh(4))+neigh(5)+neigh(6)+neigh(7)+neigh(8)+4,-3,'int64');
            case 3
                for i=1:16
                    for j=1:16
                        if(i+j<=5)
                            p(i,j)=neigh(1);
                        elseif(i+j<=9)
                            p(i,j)= neigh(2);
                        elseif(i+j<=13)
                            p(i,j)=neigh(3);
                        elseif(i+j<=17)
                            p(i,j)=neigh(4);
                        elseif(i+j<=21)
                            p(i,j)=neigh(9);
                        elseif(i+j<=25)
                            p(i,j)= neigh(10);
                        elseif(i+j<=29)
                            p(i,j)=neigh(11);
                        else
                            p(i,j)=neigh(12);
                        end
                    end
                end
                pt = p';
                pred_x = pt(:)';
            case 4
               for i=1:16
                   for j=1:16
                        if(j>i) 
                            if(j-i>=12 && j>=13)
                                p(i,j)=neigh(4);
                            elseif(j-i>=8 && j>=9)
                                p(i,j)=neigh(3);
                            elseif(j-i>=4 && j>=5)
                               p(i,j)=neigh(2);
                           else
                               p(i,j)=neigh(1);
                           end
                        elseif(j<i)
                            if(i-j>=12)
                                p(i,j)=neigh(8);
                            elseif(i-j>=8)
                                p(i,j)=neigh(7);
                            elseif(i-j>=4)
                                p(i,j)=neigh(6);
                            else
                                p(i,j)=neigh(5);
                            end
                        else
                            p(i,j)= bitshift((neigh(13)*2+neigh(1)+neigh(5))+2,-2,'int64');
                        end 
                   end
               end
                pt = p';
                pred_x = pt(:)';
        end
end