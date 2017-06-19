function y = maxpooling_bp(x,location)
ksize = 2;
[x_size, x_size, num_kernel] = size(x);
q = ones(ksize,ksize);
for i = 1:num_kernel
    y(:,:,i) = location(:,:,i) .* kron(x(:,:,i),q);
end
