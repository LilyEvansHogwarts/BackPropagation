# MNIST

## t10k-images-idx3-ubyte

该文件内为test_dataset所需数据，其中文件前段存放着magicNum = 2051和imageNum = 10000、imageRow = 28、imageCol = 28数据。之后的图像数据为连续的存放因此需要reshape。

## train-images-idx3-ubyte

该文件内为train_dataset所需数据，其中文件前端存放着magicNum = 2051、imageNum = 60000、imageRow = 28、imageCol = 28的数据。之后的图像数据为连续存放因此需要reshape。

## t10k-labels-idx1-ubyte

该文件内为test_label所需数据，其中文件前端为magicNum = 2049、labelNum = 10000，之后的数据均对应label，长度为1。

## train-labels-idx1-ubyte

该文件内为train_label所需数据，其中文件前端为magicNum = 2049、labelNum = 60000，之后的数据均对应label，长度为1。

## test_image_readfile.m

运行求得:
	test_image/
	test_dataset.mat (28,28,10000)

## train_image_readfile.m

运行求得:
	train_image/
	train_dataset.mat (28,28,60000)

## test_label_readfile.m

运行求得:
	test_label.mat (10,10000)

## train_label_readfile.m

运行求得:
	train_label.mat (10,60000)


