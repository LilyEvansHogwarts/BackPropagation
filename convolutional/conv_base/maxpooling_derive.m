function result = maxpooling_derive(derive,derive_size,location)
%[derive_size,derive_size,channel] = size(derive);
result = zeros(derive_size * 2,derive_size * 2);
for j = 1:derive_size
	for k = 1:derive_size
		result(2*j-1:2*j,2*k-1:2*k) = derive(j,k);
	end
end
result = location .* result;
