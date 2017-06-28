function result = meanpooling(x,x_size)
result = zeros(x_size / 2);
for i = 1:(x_size / 2)
	for j = 1:(x_size / 2)
		result(i,j) = sum(sum(x(2*i-1:2*i,2*j-1:2*j))') / 4;
	end
end
