function get_ref_corr(folder_names, scene, ref_img_info)
% 利用读入的参考噪声图结构体，找到目录下所有的非参考噪声图，比较他们和所有相关噪声之间的相关系数，记录到文件 ['exp2_' scene
% '.csv'] 中

% 创建或打开csv文件
[fid1 , errmsg1] = fopen(['exp2_' scene '.csv'],'a+');

% % 如果文件不存在则创建,存在则写入分隔线
% if strcmp(errmsg1,'')
%     fprintf(fid1,'----------------------\n');
% end

for i = 1:length(folder_names)  
    % 当前文件夹名称
    folder_name = folder_names{i}; 

    % flat_frames 
    flat_folders = dir([folder_name '/flat_frames']);
    for j = 1:length(flat_folders)                  
        % 子文件夹名称
        flat_folder_name = flat_folders(j).name;     
        
        % 判断是否为隐藏文件,如果是则跳过
        if flat_folder_name(1) == '.'
            continue
        end  

        % 遍历子文件夹下文件
        flat_files = dir([folder_name '/flat_frames/' flat_folder_name]);
        for k = 1:length(flat_files)

	        % 判断是否为隐藏文件,如果是则跳过
	        if flat_files(k).name(1) == '.'
	        	continue
            end

	        % 判断是否为目录,如果是则跳过
	        if flat_files(k).isdir
                continue
            end

            % 判断是否为参考噪声图
            isRef = contains(flat_files(k).name,'_vid1_i_ref.jpg'); 
            % 如果是非参考噪声图,计算相关系数
            if isRef == 0
                file_path = [folder_name '/flat_frames/' flat_folder_name '/' flat_files(k).name];
                curr_img = imread(file_path);
                for ref_index = 1:length(ref_img_info)
                    corr_flat = corr2_rgb(ref_img_info(ref_index).(['ref_' scene]),curr_img);
                    % 将结果写入csv文件
                    fprintf(fid1,'%s,ref_%s/%s,%.4f\n',flat_files(k).name, folder_names{ref_index}, scene, corr_flat); 
                end
            end
        end
    end
end

% 关闭文件
fclose(fid1); 