z = 0:1/64:127/64;
clc;
out = dec2bin(exp(-z) * 64);
right = zeros(64,7);
k = dec2bin(z * 64);
p = zeros(64,7);
num = 64;
for i = 57:64
    for j = 1:7
        right(i,j) = str2num(out(i + num,j));
        p(i,j) = str2num(k(i + num,j));
    end
    p(i,:) = expential2(p(i,:));
    right(i,:) - p(i,:)
end

