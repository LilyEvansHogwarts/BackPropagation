function result = upsampling(x,x_size)
shape = size(x);
result = zeros(shape(1,1),x_size * 2,x_size * 2);
for i = 1:shape(1,1)
	for j = 1:x_size
		for k = 1:x_size
			result(i, 2*j-1:2*j, 2*k-1:2*k) = x(i,j,k);
		end
	end
end
