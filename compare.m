clear all;
clc;
matlab
% 获取文件夹中所有图像
files = dir('*.jpg'); 

% 初始化参考噪声图像和图像计数器
ref_prnu = zeros(size(imread(files(1).name)));  
count = 1;

for i = 1:length(files)
    % 读取第 i 个图像
    img = imread(files(i).name);    
    
    % 如果图像名称包含 'prnu_',则视为噪声图像
    if contains(files(i).name, 'prnu_')  
        
        % 累加至参考噪声图像
        ref_prnu = ref_prnu + cast(img, class(ref_prnu));  
        
        % 增加噪声图像计数器
        count = count + 1;  
        
    end
end  

% 求平均作为参考噪声  
ref_prnu = ref_prnu / count; 

% 获取正常图像(非噪声图像)  
img73 = imread(files(73).name); 

% 计算相关系数  
% img73 是 720x1280x3 的 uint8 类型矩阵  
% ref_prnu 是 720x1280x3 的 double 类型矩阵
corr = corrcoef(ref_prnu, im2double(img73));  
corr_val = corr(2, 1);  
% corr_val 是 ref_prnu 和 img73 之间的相关系数

