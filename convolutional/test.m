num_size = 7;

A = ones(num_size,num_size,3);
A(:,:,2) = 2 * A(:,:,2);
A(:,:,3) = 3 * A(:,:,3);
B = ones(5,5,3);
B(:,:,2) = 2 * B(:,:,2);
B(:,:,3) = 3 * B(:,:,3);
C = convn(A,B,'same');

D = zeros(num_size,num_size,3,3);

for i = 1:3
	for j = 1:3
		D(:,:,i,j) = conv2(A(:,:,i),B(:,:,j),'same');
	end
end

