%load('train_dataset.mat');
%load('train_label.mat');

train_size = 200000;
valid_size = 10000;
test_size = 10000;
num_classes = 10;
image_size = 28;

%train_dataset = reshape(train_dataset, train_size, image_size * image_size);

weights = rand(image_size * image_size, num_classes);
biases = rand(1, num_classes);
learning_rate = 0.5;
loss_sum = 0;
accuracy = 0;

for i = 1:train_size
	[loss,logits,derive_biases] = softmax_cross_entropy(train_dataset(i, :, :) * weights + biases,train_label(i,:),num_classes);
	%loss = sum((train_label(i,:) - logits) .* (train_label(i,:) - logits)) / 2;
	loss_sum = loss_sum + loss;
	[arg,argmax_logits] = max(logits);
	[arg,argmax_label] = max(train_label(i,:));
	accuracy = accuracy + (argmax_logits == argmax_label);
	if mod(i,500) == 0
		loss_sum
		accuracy = accuracy / 500
		loss_sum = 0;
		accuracy = 0;
	end
	%derive_biases = (logits - train_label(i,:)) .* logits .* (1 - logits);
	derive_weights = train_dataset(i,:,:)' * derive_biases;
	weights = weights - 0.05 * derive_weights;
	biases = biases - 0.05 * derive_biases;
end

accuracy = 0;
for i = 1:train_size
	%[loss,logits,derive_biases] = softmax_cross_entropy(train_dataset(i,:,:) * weights + biases,train_label(i,:),num_classes);
	logits = softmax(train_dataset(i,:,:) * weights + biases);
	[arg, argmax_logits] = max(logits);
	[arg, argmax_label] = max(train_label(i,:));
	accuracy = accuracy + (argmax_logits == argmax_label);
end
train_accuracy = accuracy / train_size
