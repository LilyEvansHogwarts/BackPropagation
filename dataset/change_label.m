num_classes = 10;
train_size = 200000;
valid_size = 10000;
test_size = 10000;
A = eye(num_classes);

load('test_label.mat');
label = zeros(num_classes,test_size);

for i = 1:test_size
	label(:,i) = A(test_label(1,i),:);
end

test_label = label;
save('test_label.mat', 'test_label');

10

load('valid_label.mat');
label = zeros(num_classes,valid_size);

for i = 1:valid_size
	label(:,i) = A(valid_label(1,i),:);
end

valid_label = label;
save('valid_label.mat', 'valid_label');

10

load('train_label.mat');
label = zeros(num_classes,train_size);

for i = 1:train_size
	label(:,i) = A(train_label(1,i),:);
end

train_label = label;
save('train_label.mat', 'train_label');

10

