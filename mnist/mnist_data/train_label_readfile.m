[FileName,PathName] = uigetfile('.','train-labels-idx1-ubyte');
TrainFile = fullfile(PathName,FileName);
fid = fopen(TrainFile,'r');
a = fread(fid,8,'uint8');
MagicNum = ((a(1) * 256 + a(2)) * 256 + a(3)) * 256 + a(4);
LabelNum = ((a(5) * 256 + a(6)) * 256 + a(7)) * 256 + a(8);

if ((MagicNum ~= 2049) || (LabelNum ~= 60000))
	error('this is not MNIST train-labels-idx1-ubyte');
	fclose(fid);
	return;
end

A = eye(10);
train_label = zeros(10,LabelNum);

h_w = waitbar(0,'please, wait for a moment>>');
for i = 1:LabelNum
	b = fread(fid,1,'uint8');
	train_label(:,i) = A(:,b+1);
	waitbar(i/LabelNum);
end

save('train_label.mat','train_label');
fclose(fid);
close(h_w);
