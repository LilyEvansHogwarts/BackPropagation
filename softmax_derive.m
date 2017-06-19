function y = softmax_derive(x)
shape = size(x);
y = x .* (ones(shape) - x);
