function result = convolver(A, B)
result = conv2(A, rot90(B,2), 'same');