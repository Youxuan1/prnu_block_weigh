clear all
clc
matlab
% 创建exp1.csv文件  
fileID1 = fopen('exp1_flat_ref.csv','w');
fileID2 = fopen('exp1_indoor_ref.csv','w');
fileID3 = fopen('exp1_outdoor_ref.csv','w');

% 参考噪声图路径       
ref_flat = 'D01_Samsung_GalaxyS3Mini/flat_frames/vid1/D01_Samsung_GalaxyS3Mini_flat_frames_vid1_i_ref.jpg';    
ref_indoor = 'D01_Samsung_GalaxyS3Mini/indoor_frames/vid1/D01_Samsung_GalaxyS3Mini_indoor_frames_vid1_i_ref.jpg';  
ref_outdoor = 'D01_Samsung_GalaxyS3Mini/outdoor_frames/vid1/D01_Samsung_GalaxyS3Mini_outdoor_frames_vid1_i_ref.jpg';   

% 读取参考噪声图    
ref_flat_img = imread(ref_flat);     
ref_indoor_img = imread(ref_indoor); 
ref_outdoor_img = imread(ref_outdoor);

% 遍历D01_Samsung_GalaxyS3Mini文件夹下所有子文件夹
folders = dir('D01_Samsung_GalaxyS3Mini');
for k = 1:length(folders)
    
    % 判断是否为隐藏文件,如果是则跳过
    if folders(k).name(1) == '.'
        continue
    end  

    % 添加名称判断
    % 如果名称不以_frames结尾,则跳过
    if length(folders(k).name) < 7
        continue
    elseif ~strcmp(folders(k).name(end-6:end), '_frames')
        continue
    end    

    % 判断子文件夹名称
    folder_name = folders(k).name;
    
    % 再次遍历子文件夹下所有的子文件夹,如vid1,vid2等 
    subfolders = dir(['D01_Samsung_GalaxyS3Mini/' folder_name]);  
    for j = 1:length(subfolders) 
        
        % 判断是否为隐藏文件,如果是则跳过
        if subfolders(j).name(1) == '.'
            continue
        end  

        % 子子文件夹名称
        subfolder_name = subfolders(j).name; 
        
        % 遍历子子文件夹下所有噪声图
        files = dir(['D01_Samsung_GalaxyS3Mini/' folder_name '/' subfolder_name]); 
        for i = 1:length(files)  

            % 判断是否为隐藏文件,如果是则跳过
            if files(i).name(1) == '.'
                continue
            end  

            % 判断是否为目录,如果是则跳过
            if files(i).isdir
                continue
            end  
            
            % 判断是否为参考噪声图
            isRef = contains(files(i).name, 'vid1_i_ref.jpg');  
            
            % 若是参考噪声图,跳过        
            if isRef == 1    
               continue; 
            end  
        
            % 读取当前噪声图
            curr_img  = imread(['D01_Samsung_GalaxyS3Mini/' folder_name '/' subfolder_name '/' files(i).name]); 
            
            % 计算相关系数
            corr_flat = corr2_rgb(ref_flat_img,curr_img);
            corr_indoor = corr2_rgb(ref_indoor_img,curr_img);
            corr_outdoor = corr2_rgb(ref_outdoor_img,curr_img);
            
            % 写入结果     
            fprintf(fileID1,'%s,%.4f\n',['D01_Samsung_GalaxyS3Mini/' folder_name '/' subfolder_name '/' files(i).name],corr_flat);  
            fprintf(fileID2,'%s,%.4f\n',['D01_Samsung_GalaxyS3Mini/' folder_name '/' subfolder_name '/' files(i).name],corr_indoor);
            fprintf(fileID3,'%s,%.4f\n',['D01_Samsung_GalaxyS3Mini/' folder_name '/' subfolder_name '/' files(i).name],corr_outdoor);     
        end 
    end
end
               
% 关闭文件  
fclose(fileID1);
fclose(fileID2);
fclose(fileID3);
