function y = softmax(x)
xs = exp(x);
y = xs/sum(xs);

