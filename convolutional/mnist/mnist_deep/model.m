format long;

load('test_dataset.mat');
load('test_label.mat');

test_size = 10000;
image_size = 28;

conv1_kernel_size = 5;
conv1_kernel_num = 32;
conv1_kernel = 0.1 * randn(conv1_kernel_size,conv1_kernel_size,conv1_kernel_num);
conv1_biases = 0.1 * ones(1,conv1_kernel_num);

conv2_kernel_size = 5;
conv2_kernel_num = 64;
conv2_kernel = 0.1 * randn(conv2_kernel_size,conv2_kernel_size,conv2_kernel_num);
conv2_biases = 0.1 * ones(1,conv2_kernel_num);

fc1_size = 1024;
fc1_weights = 0.1 * randn(fc1_size,image_size/4 * image_size/4 * conv2_kernel_num);
fc1_biases = 0.1 * ones(fc1_size,1);

num_classes = 10;
fc2_weights = 0.1 * randn(num_classes,fc1_size);
fc2_biases = 0.1 * ones(num_classes,1);

for i = 1:test_size
	data = reshape(test_dataset(:,:,i),image_size,image_size,1);
	conv1_out = relu(conv_layer(data,conv1_kernel,conv1_biases));
	[conv1_pooling,conv1_location] = maxpooling(conv1_out);

	conv2_out = relu(conv_layer(conv1_pooling,conv2_kernel,conv2_biases));
	[conv2_pooling,conv2_location] = maxpooling(conv2_out);

	fc1_input = reshape(conv2_pooling,image_size/4 * image_size/4 * conv2_kernel_num,1);
	fc1_out = relu(fc1_weights * fc1_input + fc1_biases);

	fc2_out = fc2_weights * fc1_out + fc2_biases;

	[loss,logits,derive_fc2_biases] = softmax_cross_entropy(fc2_out,test_label(:,i),num_classes);
	derive_fc2_weights = derive_fc2_biases * fc1_out';
	derive_fc2_input = fc2_weights' * derive_fc2_biases;

	derive_fc1_biases = derive_fc2_input .* relu_derive(fc1_out);
	derive_fc1_weights = derive_fc1_biases * fc1_input';
	derive_fc1_input = fc1_weights' * derive_fc1_biases;
	
	fc2_biases = fc2_biases - learning_rate * derive_fc2_biases;
	fc2_weights = fc2_weights - learning_rate * derive_fc2_weights;

	fc1_biases = fc1_biases - learning_rate * derive_fc1_biases;
	fc1_weights = fc1_weights - learning_rate * derive_fc1_weights;

	derive_conv2_out = reshape(derive_fc1_input,image_size/4,image_size/4,conv2_kernel_num);
	conv2_theta = maxpooling_derive(derive_conv2_out,conv2_location) .* relu_derive(conv2_out);
	derive_conv2_biases = biases_derive(conv2_theta);
	derive_conv2_kernel = kernel_derive(conv2_theta);
	derive_conv2_input = input_derive(conv2_theta,conv2_kernel);

	conv1_theta = maxpooling_derive(derive_conv2_input,conv1_location) .* relu_derive(conv1_out);
	derive_conv1_biases = biases_derive(conv1_theta);
	derive_conv1_kernel = kernel_derive(conv1_theta);


