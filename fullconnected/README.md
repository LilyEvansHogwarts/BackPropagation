# fullyconnected layer

## 构造A.mat之类的文件

data_and_label.m
all_data_and_label.m
image_deleted.sh

在运行data_and_label.m的时候发现，由于部分图像文件不能读取造成A.mat文件构造受阻，于是便将imread会出错的图片先删去，对应操作的脚本文件为:image_deleted.sh, all_data_and_label.m 就是在data_and_label函数的基础之上提供了'notMNIST_large/'和'notMNIST_small/'两个文件夹。最终在notMNIST_large/和notMNIST_small/路径下分别生成:A.mat、B.mat、C.mat、D.mat、E.mat、F.mat、G.mat、H.mat、I.mat、J.mat文件。

## 构造train、valid、test数据集

由于实际过程中可能存在valid数据集不存在的情况，而valid数据集提取应该和train同步，因此将construct_train.m和construct_train_valid.m文件分开，又因为save函数，最终保存的数据集被再次load的名称受第一次的命名影响，因此为了方便，将train和test分别写了两个.m文件，分别为construct_train.m和construct_test.m。

construct_data_structure.m作为单独的文件存在，是为了降低网络的工作量，可以单独运行construct_data_struct.m文件，这样以后就不用每次运行网络都要重新构建train、valid、test数据集了。

## change_label.m

在实际使用label的时候要求label为(1,num_classes)的shape，因此要提前对于train、test、valid数据集里的label进行处理。

## 运行fullyconnected.m和fullyconnected.m

在运行fullyconnected.m和fullyconnected_batch.m的时候发现，采用单纯的sgd进行权重更新，所得到的最终的accuracy反而不低，采用batch的方法存在的问题是:
当batch_pass达到一定程度，就会出现loss = NaN的情况，严重影响权重更新，这就突出了validation的重要性，采用validation数据集，可以比较两个epoch对应的精度变化，如果出现两个epoch变化不大的情况，就可以停止更新权重。
batch的方法要想得到和单样本sgd一样的精度需要更大的数据量，即train的数据集要跑不止一遍。

## 运行fullyconnected_two_layers.m和fullyconnected_two_layers_batch.m

在初次运行fullyconnected_two_layers.m对于fc1_output没有除去normal1和fc2_output除以normal2，以至于最终的网络运行结果精度为0.12，当对于fc2_output/normal2后，网络精度提升至0.30左右，添加对于fc1_output/normal1后，网络精度提升至0.60。(backpropagation不除以normal1和normal2，learning-rate不发生改变的情况下，train_dataset运行一遍跑出来的结果)
不知出于什么原因，batch的运行精度要略小于单样本更新权重的最终精度。
当将backpropagation中添加除以normal1和normal2的部分，发现将train_dataset运行20遍，最终的精度为0.54，基本达到极限，也就是说两层fc的分类精度为0.54，但对比前面的实验发现单层fc的精度反而更高。

## fullyconnected_two_layers_softmax.m

由于经过两层全连接层后，由于权重相乘后相加，最终x2 = x1 * w2 + b2的量级会达到立方量级，这会对于后续的softmax中exp计算带来困扰，因此造成softmax的overflow，初始的时候通过x2 / norm(x2)的方式来解决这一问题，发现最终的训练精度一直上不来，需要经过多轮训练才能够取得0.5以上的精度，但是将x2进行处理x2 - max(x2)之后，再采用softmax函数，也就是最终的softmax结果并没有发生改变，再进行训练发现训练精度在pass = 1的情况下基于能够的得到大幅度提升最终为0.78。
反思原因: 在对于x2 / norm(x2)处理的过程中，其实是变相的改变了两层全连接层的实际分类结果，与原有产生一定程度上的偏差，这也就带来权重更新的不准确，但是x2 - max(x2)的预处理并不会带来softmax的分类结果的改变，因此很好的保留了原有分类器的分类结果，权重更新上也不会造成强度偏差。具体可以参考:![softmax-vs-softmax-loss](freemid.pluskid.org/machine-learning/softmax-vs-softmax-loss-numerical-stability/)相应的pdf为![softmax-vs-softmax-loss-numerical-stability](softmax-vs-softmax-loss-numerical-stability.pdf)
