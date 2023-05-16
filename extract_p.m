function extract_p(pass,total)

prnu_ref = 0;

% 创建 imageDatastore 对象,指定图像文件夹和格式
imds = imageDatastore(pass,'FileExtensions','.jpg'); 

% 提取每个图像的prnu
for i = 1:total
    % 一张一张地读取图像
    current_image = readimage(imds , i);
    % current_image = im2double(current_image);
    current_prnu = algorithm1(current_image);

    % 保存prnu图像
    imwrite(current_prnu, ['tmp/prnu' num2str(i) '.jpg']);
    disp(['tmp/prnu' num2str(i) '.jpg']);
end

% 取所有图像 prnu 的平均值
for i = 1:total
    tmp_photo = imread(['tmp/prnu' num2str(i) '.jpg']);
    tmp_photo = im2double(tmp_photo);
	prnu_ref = tmp_photo + prnu_ref;
    clear tmp_photo
end

prnu_ref = prnu_ref ./ total;

% 保存prnu图像
imwrite(prnu_ref, 'tmp/prnu_p.jpg');
disp('tmp/prnu_p.jpg is writen');
end