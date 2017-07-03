load('test_dataset.mat');
load('test_label.mat');

test_size = 10000;
num_classes = 10;
image_channel = 1;
image_size = 28;

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

for i = 1:test_size
	data = reshape(test_dataset(:,:,i),image_size,image_size,iamge_channel);
	
