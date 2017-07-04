load('test_dataset.mat');
load('test_label.mat');

test_size = 10000;
num_classes = 10;
image_channel = 1;
image_size = 28;
learning_rate = 0.005;

%initial conv1
conv1_kernel_size = 5;
conv1_kernel_num = 16;
conv1_kernel = rand(conv1_kernel_size,conv1_kernel_size,conv1_kernel_num);
conv1_biases = rand(1,conv1_kernel_num);

%initial conv2
conv2_kernel_size = 5;
conv2_kernel_num = 16;
conv2_kernel = rand(conv2_kernel_size,conv2_kernel_size,conv2_kernel_num);
conv2_biases = rand(1,conv2_kernel_num);

%initial fc1
num_fc1 = 64;
fc1_weights = rand(num_fc1,image_size / 4 * image_size / 4 * conv2_kernel_num);
fc1_biases = rand(num_fc1,1);

%initial fc2
fc2_weights = rand(num_classes,num_fc1);
fc2_biases = rand(num_classes,1);

loss_sum = 0;
accuracy = 0;

for i = 1:test_size
	data = reshape(test_dataset(:,:,i),image_size,image_size,image_channel);
	conv1_out = conv_layer(data,conv1_kernel,conv1_biases);
	[conv1_pooling_out,conv1_pooling_location] = maxpooling(conv1_out);
	conv2_input = relu(conv1_pooling_out);

	conv2_out = conv_layer(conv2_input,conv2_kernel,conv2_biases);
	[conv2_pooling_out,conv2_pooling_location] = maxpooling(conv2_out);
	conv_out = relu(conv2_pooling_out);
	fc1_input = reshape(conv_out,image_size/4 * image_size/4 * conv2_kernel_num,1);

	fc1_out = fc1_weights * fc1_input + fc1_biases;
	fc2_input = relu(fc1_out);

	fc2_out = fc2_weights * fc2_input + fc2_biases;

	[loss,logits,derive_fc2_biases] = softmax_cross_entropy(fc2_out,test_label(:,i),num_classes);
	loss_sum = loss_sum + loss;
	[arg,max_label] = max(test_label(:,i));
	[arg,max_train] = max(logits);
	accuracy = accuracy + (max_label == max_train);
	if mod(i,100) == 0
		loss_sum
		loss_sum = 0;
		accuracy = accuracy / 100
		accuracy = 0;
	end
	derive_fc2_weights = derive_fc2_biases * fc2_input';
	derive_fc2_input = fc2_weights' * derive_fc2_biases;

	derive_fc1_biases = derive_fc2_input .* relu_derive(fc2_input);
	derive_fc1_input = fc1_weights' * derive_fc1_biases;
	derive_fc1_weights = derive_fc1_biases * fc1_input';

	derive_conv_out = reshape(derive_fc1_input,image_size/4,image_size/4,conv2_kernel_num);
	derive_conv_pooling = derive_conv_out .* relu_derive(conv_out);

	conv2_theta = maxpooling_derive(derive_conv_pooling,conv2_pooling_location);
	derive_conv2_biases = biases_derive(conv2_theta);
	derive_conv2_kernel = kernel_derive(conv2_input,conv2_theta,conv2_kernel_size);
	derive_conv2_input = input_derive(conv2_theta,conv2_kernel,conv1_kernel_num);

	derive_conv1_pooling = derive_conv2_input .* relu_derive(conv2_input);
	conv1_theta = maxpooling_derive(derive_conv1_pooling,conv1_pooling_location);
	derive_conv1_biases = biases_derive(conv1_theta);
	derive_conv1_kernel = kernel_derive(data,conv1_theta,conv1_kernel_size);

	fc2_biases = fc2_biases - learning_rate * derive_fc2_biases;
	fc2_weights = fc2_weights - learning_rate * derive_fc2_weights;
	fc1_biases = fc1_biases - learning_rate * derive_fc1_biases;
	fc1_weights = fc1_weights - learning_rate * derive_fc1_weights;
	conv2_biases = conv2_biases - learning_rate * derive_conv2_biases;
	conv2_kernel = conv2_kernel - learning_rate * derive_conv2_kernel;
	conv1_biases = conv1_biases - learning_rate * derive_conv1_biases;
	conv1_kernel = conv1_kernel - learning_rate * derive_conv1_kernel;
end
