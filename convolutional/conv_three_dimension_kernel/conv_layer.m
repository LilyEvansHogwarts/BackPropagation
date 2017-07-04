function result = conv_layer(data,kernel,biases)
[image_size,image_size,input_channel] = size(data);
[kernel_size,kernel_size,output_channel] = size(kernel);
result = zeros(image_size,image_size,output_channel);
for i = 1:output_channel
	for j = 1:input_channel
		result(:,:,i) = result(:,:,i) + conv2(data(:,:,j),kernel(:,:,i),'same');
	end
	result(:,:,i) = result(:,:,i) + biases(1,i);
end


