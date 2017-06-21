function [pooling_result,pooling_location] = maxpooling(x,x_size)
pooling_result = zeros(x_size / 2);
pooling_location = zeros(x_size);
for i = 1:(x_size / 2)
	for j = 1:(x_size / 2)
		[arg,x_po] = max(x(2*i-1:2*i, 2*j-1:2*j));
		[arg,y_po] = max(arg);
		x_po = x_po(y_po) + 2*i - 2;
		y_po = y_po + 2*j - 2;
		pooling_result(i,j) = arg;
		pooling_location(x_po,y_po) = 1;
	end
end
