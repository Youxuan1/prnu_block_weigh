function get_ref_corr_sample(folder_names, scene, ref_img_info)
% 利用读入的参考噪声图结构体，找到目录下所有的非参考噪声图，比较他们和所有相关噪声之间的相关系数，记录到文件'prnu_test.csv'中

% 创建或打开csv文件
[fid1 , errmsg1] = fopen('prnu_test.csv','a+');

% % 如果文件不存在则创建,存在则写入分隔线
% if strcmp(errmsg1,'')
%     fprintf(fid1,'----------------------\n');
% end

for i = 1:length(folder_names)  
    % 当前文件夹名称
    folder_name = folder_names{i}; 

    % flat_frames 
    flat_folders = dir([folder_name '/' scene '_frames']);
    for j = 1:length(flat_folders)                  
        % 子文件夹名称
        vid_name = flat_folders(j).name;     
        
        % 判断是否为隐藏文件,如果是则跳过
        if vid_name(1) == '.'
            continue
        end  

        % 遍历i文件夹下所有 i 帧图片
        i_jpg_files = dir([folder_name '/' scene '_frames/' vid_name '/i/*.jpg']);
        num_i_jpg_files = size(i_jpg_files, 1);
        for k = 1:num_i_jpg_files
            corr = corr2_rgb(ref_img_info.(['ref_' scene]),);
   
        end
    end
end

% 关闭文件
fclose(fid1); 