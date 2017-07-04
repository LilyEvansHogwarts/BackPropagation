[FileName,PathName] = uigetfile('.','train-images-idx3-ubyte');
TrainFile = fullfile(PathName,FileName);
fid = fopen(TrainFile,'r');
a = fread(fid,16,'uint8');
MagicNum = ((a(1) * 256 + a(2)) * 256 + a(3)) * 256 + a(4);
ImageNum = ((a(5) * 256 + a(6)) * 256 + a(7)) * 256 + a(8);
ImageRow = ((a(9) * 256 + a(10)) * 256 + a(11)) * 256 + a(12);
ImageCol = ((a(13) * 256 + a(14)) * 256 + a(15)) * 256 + a(16);

if ((MagicNum ~= 2051) || (ImageNum ~= 60000))
	error('this is not MNIST train-images-idx3-ubyte');
	fclose(fid);
	return;
end

train_dataset = zeros(ImageRow,ImageCol,ImageNum);

savedirectory = uigetdir('train_image');
h_w = waitbar(0,'please, wait for a moment>>');
for i = 1:ImageNum
	b = fread(fid,ImageRow * ImageCol,'uint8');
	c = reshape(b,[ImageRow,ImageCol]);
	d = c';
	train_dataset(:,:,i) = d;
	e = 255 - d;
	e = uint8(e);
	savepath = fullfile(savedirectory,['TrainImage_',num2str(i,d),'.bmp']);
	imwrite(e,savepath,'bmp');
	waitbar(i/ImageNum);
end
save('train_dataset.mat','train_dataset');
fclose(fid);
close(h_w);
