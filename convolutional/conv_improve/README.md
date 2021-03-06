# convolutional

## 与conv_base不同之处

由于matlab内置环境的问题，统一将channel对应的坐标变成第三坐标。

## 运行过程

### 适当的初始化方式可以大幅度提升网络update精度

* 经过多次与mnist_deep.py的比对，对于原来的conv2_test.m进行修改:
    1. 从原本的weights和biases均用rand进行初始化，变为biases用0.1初始化，weights用标准差为0.1的矩阵初始化;
    2. 在.m文件上添加`format long;`来增加计算的位数，提升精度。
    发现最终的精度在短时间内迅速地由原来的0.1-0.2间浮动，变为0.8-0.9。

* 运算精度对于分类精度的影响几乎可以忽略不计:

使用mnist对应的数据集的运行结果(mnist数据集没有进行任何的预处理)
|calculation precision		|result precision   |
|:-----------------------------:|:-----------------:|
|format long(小数点后15位)	|0.8779		    |
|format short(小数点后4位)	|0.8737		    |

notMNIST数据结构预处理为减去255/2，再除以255: 0.8602
