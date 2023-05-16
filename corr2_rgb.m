function corr = corr2_rgb(img1,img2)
% 大小匹配
% % rows_img1 = size(img1,1);
% % cols_img1 = size(img1,2);
% % rows_img2 = size(img2,1);
% % cols_img2 = size(img2,2);

% if rows_img1 == rows_img2 && cols_img1 == cols_img2  % 大小匹配
%     % 提取颜色通道 
%     r1 = img1(:,:,1); 
%     g1 = img1(:,:,2);
%     b1 = img1(:,:,3);
% 
%     r2 = img2(:,:,1);  
%     g2 = img2(:,:,2);
%     b2 = img2(:,:,3);
% elseif rows_img1 == cols_img2 && rows_img2 == cols_img1 % 长宽交换
%     % 提取颜色通道 
%     r1 = img1(:,:,1); 
%     g1 = img1(:,:,2);
%     b1 = img1(:,:,3);
% 
%     r2 = img2(:,:,1)';  
%     g2 = img2(:,:,2)';
%     b2 = img2(:,:,3)';
% else                   % 大小不匹配
%     % disp('参考图像ref_flat_img与当前图像curr_img大小不匹配!');
% end

img1 = pict_rotate(img1);
img2 = pict_rotate(img2);

if size(img1, 1) < size(img2, 1)
    img2 = imresize(img2, [size(img1,1) size(img1,2)]);
elseif size(img1, 1) > size(img2, 1)
    img1 = imresize(img1, [size(img2,1) size(img2,2)]);
elseif size(img1, 2) < size(img2, 2)
    img2 = imresize(img2, [size(img1,1) size(img1,2)]);
elseif size(img1, 2) > size(img2, 2)
    img1 = imresize(img1, [size(img2,1) size(img2,2)]);
end

% 提取颜色通道
r1 = img1(:,:,1); 
g1 = img1(:,:,2);
b1 = img1(:,:,3);

r2 = img2(:,:,1);  
g2 = img2(:,:,2);
b2 = img2(:,:,3);

% 计算三个颜色通道的相关系数
corr_r = corr2(r1, r2); 
corr_g = corr2(g1, g2);
corr_b = corr2(b1, b2);

% 求平均,得到两图像的相关系数
corr = (corr_r + corr_g + corr_b) / 3;
