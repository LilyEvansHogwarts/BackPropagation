function result = biases_derive(conv2_theta)
[theta_size,theta_size,channel] = size(conv2_theta);
result = zeros(1,channel);
for i = 1:channel
	result(1,i) = sum(sum(conv2_theta(:,:,i)),2);
end

