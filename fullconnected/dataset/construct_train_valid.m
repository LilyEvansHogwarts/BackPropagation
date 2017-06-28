function  construct_train_valid(train_size, valid_size, image_size)

root = 'notMNIST_large/';
filenames = dir([root, '*.mat']);
num_classes = length(filenames);
tsize_per_class = train_size / num_classes;
vsize_per_class = valid_size / num_classes;
end_l = tsize_per_class + vsize_per_class;
train_dataset = zeros(train_size, image_size, image_size);
valid_dataset = zeros(valid_size, image_size, image_size);
train_label = zeros(1, train_size);
valid_label = zeros(1, valid_size);
start_t = 1;
end_t = tsize_per_class;
start_v = 1;
end_v = vsize_per_class;

for i = 1:num_classes
	load([root, filenames(i).name]);
	train_dataset(start_t:end_t, :, :) = dataset(1:tsize_per_class, :, :);
	valid_dataset(start_v:end_v, :, :) = dataset((tsize_per_class + 1):end_l, :, :);
	train_label(1, start_t:end_t) = i;
	valid_label(1, start_v:end_v) = i;
	start_t = start_t + tsize_per_class;
    end_t = end_t + tsize_per_class;
	start_v = start_v + vsize_per_class;
	end_v = end_v + vsize_per_class;
end

p1 = randperm(train_size);
train_dataset = train_dataset(p1, :, :);
train_label = train_label(1, p1);
p2 = randperm(valid_size);
valid_dataset = valid_dataset(p2, :, :);
valid_label = valid_label(1, p2);
save('train_dataset.mat', 'train_dataset');
save('train_label.mat', 'train_label');
save('valid_dataset.mat', 'valid_dataset');
save('valid_label.mat', 'valid_label');
