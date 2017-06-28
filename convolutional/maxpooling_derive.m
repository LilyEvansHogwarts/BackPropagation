function result = maxpooling_derive(derive,location)
[derive_size,derive_size,channel] = size(derive);
result = zeros(derive_size * 2,derive_size * 2,channel);
for i = 1:channel
	for j = 1:derive_size
		for k = 1:derive_size
			result(2*j-1:2*j,2*k-1:2*k,i) = derive(j,k,i);
		end
	end
	result(:,:,i) = location(:,:,i) .* result(:,:,i);
end
