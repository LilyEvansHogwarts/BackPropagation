function result = kernel_derive(x,theta,kernel_size)
y = padding(x,kernel_size);
[x_size,x_size,input_channel] = size(y);
[theta_size,theta_size,output_channel] = size(theta);
result = zeros(kernel_size,kernel_size,input_channel,output_channel);
for i = 1:input_channel
	for j = 1:output_channel
		result(:,:,i,j) = rot90(conv2(y(:,:,i),rot90(theta(:,:,j),2),'valid'),2);
	end
end
