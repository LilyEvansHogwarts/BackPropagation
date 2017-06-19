load('test_dataset.mat');
load('test_label.mat');

test_size = 10000;
num_classes = 10;
image_size = 28;

num_conv1_kernel = 16;
num_conv2_kernel = 16;
num_hidden = 64;
kernel_size = 5;
learning_rate = 0.05;

conv1_kernel = rand(num_conv1_kernel, kernel_size, kernel_size);
conv1_biases = rand(1,num_conv1_kernel);
conv1_out = zeros(num_conv1_kernel, image_size, image_size);
conv1_pooling = zeros(num_conv1_kernel, image_size/2, image_size/2);
%conv2_kernel = rand(num_conv2_kernel, kernel_size, kernel_size);

fc1_weights = rand(num_conv1_kernel * image_size/2 * image_size/2,num_hidden);
fc1_biases = rand(1,num_hidden);

fc2_weights = rand(num_hidden, num_classes);
fc2_biases = rand(1,num_classes);

loss_sum = 0;
accuracy = 0;

derive_conv1_biases = zeros(1,num_conv1_kernel);
derive_conv1_kernel = zeros(num_conv1_kernel,kernel_size,kernel_size);

for i = 1:test_size
	data = reshape(test_dataset(i,:,:), image_size,image_size);
	%conv1
	for num_conv1 = 1:num_conv1_kernel
		kernel = reshape(conv1_kernel(num_conv1,:,:),kernel_size,kernel_size);
		conv1_o = conv2(data,kernel,'same') + conv1_biases(1,num_conv1);
		conv1_out(num_conv1,:,:) = conv1_o;
		conv1_pooling(num_conv1,:,:) = pooling(conv1_o,image_size);
	end
	fc_input = reshape(conv1_pooling,1,num_conv1_kernel * image_size/2 * image_size/2);
	fc1_out = fc_input * fc1_weights + fc1_biases;
	normal1 = norm(fc1_out);

	fc2_input = fc1_out / normal1;
	fc2_out = fc1_out * fc2_weights + fc2_biases;
    normal2 = norm(fc2_out);

	logits = softmax(fc2_out);
	loss = sum((test_label(i,:) - logits) .* (test_label(i,:) - logits)) / 2;
	loss_sum = loss_sum + loss;
	[arg,argmax_logits] = max(logits);
	[arg,argmax_label] = max(test_label(i,:,:));
	accuracy = accuracy + (argmax_logits == argmax_label);


	derive_fc2_biases = (logits - test_label(i,:)) .* logits .* (1 - logits) / normal2;
	derive_fc2_weights = fc1_out' * derive_fc2_biases;
	derive_fc1_biases = derive_fc2_biases * fc2_weights' / normal1;
	derive_fc1_weights = fc_input' * derive_fc1_biases; 
	derive_fc_input = derive_fc1_biases * fc1_weights';

	fc2_biases = fc2_biases - learning_rate * derive_fc2_biases;
	fc2_weights = fc2_weights - learning_rate * derive_fc2_weights;
	fc1_biases = fc1_biases - learning_rate * derive_fc1_biases;
	fc1_weights = fc1_weights - learning_rate * derive_fc1_weights;

	derive_pooling = upsampling(reshape(derive_fc_input, num_conv1_kernel, image_size/2, image_size/2), image_size / 2);
	for num_conv1 = 1:num_conv1_kernel
		pooling_derive = reshape(derive_pooling(num_conv1,:,:),image_size,image_size);
		derive_conv1_biases(1,num_conv1) = sum(sum(pooling_derive)');
		derive_conv1_kernel(num_conv1,:,:) = rot90(conv2(padding(data,image_size,kernel_size),rot90(pooling_derive,2),'valid'),2);
	end
	conv1_biases = conv1_biases - learning_rate * derive_conv1_biases;
	conv1_kernel = conv1_kernel - learning_rate * derive_conv1_kernel;

	if mod(i,50) == 0
		loss_sum 
		loss_sum = 0;
		accuracy = accuracy / 50
		accuracy = 0;
	end
end


