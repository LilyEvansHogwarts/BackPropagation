function y = loss_function(label, y)
temp = label - y;
y = sum(temp .* temp);

