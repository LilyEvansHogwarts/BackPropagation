load('test_dataset.mat');
load('test_label.mat');

train_size = 200000;
valid_size = 10000;
test_size = 10000;
num_classes = 10;
image_size = 28;

test_dataset = reshape(test_dataset, test_size, image_size * image_size);

weights = rand(image_size * image_size, num_classes);
biases = rand(1, num_classes);
learning_rate = 0.5;
loss_sum = 0;
derive_biases_sum = 0;
derive_weights_sum = 0;
accuracy = 0;
batch_size = 16;
batch_pass = 1100;
for j = 1:batch_pass
	offset = mod((j * batch_size),(test_size - batch_size - 1))
	for i = offset:(offset + batch_size)
		logits = softmax(test_dataset(i, :, :) * weights + biases);
		loss = sum((test_label(i,:) - logits) .* (test_label(i,:) - logits)) / 2;
		loss_sum = loss_sum + loss;
		[arg,argmax_logits] = max(logits);
		[arg,argmax_label] = max(test_label(i,:));
		accuracy = accuracy + (argmax_logits == argmax_label);
		derive_biases = (logits - test_label(i,:)) .* logits .* (1 - logits);
		derive_weights = test_dataset(i,:,:)' * derive_biases;
		derive_biases_sum = derive_biases_sum + derive_biases;
		derive_weights_sum = derive_weights_sum + derive_weights;
	end
	loss_sum
	accuracy = accuracy / batch_size
	loss_sum = 0;
	accuracy = 0;
	weights = weights - learning_rate * derive_weights_sum;
	biases = biases - learning_rate * derive_biases_sum;
	derive_biases_sum = 0;
	derive_weights_sum = 0;
	if mod(j, 200) == 0
		learning_rate = learning_rate * 0.707;
	end
end

accuracy = 0;
for i = 1:test_size
	logits = softmax(test_dataset(i,:,:) * weights + biases);
	[arg, argmax_logits] = max(logits);
	[arg, argmax_label] = max(test_label(i,:));
	accuracy = accuracy + (argmax_logits == argmax_label);
end
test_accuracy = accuracy / test_size
