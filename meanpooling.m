function y = meanpooling(x)
ksize = 2;
shape = size(x);
x_size = shape(1,1);
start_row = 1;
end_row = ksize;
start_column = 1;
end_column = ksize;
y_size = x_size / ksize;
y = zeros(y_size, y_size);
for row = 1:y_size
    for column = 1:y_size
        q = x(start_row:end_row, start_column:end_column);
        y(row, column) = sum(sum(q)') / (ksize * ksize);
        start_column = start_column + ksize;
        end_column = end_column + ksize;
    end
    start_column = 1;
    end_column = ksize;
    start_row = start_row + ksize;
    end_row = end_row + ksize;
end