function result = softmax(x)

y = exp(x);
result = y / sum(y);
