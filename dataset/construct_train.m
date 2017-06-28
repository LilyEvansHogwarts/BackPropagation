function construct_train(train_size, image_size)

root = 'notMNIST_large/';
filenames = dir([root, '*.mat']);
num_classes = length(filenames);
size_per_class = train_size / num_classes;
train_dataset = zeros(image_size, image_size,train_size);
train_label = zeros(1, train_size);
start_t = 1;
end_t = size_per_class;

for i = 1:num_classes
	load([root, filenames(i).name]);
	train_dataset(:,:,start_t:end_t) = dataset(:,:,1:size_per_class);
	train_label(1, start_t:end_t) = i;
	start_t = start_t + size_per_class;
	end_t = end_t + size_per_class;
end

p = randperm(train_size);
train_dataset = train_dataset(:,:,p);
train_label = train_label(1, p);
save('train_dataset.mat', 'train_dataset');
save('train_label.mat', 'train_label');
