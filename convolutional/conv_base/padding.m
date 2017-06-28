function result = padding(x,x_size,kernel_size)
result_size = x_size + kernel_size - 1;
result = zeros(result_size);
start_x = (kernel_size + 1) / 2;
end_x = x_size + (kernel_size - 1) / 2;
result(start_x:end_x,start_x:end_x) = x;
