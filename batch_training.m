clear;

image_size = 28;
num_lines = 200; %%notmnist_large.txt文件内对应图片的字符串的行数
num_class = 10;
num_of_images_per_class = num_lines / num_class;

%%对于训练集初始化
train_images = zeros(28,28,num_lines);
train_labels = zeros(num_class,1,num_lines);

%%根据notmnist.txt去一个个的读取与部分图像信息，构成训练集
offset = 0;
A = eye(num_class);
notMNIST_large = fopen('notmnist.txt','r');
for i = 1:num_class
    tfile = fgetl(notMNIST_large);
    file_content = fopen(tfile,'r');
    for j = 1:num_of_images_per_class
        k = offset + j;
        train_images(:,:,k) = imread(fgetl(file_content));
        train_labels(:,:,k) = A(:,i);
    end
    offset = offset + num_of_images_per_class;
end

%%对于数据集打乱顺序
p = randperm(num_lines);
train_images = train_images(:,:,p);
train_labels = train_labels(:,:,p);



%%对于训练网络进行初始化
num_kernel1 = 32;
kernel1_size = 5;
layer1_kernel = rand(kernel1_size,kernel1_size,num_kernel1);
%%layer1_conv = zeros(image_size, image_size, num_kernel1);
layer1_bias = rand(1, num_kernel1);
layer1_conv_out = zeros(image_size/2, image_size/2, num_kernel1);

num_kernel2 = 64;
kernel2_size = 5;
layer2_kernel = rand(kernel2_size, kernel2_size, num_kernel2);
%%layer2_conv = zeros(image_size/2, image_size/2, num_kernel1);
layer2_bias = rand(1, num_kernel2);
layer2_conv_out = zeros(image_size/4, image_size/4, num_kernel2);

fc1_size = 1024;
fc1_weights = 0.001 * rand(fc1_size, image_size/4 * image_size/4 * num_kernel2);
fc1_bias = 0.001 * rand(fc1_size, 1);

fc2_weights = 0.001 * rand(num_class, fc1_size);
fc2_bias = 0.001 * rand(num_class, 1);
fc2_norm = zeros(1, num_lines);

y = zeros(num_class, 1, num_lines);
%%loss = zeros(1, num_lines);
fc2_bias_improve = 0;
fc2_weights_improve = 0;
fc1_bias_improve = 0;
fc1_weights_improve = 0;

lr = 1.0e-5;
batch_size = 20;
round_size = num_lines / batch_size;
loss = zeros(1, round_size);

%%接下来的部分用于训练网络
for k = 1:round_size
    for j = 1:batch_size
        i = (k - 1) * batch_size + j;
        train_images(:,:,i) = train_images(:,:,i) / norm(train_images(:,:,i));
        
        %%第一层：卷积层
        [layer1_conv_out, layer1_location] = maxpooling(convolver(layer1_kernel, train_images(:,:,i), layer1_bias));
		%%第二层：卷积层
		[layer2_conv_out, layer2_location] = maxpooling(convolver(layer2_kernel, layer1_conv_out, layer2_bias));

		%%第三层：全连接层
		fc1_input = reshape(layer2_conv_out, image_size/4 * image_size/4 * num_kernel2, 1);
		fc1_output = fc1_weights * fc1_input + fc1_bias;
		fc1_output = relu(fc1_output);

		%%第四层：全连接层
		fc2_output = fc2_weights * fc1_output + fc2_bias;
		fc2_norm(1,i) = norm(fc2_output);
		fc2_output = fc2_output / fc2_norm(1,i);
		y(:,:,i) = softmax(fc2_output);
		loss(1,k) = loss(1,k) + loss_function(train_labels(:,:,i), y(:,:,i));

		delta_fc2_bias = (y(:,:,i) - train_labels(:,:,i)) .* softmax_derive(y(:,:,i)); %% fc2_norm(1,i); %% (num_class , 1)
		fc2_bias_improve = fc2_bias_improve + delta_fc2_bias; %% (num_class , 1)
		delta_fc2_weights = fc1_output * delta_fc2_bias'; %% (fc1_size , 1) * (1 , num_class) = (fc1_size , num_class)
		fc2_weights_improve = fc2_weights_improve + delta_fc2_weights'; %% (num_class , fc1_size)

		delta_fc1_bias = fc2_weights' * delta_fc2_bias; %% (fc1_size , num_class) * (num_class , 1) = (fc1_size , 1)
		fc1_bias_improve = fc1_bias_improve + delta_fc1_bias; %% (fc1_size , 1)
		delta_fc1_weights = fc1_input * delta_fc1_bias'; %% (7*7*64 , 1) * (1 , fc1_size) = (7*7*64 , fc1_size)
		fc1_weights_improve = fc1_weights_improve + delta_fc1_weights'; %% (fc1_size , 7*7*64)

		delta_fc1_input = fc1_weights' * delta_fc1_bias; %% (7*7*64 , fc1_size) * (fc1_size , 1) = (7*7*64 , 1)
		delta_layer2_pooling = reshape(delta_fc1_input, image_size/4, image_size/4, num_kernel2); %% (image_size / 4, image_size / 4, num_kernel2)
        delta_layer2_conv_out = maxpooling_bp(delta_layer2_pooling, layer2_location);

    end
    
	fc2_bias = fc2_bias - lr * fc2_bias_improve;
    fc2_bias_improve = 0;
	fc2_weights = fc2_weights - lr * fc2_weights_improve;
    fc2_weights_improve = 0;
	fc1_bias = fc1_bias - lr * fc1_bias_improve;
    fc1_bias_improve = 0;
	fc1_weights = fc1_weights - lr * fc1_weights_improve;
    fc1_weights_improve = 0;
    %%if mod(i,20) == 0
    %%    lr = lr * 0.25;
    %%end



end
