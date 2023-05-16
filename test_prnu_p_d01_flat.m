clear all
clc
pass = 'D01_Samsung_GalaxyS3Mini/flat_frames/vid1/prnu_p';
total = 2112;
% 创建 imageDatastore 对象,指定图像文件夹和格式
imds = imageDatastore(pass,'FileExtensions','.jpg'); 

prnu_ref = 0;
% 取所有图像 prnu 的平均值
for i = 1:total
    tmp_photo = readimage(imds , i);
    tmp_photo = im2double(tmp_photo);
	prnu_ref = tmp_photo + prnu_ref;
    clear tmp_photo
end

prnu_ref = (prnu_ref ./ total);

% 保存prnu图像
imwrite(prnu_ref,'D01_Samsung_GalaxyS3Mini/flat_frames/vid1/D01_Samsung_GalaxyS3Mini_flat_frames_vid1_p_ref.jpg');
