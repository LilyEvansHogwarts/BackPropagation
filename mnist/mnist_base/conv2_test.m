%format long;
%load('train_dataset.mat');
%load('train_label.mat');
load('test_dataset.mat');
load('test_label.mat');

train_size = 200000;
test_size = 10000;
num_classes = 10;
image_size = 28;
image_channel = 1;
learning_rate = 0.005;
%%%%% conv1

conv1_input_channel = image_channel;
conv1_kernel_size = 5;
conv1_output_channel = 16;

conv1_kernel = 0.1 * randn(conv1_kernel_size,conv1_kernel_size,conv1_input_channel,conv1_output_channel);
conv1_biases = 0.1 * ones(1,conv1_output_channel);

conv2_input_channel = conv1_output_channel;
conv2_kernel_size = 5;
conv2_output_channel = 16;

conv2_kernel = 0.1 * randn(conv2_kernel_size,conv2_kernel_size,conv2_input_channel,conv2_output_channel);
conv2_biases = 0.1 * ones(1,conv2_output_channel);

num_fc1 = 64;
fc1_weights = 0.1 * randn(num_fc1,image_size/4 * image_size/4 * conv2_output_channel);
fc1_biases = 0.1 * ones(num_fc1,1);

fc2_weights = 0.1 * randn(num_classes,num_fc1);
fc2_biases = 0.1 * ones(num_classes,1);

accuracy = 0;
loss_sum = 0;


for i = 1:test_size
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
	[loss, logits, derive_fc2_biases] = softmax_cross_entropy(fc2_output,test_label(:,i),num_classes);
	loss_sum = loss_sum + loss;
	[arg,max_label] = max(test_label(:,i));
	[arg,max_train] = max(fc2_output);
	accuracy = accuracy + (max_label == max_train);
	if mod(i,100) == 0
		loss_sum 
		loss_sum = 0;
		accuracy = accuracy / 100
		accuracy = 0;
	end
	derive_fc2_input = fc2_weights' * derive_fc2_biases;
	derive_fc2_weights = derive_fc2_biases * fc2_input';

	derive_fc1_biases = derive_fc2_input .* relu_derive(fc2_input);
	derive_fc1_input = fc1_weights' * derive_fc1_biases;
	derive_fc1_weights = derive_fc1_biases * fc1_input';

	derive_conv_out = reshape(derive_fc1_input,image_size/4,image_size/4,conv2_output_channel);
	derive_conv_pooling = derive_conv_out .* relu_derive(conv_output);

	conv2_theta = maxpooling_derive(derive_conv_pooling,conv2_pooling_location);
	derive_conv2_biases = biases_derive(conv2_theta);
	derive_conv2_kernel = kernel_derive(conv2_input,conv2_theta,conv2_kernel_size);
	derive_conv2_input = input_derive(conv2_theta,conv2_kernel);
	
	derive_conv1_pooling = derive_conv2_input .* relu_derive(conv2_input);
	conv1_theta = maxpooling_derive(derive_conv1_pooling,conv1_pooling_location);
	derive_conv1_biases = biases_derive(conv1_theta);
	derive_conv1_kernel = kernel_derive(data,conv1_theta,conv1_kernel_size);

	%%update
	fc2_biases = fc2_biases - learning_rate * derive_fc2_biases;
	fc2_weights = fc2_weights - learning_rate * derive_fc2_weights;
	fc1_biases = fc1_biases - learning_rate * derive_fc1_biases;
	fc1_weights = fc1_weights - learning_rate * derive_fc1_weights;
	conv2_biases = conv2_biases - learning_rate * derive_conv2_biases;
	conv2_kernel = conv2_kernel - learning_rate * derive_conv2_kernel;
	conv1_biases = conv1_biases - learning_rate * derive_conv1_biases;
	conv1_kernel = conv1_kernel - learning_rate * derive_conv1_kernel;

end


%{
for j = 1:20
	for i = 1:test_size
		% forward
		%conv1
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

		%backpropagation
		[loss, logits, derive_fc2_biases] = softmax_cross_entropy(fc2_output,test_label(:,i),num_classes);
		loss_sum = loss_sum + loss;
		[arg,max_label] = max(test_label(:,i));
		[arg,max_train] = max(fc2_output);
		accuracy = accuracy + (max_label == max_train);
		if mod(i,100) == 0
			loss_sum 
			loss_sum = 0;
			accuracy = accuracy / 100
			accuracy = 0;
		end
		derive_fc2_input = fc2_weights' * derive_fc2_biases;
		derive_fc2_weights = derive_fc2_biases * fc2_input';

		derive_fc1_biases = derive_fc2_input .* relu_derive(fc2_input);
		derive_fc1_input = fc1_weights' * derive_fc1_biases;
		derive_fc1_weights = derive_fc1_biases * fc1_input';

		derive_conv_out = reshape(derive_fc1_input,image_size/4,image_size/4,conv2_output_channel);
		derive_conv_pooling = derive_conv_out .* relu_derive(conv_output);

		conv2_theta = maxpooling_derive(derive_conv_pooling,conv2_pooling_location);
		derive_conv2_biases = biases_derive(conv2_theta);
		derive_conv2_kernel = kernel_derive(conv2_input,conv2_theta,conv2_kernel_size);
		derive_conv2_input = input_derive(conv2_theta,conv2_kernel);
	
		derive_conv1_pooling = derive_conv2_input .* relu_derive(conv2_input);
		conv1_theta = maxpooling_derive(derive_conv1_pooling,conv1_pooling_location);
		derive_conv1_biases = biases_derive(conv1_theta);
		derive_conv1_kernel = kernel_derive(data,conv1_theta,conv1_kernel_size);

		%%update
		fc2_biases = fc2_biases - learning_rate * derive_fc2_biases;
		fc2_weights = fc2_weights - learning_rate * derive_fc2_weights;
		fc1_biases = fc1_biases - learning_rate * derive_fc1_biases;
		fc1_weights = fc1_weights - learning_rate * derive_fc1_weights;
		conv2_biases = conv2_biases - learning_rate * derive_conv2_biases;
		conv2_kernel = conv2_kernel - learning_rate * derive_conv2_kernel;
		conv1_biases = conv1_biases - learning_rate * derive_conv1_biases;
		conv1_kernel = conv1_kernel - learning_rate * derive_conv1_kernel;

	end
end
%}


accuracy = 0;
loss_sum = 0;
for i = 1:test_size
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
	loss_sum = loss_sum + loss;
	[arg,max_label] = max(test_label(:,i));
	[arg,max_train] = max(fc2_output);
	accuracy = accuracy + (max_label == max_train);
end
loss_sum
accuracy


