function result = input_derive(theta,kernel)
[theta_size,theta_size,output_channel] = size(theta);
[kernel_size,kernel_size,input_channel,output_channel] = size(kernel);
result = zeros(theta_size,theta_size,input_channel);
for i = 1:input_channel
	for o = 1:output_channel
		result(:,:,i) = result(:,:,i) + conv2(theta(:,:,o),rot90(kernel(:,:,i,o),2),'same');
	end
end

