function result = cross_entropy_derive(logits, label, num_classes)
result = (logits - label) ./ (logits .* (1 - logits) * num_classes);
