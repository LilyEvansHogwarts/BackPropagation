function result = convolver1(A,B)
result = conv2(A,rot90(B,2),'valid');