figure(7)
[X,Y,Z] = sphere(16);
x = [0.5*X(:); 0.75*X(:); X(:)];
y = [0.5*Y(:); 0.75*Y(:); Y(:)];
z = [0.5*Z(:); 0.75*Z(:); Z(:)];
%Create vectors s and c to specify the size and color for each marker.

S = repmat([10,50,20],numel(X),1);
C = repmat([1,5,3],numel(X),1);
s = S(:);
c = C(:);
%Create a 3-D scatter plot and return the scatter series object.

h = scatter3(x,y,z,s,c);
%h = scatter3(x,y,z);
%view(40,35)