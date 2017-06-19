A = rand(10,10,64);
location = zeros(10,10,64);
y = zeros(5,5,64);
for i = 1:64
    [y(:,:,i),location(:,:,i)] = maxpooling(A(:,:,i));
end
x = maxpooling_bp(y,location);
    
    