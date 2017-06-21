function [result,logits,derive] = softmax_cross_entropy(x, label, num_classes)
y = x - max(x);
logits = exp(y) / sum(exp(y));
result = - sum(label .* log(logits) + (1 - label) .* log(1 - logits)) / num_classes;
derive = (logits - label) / num_classes;
