function result = meanpooling(x)
[x_size,x_size,channel] = size(x);
result = zeros(x_size/2,x_size/2,channel);
for k = 1:channel
	for i = 1:(x_size / 2)
		for j = 1:(x_size / 2)
			result(i,j,k) = sum(sum(x(2*i-1:2*i,2*j-1:2*j,k))') / 4;
		end
	end
end
