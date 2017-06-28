train_size = 200000;
valid_size = 10000;
test_size = 10000;
image_size = 28;

construct_test(test_size, image_size);

if valid_size == 0
	construct_train(train_size, image_size);
else
	construct_train_valid(train_size, valid_size, image_size);
end


