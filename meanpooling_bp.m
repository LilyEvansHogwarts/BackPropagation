function y = meanpooling_bp(x)
ksize = 2;
q = ones(ksize, ksize);
y = kron(x,q) / (ksize * ksize);