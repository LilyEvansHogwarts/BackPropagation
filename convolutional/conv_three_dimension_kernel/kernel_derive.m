function result = kernel_derive(x,theta,kernel_size)
y = padding(x,kernel_size);
[x_size,x_size,input_channel] = size(y);
[theta_size,theta_size,output_channel] = size(theta);
result = zeros(kernel_size,kernel_size,output_channel);
for i = 1:output_channel
	for j = 1:input_channel
		result(:,:,i) = result(:,:,i) + rot90(conv2(y(:,:,j),rot90(theta(:,:,i),2),'valid'),2);
	end
end
