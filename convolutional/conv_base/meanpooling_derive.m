function result = meanpooling_derive(derive,derive_size)
shape = size(derive);
result = zeros(shape(1,1),derive_size * 2,derive_size * 2);
for i = 1:shape(1,1)
	for j = 1:derive_size
		for k = 1:derive_size
			result(i,2*j-1:2*j,2*k-1:2*k) = derive(i,j,k);
		end
	end
end
result = result / 4;
