z = 0:1/64:1;
out = dec2bin(exp(-z) * 64);
right = zeros(64,7);
k = dec2bin(z * 64);
p = zeros(64,7);
for i = 1:64
    for j = 1:7
        right(i,j) = str2num(out(i,j));
        p(i,j) = str2num(k(i,j));
    end
    p(i,:) = expential(p(i,:));
end
right - p