function [y, location] =  maxpooling(x)
ksize = 2;
shape = size(x);
x_size = shape(1,1);
num_feature = shape(1,3);
location = zeros(x_size, x_size, num_feature);
y_size = x_size / ksize;
y = zeros(y_size, y_size, num_feature);
for i = 1:num_feature
    for row = 1:y_size
        start_row = (row - 1) * ksize + 1;
        end_row = row * ksize;
        for column = 1:y_size
            start_column = (column - 1) * ksize + 1;
            end_column = column * ksize;
            [ax,bx] = max(x(start_row:end_row, start_column:end_column, i));
            [ay,by] = max(ax);
            location(start_row + bx(1,by) - 1, start_column + by - 1, i) = 1;
            y(row, column, i) = ay;
        end
	end
end
