function result = padding(x,kernel_size)
[x_size,x_size,channel] = size(x);
result_size = x_size + kernel_size - 1;
result = zeros(result_size,result_size,channel);
start_x = (kernel_size + 1) / 2;
end_x = x_size + (kernel_size - 1) / 2;
result(start_x:end_x,start_x:end_x,:) = x;
