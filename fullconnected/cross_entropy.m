function result = cross_entropy(logits,label,num_classes)
result = - sum(label .* log(logits) + (1 - label) .* log(1 - logits)) / num_classes;
