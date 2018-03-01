%Step:1
n=3
x=0:n-1;
N=size(x,2);
c=0
for n1=1:N
    for n2=1:N
        for n3=1:N
            c=c+1;
            cellz=n1-1;celly=n2-1;cellx=n3-1;
            confs_cell{n1,n2,n3}=[cellx celly cellz];
        end
    end
end
confs_cell=reshape(confs_cell,(n)^3, 1);
for i=size(confs_cell,1)
    points_all(i,1)=confs_cell{i}(1);
    points_all(i,2)=confs_cell{i}(2);
    points_all(i,3)=confs_cell{i}(3);
end
confs_size_all=size(points_all,1);
points_n = confs_cell;lines_n =confs_cell;
output_1 = points_all
%%step:2
multiplication_matrix=zeros(size(lines_n,1),size(points_n,1));
for d=1:size(lines_n,1)
    for n=1:size(points_n,1)
        multiplication_matrix(d,n)=mod((lines_n{d}(1)*points_n{n}(1)+...
        lines_n{d}(2)*points_n{n}(2)+lines_n{d}*points_n{n}(3)),(n));
    end
end
multiplication_matrix(2:size(points_all,1),1)=(1:1:size(points_all,1)-1)';
multiplication_matrix(1,2:size(points_all,1))=(1:1:size(points_all,1))-1;
output_2 =multiplication_matrix

