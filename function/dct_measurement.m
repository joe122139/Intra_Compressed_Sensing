function A = dct_measurement (m1)
	[N N] = size(m1);
m2 = m1';
for i=1:N
		for j = 1:N
			for q=1:N
				for k=1:N
					A((i-1)*N+j,(k-1)*N+q) = m1(i,k)*m2(q,j);
				end
			end
		end
	end
end