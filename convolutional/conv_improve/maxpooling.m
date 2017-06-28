function [pooling_result,pooling_location] = maxpooling(x)
[x_size,x_size,channel] = size(x);
pooling_result = zeros(x_size/2,x_size/2,channel);
pooling_location = zeros(x_size,x_size,channel);
for k = 1:channel
	for i = 1:(x_size/2)
		for j = 1:(x_size/2)
			[arg,x_po] = max(x(2*i-1:2*i, 2*j-1:2*j,k));
			[arg,y_po] = max(arg);
			x_po = x_po(y_po) + 2*i - 2;
			y_po = y_po + 2*j - 2;
			pooling_result(i,j,k) = arg;
			pooling_location(x_po,y_po,k) = 1;
		end
	end
end


