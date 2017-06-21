function result = softmax_derive(x)
result = x .* (1 - x);
