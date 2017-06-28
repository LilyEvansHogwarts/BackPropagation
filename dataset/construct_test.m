function construct_test(test_size, image_size)

root = 'notMNIST_small/';
filenames = dir([root, '*.mat']);
num_classes = length(filenames);
size_per_class = test_size / num_classes;
test_dataset = zeros(image_size, image_size, test_size);
test_label = zeros(test_size);
start_t = 1;
end_t = size_per_class;

for i = 1:num_classes
	load([root, filenames(i).name]);
	test_dataset(:,:,start_t:end_t) = dataset(:,:,1:size_per_class);
	test_label(1, start_t:end_t) = i;
	start_t = start_t + size_per_class;
	end_t = end_t + size_per_class;
end

p = randperm(test_size);
test_dataset = test_dataset(:,:,p);
test_label = test_label(1, p);
save('test_dataset.mat', 'test_dataset');
save('test_label.mat', 'test_label');
