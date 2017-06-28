function data_and_label(root)
image_size = 28;
pixel_depth = 255.0;

subdirs = dir(root);
num_classes = length(subdirs) - 2;
for i = 3:length(subdirs)
	filenames = dir(strcat(root, subdirs(i).name));
	num_images = length(filenames) - 2;
	dataset = zeros(image_size, image_size,num_images);
	for j = 3:length(filenames)
        path = [root, subdirs(i).name, '/', filenames(j).name]
        dataset(:, :, j - 2) = im2double(imread(path)) - 0.5;
    end
	save([root, strcat(subdirs(i).name, '.mat')], 'dataset', '-mat');
end


