# dataset

## image_deleted.sh

对于notMNIST_large.tar.gz和notMNIST_small.tar.gz进行解压，并删除无法被读取的图片。

## all_data_and_label.m

引用了data_and_label.m函数
将文件夹中的图片读取，并存储为.mat文件。

## construct_data_structure.m

获取一下文件:

```bash
train_dataset.mat
train_label.mat
valid_dataset.mat
valid_label.mat
test_dataset.mat
test_label.mat
```

## change_label.m

将label的存储格式改为one-hot的格式。

## main.m

```matlab
all_data_and_label;
construct_data_structure;
change_label;
```
