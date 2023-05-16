function extract(pass,total)

prnu_ref = 0;

% 创建 imageDatastore 对象,指定图像文件夹和格式
imds = imageDatastore(pass,'FileExtensions','.jpg'); 

% 读取所有图像
images = readall(imds);

% 提取每个图像的prnu
for i = 1:total
    images{i} = algorithm1(images{i});
end

% 取所有图像 prnu 的平均值
for i = 1:total
	prnu_ref = images{i}+prnu_ref;
end
prnu_ref = prnu_ref ./ total;

% 保存prnu图像
imwrite(prnu_ref, 'tmp/i.jpg')

end