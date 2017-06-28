%load('train_dataset.mat');
%load('train_label.mat');
load('test_dataset.mat');
load('test_label.mat');

train_size = 200000;
test_size = 10000;
num_classes = 10;
image_size = 28;
image_channel = 1;

%%%%% conv1

conv1_input_channel = image_channel;
conv1_kernel_size = 5;
conv1_output_channel = 16;

conv1_kernel = rand(conv1_kernel_size,conv1_kernel_size,conv1_input_channel,conv1_output_channel);
conv1_biases = rand(1,conv1_output_channel);

conv2_input_channel = conv1_output_channel;
conv2_kernel_size = 5;
conv2_output_channel = 16;

conv2_kernel = rand(conv2_kernel_size,conv2_kernel_size,conv2_input_channel,conv2_output_channel);
conv2_biases = rand(1,conv2_output_channel);

num_fc1 = 64;
fc1_weights = rand(num_fc1,image_size/4 * image_size/4 * conv2_output_channel);
fc1_biases = rand(num_fc1,1);

fc2_weights = rand(num_classes,num_fc1);
fc2_biases = rand(num_classes,1);

for i = 1:1
	% forward

	%%conv1
	%data = reshape(train_dataset(:,:,i),image_size,image_size,image_channel);
	data = reshape(test_dataset(:,:,i),image_size,image_size,image_channel);
	conv1_out = conv_layer(data,conv1_kernel,conv1_biases);
	[conv1_pooling_out, conv1_pooling_location] = maxpooling(conv1_out);
	conv2_input = relu(conv1_pooling_out);

	%conv2
	conv2_out = conv_layer(conv2_input,conv2_kernel,conv2_biases);
	[conv2_pooling_out,conv2_pooling_location] = maxpooling(conv2_out);
	conv_output = relu(conv2_pooling_out);

	%fc1
	fc1_input = reshape(conv_output,image_size/4 * image_size/4 * conv2_output_channel,1);
	fc1_output = fc1_weights * fc1_input + fc1_biases;

	%fc2
	fc2_input = relu(fc1_output);
	fc2_output = fc2_weights * fc2_input + fc2_biases;

	%%backpropagation
	%[loss, logits, derive_fc2_biases] = softmax_cross_entropy(fc2_output,train_label(:,i),num_classes);
	[loss, logits, derive_fc2_biases] = softmax_cross_entropy(fc2_output,test_label(:,i),num_classes);
	derive_fc2_input = fc2_weights' * derive_fc2_biases;
	derive_fc2_weights = derive_fc2_biases * fc2_input';

	derive_fc1_biases = derive_fc2_input .* relu_derive(fc2_input);
	derive_fc1_input = fc1_weights' * derive_fc1_biases;
	derive_fc1_weights = derive_fc1_biases * fc1_input';

	derive_conv_out = reshape(derive_fc1_input,image_size/4,image_size/4,conv2_output_channel);
	derive_conv_pooling = derive_conv_out .* relu_derive(conv_output);

	derive_conv2_biases = maxpooling(derive_conv_pooling,conv2_pooling_location);
	derive_conv2_biases




end

