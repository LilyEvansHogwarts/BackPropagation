function y = convolver(kernel, feature_map, bias)

[kernel_size, kernel_size, num_kernel] = size(kernel);
[feature_size, feature_size, num_feature] = size(feature_map);

y = ones(feature_size, feature_size, num_kernel);


for i = 1:num_kernel
    for j = 1:num_feature
        y(:,:,i) = y(:,:,i) + conv2(feature_map(:,:,j), kernel(:,:,i), 'same');
    end
    y(:,:,i) = y(:,:,i) / num_feature;
    y(:,:,i) = relu(y(:,:,i) + bias(i));
end
        
        