clear all
clc

% % 创建或打开csv文件
% [fid1, errmsg1] = fopen('exp2_flat.csv','a+');
% [fid2, errmsg2] = fopen('exp2_indoor.csv','a+'); 
% [fid3, errmsg3] = fopen('exp2_outdoor.csv','a+');
% 
% % 如果文件不存在则创建,存在则写入分隔线
% if strcmp(errmsg1,'')
%     fprintf(fid1,'----------------------\n');
% end
% if strcmp(errmsg2,'')
%     fprintf(fid2,'----------------------\n');
% end
% if strcmp(errmsg3,'')
%     fprintf(fid3,'----------------------\n'); 
% end

% 文件夹名称
folder_names = {'D01_Samsung_GalaxyS3Mini'   'D02_Apple_iPhone4s'   'D03_Huawei_P9'     ...  
               'D04_LG_D290'   'D07_Lenovo_P70A'   'D12_Sony_XperiaZ1Compact' ...
               'D17_Microsoft_Lumia640LTE' 'D21_Wiko_Ridge4G'   'D23_Asus_Zenfone2Laser' ...
               'D24_Xiaomi_RedmiNote3'   'D25_OnePlus_A3000'};
video_folders = {'flat' 'indoor' 'outdoor'}; 
frame_folders = {'flat_frames' 'indoor_frames' 'outdoor_frames'};

% 创建结构体保存参考噪声图信息
ref_img_info = struct('ref_flat',[],'ref_indoor',[],'ref_outdoor',[]);  

ref_img_info = get_ref_imgs(folder_names, 'flat', ref_img_info);
ref_img_info = get_ref_imgs(folder_names, 'indoor', ref_img_info);
ref_img_info = get_ref_imgs(folder_names, 'outdoor', ref_img_info);


% for i = 1:length(folder_names)
% 
%     % 当前文件夹名称
%     folder_name = folder_names{i};  
% 
%     % 遍历flat_frames文件夹
%     flat_folders = dir([folder_name '/flat_frames']);
    % for j = 1:length(flat_folders)               
    % 
    %     % 获取子文件夹名称 
    %     flat_folder_name = flat_folders(j).name; 
    % 
    %     % 判断是否为隐藏文件,如果是则跳过
    %     if flat_folder_name(1) == '.'
    %         continue
    %     end  
    % 
    %     % 遍历子文件夹下文件
    %     flat_files = dir([folder_name '/flat_frames/' flat_folder_name]);
    %     for k = 1:length(flat_files)  
    % 
    %         % 判断是否为参考噪声图
    %         isRef = contains(flat_files(k).name,'_vid1_i_ref.jpg');
    % 
    %         % 如果是参考噪声图,保存信息
    %         if isRef == 1
    %             file_path = [folder_name '/flat_frames/' flat_folder_name '/' flat_files(k).name];
    %             ref_img_info(i).ref_flat = imread(file_path);
    %         end 
    %     end
    % end

    % 遍历indoor_frames文件夹
    % indoor_folders = dir([folder_name '/indoor_frames']);

    % for j = 1:length(indoor_folders)               
    % 
    %     % 获取子文件夹名称 
    %     indoor_folder_name = indoor_folders(j).name; 
    % 
    %     % 判断是否为隐藏文件,如果是则跳过
    %     if indoor_folder_name(1) == '.'
    %     	continue
    %     end
    % 
    %     % 遍历子文件夹下文件
    %     indoor_files = dir([folder_name '/indoor_frames/' indoor_folder_name]);
    %     for k = 1:length(indoor_files)  
    % 
    %         % 判断是否为参考噪声图
    %         isRef = contains(indoor_files(k).name,'_vid1_i_ref.jpg');
    % 
    %         % 如果是参考噪声图,保存信息
    %         if isRef == 1
    %             file_path = [folder_name '/indoor_frames/' indoor_folder_name '/' indoor_files(k).name];
    %             ref_img_info(i).ref_indoor = imread(file_path);
    %         end 
    %     end
    % end

    % 遍历outdoor_frames文件夹
%     outdoor_folders = dir([folder_name '/outdoor_frames']);
%     for j = 1:length(outdoor_folders)               
% 
%         % 获取子文件夹名称 
%         outdoor_folder_name = outdoor_folders(j).name; 
% 
%         % 判断是否为隐藏文件,如果是则跳过
%         if outdoor_folder_name(1) == '.'
%         	continue
%         end
% 
%         % 遍历子文件夹下文件
%         outdoor_files = dir([folder_name '/outdoor_frames/' outdoor_folder_name]);
%         for k = 1:length(outdoor_files)  
% 
%             % 判断是否为参考噪声图
%             isRef = contains(outdoor_files(k).name,'_vid1_i_ref.jpg');
% 
%             % 如果是参考噪声图,保存信息
%             if isRef == 1
%                 file_path = [folder_name '/outdoor_frames/' outdoor_folder_name '/' outdoor_files(k).name];
%                 ref_img_info(i).ref_outdoor = imread(file_path);
%             end 
%         end
%     end
% end  


% 遍历所有非参考噪声图,计算相关系数,并写入文件
get_ref_corr(folder_names, 'flat', ref_img_info);
get_ref_corr(folder_names, 'indoor', ref_img_info);
get_ref_corr(folder_names, 'outdoor', ref_img_info);

% for i = 1:length(folder_names)  
% 
%     % flat_frames 
%     flat_folders = dir([folder_name '/flat_frames']);
%     for j = 1:length(flat_folders)                  
%         % 子文件夹名称
%         flat_folder_name = flat_folders(j).name;     
% 
%         % 判断是否为隐藏文件,如果是则跳过
%         if flat_folder_name(1) == '.'
%             continue
%         end  
% 
%         % 遍历子文件夹下文件
%         flat_files = dir([folder_name '/flat_frames/' flat_folder_name]);
%         for k = 1:length(flat_files)
% 
% 	        % 判断是否为隐藏文件,如果是则跳过
% 	        if flat_files(k).name(1) == '.'
% 	        	continue
% 	        end
% 
%             % 判断是否为参考噪声图
%             isRef = contains(flat_files(k).name,'_vid1_i_ref.jpg'); 
%             % 如果是非参考噪声图,计算相关系数
%             if isRef == 1
%                 file_path = [folder_name '/flat_frames/' flat_folder_name '/' flat_files(k).name];
%                 curr_img = imread(file_path);
%                 corr_flat = corr2_rgb(ref_img_info(i).ref_flat,curr_img);
%                 % 将结果写入csv文件
%                 fprintf(fid1,'%s,%s,%.4f\n',file_path,ref_img_info(i).ref_flat,corr_flat);    
%             end
%         end
%     end
% 
%     % indoor_frames
%     outdoor_folders = dir([folder_name '/outdoor_frames']);
%     for j = 1:length(outdoor_folders)                  
%         % 子文件夹名称
%         outdoor_folder_name = outdoor_folders(j).name;     
% 
%         % 判断是否为隐藏文件,如果是则跳过
%         if outdoor_folder_name.name(1) == '.'
%             continue
%         end  
% 
%         % 遍历子文件夹下文件
%         outdoor_files = dir([folder_name '/outdoor_frames/' outdoor_folder_name]);
%         for k = 1:length(outdoor_files)
% 
% 	        % 判断是否为隐藏文件,如果是则跳过
% 	        if outdoor_files(k).name(1) == '.'
% 	        	continue
% 	        end
% 
%             % 判断是否为参考噪声图
%             isRef = contains(outdoor_files(k).name,'_vid1_i_ref.jpg'); 
%             % 如果是非参考噪声图,计算相关系数
%             if isRef == 0
%                 file_path = [folder_name '/outdoor_frames/' outdoor_folder_name '/' outdoor_files(k).name];
%                 curr_img = imread(file_path);
%                 corr_outdoor = corr2_rgb(ref_img_info(i).ref_outdoor,curr_img);
%                 % 将结果写入csv文件
%                 fprintf(fid1,'%s,%s,%.4f\n',file_path,ref_img_info(i).ref_outdoor,corr_outdoor);    
%             end
%         end
%     end
% 
%     % outdoor_frames 
%     outdoor_folders = dir([folder_name '/outdoor_frames']);
%     for j = 1:length(outdoor_folders)                  
%         % 子文件夹名称
%         outdoor_folder_name = outdoor_folders(j).name;     
% 
%         % 判断是否为隐藏文件,如果是则跳过
%         if outdoor_folder_name.name(1) == '.'
%             continue
%         end  
% 
%         % 遍历子文件夹下文件
%         outdoor_files = dir([folder_name '/outdoor_frames/' outdoor_folder_name]);
%         for k = 1:length(outdoor_files)
% 
% 	        % 判断是否为隐藏文件,如果是则跳过
% 	        if outdoor_files(k).name(1) == '.'
% 	        	continue
% 	        end
% 
%             % 判断是否为参考噪声图
%             isRef = contains(outdoor_files(k).name,'_vid1_i_ref.jpg'); 
%             % 如果是非参考噪声图,计算相关系数
%             if isRef == 0
%                 file_path = [folder_name '/outdoor_frames/' outdoor_folder_name '/' outdoor_files(k).name];
%                 curr_img = imread(file_path);
%                 corr_outdoor = corr2_rgb(ref_img_info(i).ref_outdoor,curr_img);
%                 % 将结果写入csv文件
%                 fprintf(fid1,'%s,%s,%.4f\n',file_path,ref_img_info(i).ref_outdoor,corr_outdoor);    
%             end
%         end
%     end
% end

% % 关闭文件
% fclose(fid1); 
% fclose(fid2);
% fclose(fid3);
