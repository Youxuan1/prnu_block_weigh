clear all
clc
folder_names = {'D01_Samsung_GalaxyS3Mini'   'D02_Apple_iPhone4s'   'D03_Huawei_P9'     ...  
               'D04_LG_D290'   'D07_Lenovo_P70A'   'D12_Sony_XperiaZ1Compact' ...
               'D17_Microsoft_Lumia640LTE' 'D21_Wiko_Ridge4G'   'D23_Asus_Zenfone2Laser' ...
               'D24_Xiaomi_RedmiNote3'   'D25_OnePlus_A3000'};
video_folders = {'flat' 'indoor' 'outdoor'}; 
frame_folders = {'flat_frames' 'indoor_frames' 'outdoor_frames'};
% 创建exp1.csv文件  
fileID1 = fopen('exp1_plus_flat_ref.csv','w');
fileID2 = fopen('exp1_plus_indoor_ref.csv','w');
fileID3 = fopen('exp1_plus_outdoor_ref.csv','w');

for fuck = 1:numel(folder_names)
    
    % 参考噪声图路径       
    ref_flat = [folder_names{fuck} '/' frame_folders{1} '/vid1/' folder_names{fuck} '_' frame_folders{1} '_vid1_i_ref.jpg'];    
    ref_indoor = [folder_names{fuck} '/' frame_folders{2} '/vid1/' folder_names{fuck} '_' frame_folders{2} '_vid1_i_ref.jpg'];  
    ref_outdoor = [folder_names{fuck} '/' frame_folders{3} '/vid1/' folder_names{fuck} '_' frame_folders{3} '_vid1_i_ref.jpg'];   
    
    % 读取参考噪声图    
    ref_flat_img = imread(ref_flat);     
    ref_indoor_img = imread(ref_indoor); 
    ref_outdoor_img = imread(ref_outdoor);
    
    % 遍历D01_Samsung_GalaxyS3Mini文件夹下所有子文件夹
    folders = dir(folder_names{fuck});
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
        subfolders = dir([folder_names{fuck} '/' folder_name]);  
        for j = 1:length(subfolders) 
            
            % 判断是否为隐藏文件,如果是则跳过
            if subfolders(j).name(1) == '.'
                continue
            end  
    
            % 子子文件夹名称
            subfolder_name = subfolders(j).name; 
            
            % 遍历子子文件夹下所有噪声图
            files = dir([folder_names{fuck} '/' folder_name '/' subfolder_name]); 
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
                curr_img  = imread([ folder_names{fuck} '/' folder_name '/' subfolder_name '/' files(i).name]); 
                
                % 计算相关系数
                corr_flat = corr2_rgb(ref_flat_img,curr_img);
                corr_indoor = corr2_rgb(ref_indoor_img,curr_img);
                corr_outdoor = corr2_rgb(ref_outdoor_img,curr_img);
                
                % 写入结果     
                fprintf(fileID1,'%s,%.4f\n',[folder_names{fuck} '/' folder_name '/' subfolder_name '/' files(i).name],corr_flat);  
                fprintf(fileID2,'%s,%.4f\n',[folder_names{fuck} '/' folder_name '/' subfolder_name '/' files(i).name],corr_indoor);
                fprintf(fileID3,'%s,%.4f\n',[folder_names{fuck} '/' folder_name '/' subfolder_name '/' files(i).name],corr_outdoor);     
            end 
        end
    end
  
end


% 关闭文件  
fclose(fileID1);
fclose(fileID2);
fclose(fileID3);
