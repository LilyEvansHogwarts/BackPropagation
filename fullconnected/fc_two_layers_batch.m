%load('train_dataset.mat');
%load('train_label.mat');

train_size = 200000;
valid_size = 10000;
test_size = 10000;
num_classes = 10;
image_size = 28;
num_hidden = 64;

%train_dataset = reshape(train_dataset,train_size,image_size * image_size);

fc1_weights = rand(image_size * image_size, num_hidden);
fc1_biases = rand(1, num_hidden);
fc2_weights = rand(num_hidden, num_classes);
fc2_biases = rand(1, num_classes);
learning_rate = 0.5;
loss_sum = 0;
derive_fc1_weights_sum = 0;
derive_fc1_biases_sum = 0;
derive_fc2_weights_sum = 0;
derive_fc2_biases_sum = 0;
accuracy = 0;
batch_size = 16;
batch_pass = 2000;


for j = 1:batch_pass
	offset = mod((j-1) * batch_size + 1,train_size - batch_size - 1);
	for i = offset:(offset + batch_size) 
		fc1_output = train_dataset(i, :, :) * fc1_weights + fc1_biases;
		normal1 = norm(fc1_output);
		fc2_input = fc1_output / normal1;
		fc2_output = fc2_input * fc2_weights + fc2_biases;
		normal2 = norm(fc2_output);
		logits = softmax(fc2_output / normal2);
		loss = sum((train_label(i,:) - logits) .* (train_label(i,:) - logits)) / 2;
		loss_sum = loss_sum + loss;
		[arg,argmax_logits] = max(logits);
		[arg,argmax_label] = max(train_label(i,:));
		accuracy = accuracy + (argmax_logits == argmax_label);
		derive_fc2_biases = (logits - train_label(i,:)) .* logits .* (1 - logits);
		derive_fc2_weights = fc2_input' * derive_fc2_biases;
		derive_fc1_biases = derive_fc2_biases * fc2_weights';
		derive_fc1_weights = train_dataset(i,:,:)' * derive_fc1_biases;

		derive_fc1_biases_sum = derive_fc1_biases_sum + derive_fc1_biases;
		derive_fc1_weights_sum = derive_fc1_weights_sum + derive_fc1_weights;
		derive_fc2_biases_sum = derive_fc2_biases_sum + derive_fc2_biases;
		derive_fc2_weights_sum = derive_fc2_weights_sum + derive_fc2_weights;
	end
	fc2_weights = fc2_weights - learning_rate * derive_fc2_weights_sum;
	fc2_biases = fc2_biases - learning_rate * derive_fc2_biases_sum;
	fc1_weights = fc1_weights - learning_rate * derive_fc1_weights_sum;
	fc1_biases =fc1_biases - learning_rate * derive_fc1_biases_sum;
	derive_fc1_weights_sum = 0;
	derive_fc1_biases_sum = 0;
	derive_fc2_weights_sum = 0;
	derive_fc2_biases_sum = 0;
	if mod(j,100) == 0
		loss_sum 
		loss_sum = 0;
		accuracy = accuracy / 1600
		accuracy = 0;
	end
	if mod(j,200) == 0
		learning_rate = learning_rate * 0.707;
	end
end

accuracy = 0;
for i = 1:train_size
	fc2_input = train_dataset(i,:,:) * fc1_weights + fc1_biases;
	fc2_output = fc2_input * fc2_weights + fc2_biases;
	normal = norm(fc2_output);
	logits = softmax(fc2_output / normal);
	[arg, argmax_logits] = max(logits);
	[arg, argmax_label] = max(train_label(i,:));
	accuracy = accuracy + (argmax_logits == argmax_label);
end
train_accuracy = accuracy / train_size
