clear all
clc
folder_names = {'D01_Samsung_GalaxyS3Mini'   'D02_Apple_iPhone4s'   'D03_Huawei_P9'     ...  
               'D04_LG_D290'   'D07_Lenovo_P70A'   'D12_Sony_XperiaZ1Compact' ...
               'D17_Microsoft_Lumia640LTE' 'D21_Wiko_Ridge4G'   'D23_Asus_Zenfone2Laser' ...
               'D24_Xiaomi_RedmiNote3'   'D25_OnePlus_A3000'};
video_folders = {'flat' 'indoor' 'outdoor'}; 
frame_folders = {'flat_frames' 'indoor_frames' 'outdoor_frames'};

% 声明video_counts二维数组
video_counts = zeros(numel(folder_names),numel(video_folders));

% 获取每个文件夹flat,indoor,outdoor的视频文件数量
for i = 1:numel(folder_names)
    for j = 1:numel(video_folders)
        folder_name = folder_names{i};
        video_folder = video_folders{j};
        if exist([folder_name '/' video_folder],'dir')
            %获取每个文件夹flat,indoor,outdoor的视频文件数量
            video_counts(i,j) = numel(dir([folder_name '/' video_folder '/D*'])); 
            disp(['video_counts(' num2str(i) ',' num2str(j) ')=' num2str(video_counts(i,j))]);
        end
    end 
end

filename = 'prnu_ref.csv';

% Check if file exists
file_exists = exist(filename);

% If file does not exist, create it
if file_exists == 0
    fid = fopen(filename,'w');
    fclose(fid);
end

% 参考 ref
for i = 1:numel(folder_names)
    for j = 1:numel(frame_folders)  
        folder_name = folder_names{i};
        frame_folder = frame_folders{j};
        for k = 1:video_counts(i,j)
            filename1 = [folder_name '_' frame_folder '_vid' num2str(k) '_i_ref.jpg'];
            filename2 = [folder_name '/' frame_folder '/vid' num2str(k) '/' folder_name '_' frame_folder '_vid' num2str(k) '_i_ref.jpg'];
            try
                I = imread(filename2);
                disp([filename1 '文件已经存在']);
            catch
                % 读取失败,执行后续操作
                mkdir('tmp');
    
                % Start timer
                tic  
    
                % 检查 ${folder_name}/${frame_folder}/vid${k}/i 目录下有多少个帧
                i_frame_num = numel(dir([folder_name '/' frame_folder '/vid' num2str(k) '/i/*.jpg']));
                disp([folder_name '/' frame_folder '/vid' num2str(k) '/i目录里有' num2str(i_frame_num) '帧']);
                extract([folder_name '/' frame_folder '/vid' num2str(k) '/i'],i_frame_num);
                copyfile('tmp/i.jpg',[folder_name '/' frame_folder '/vid' num2str(k) '/' folder_name '_' frame_folder '_vid' num2str(k) '_i_ref.jpg']); 
                rmdir('tmp','s');
    
    
                % End timer and display elapsed time  
                time = toc;
                disp(['Run ' folder_name '/' frame_folder '/vid' num2str(k) '/i' ': Elapsed time is '  num2str(time) ' seconds.']);  
    
                % Open CSV file and write data
                file = fopen('prnu_ref.csv','a');  
                fprintf(file,'%s, %f\n',[folder_name '/' frame_folder '/vid' num2str(k) '/i'],time);  
                fclose(file);
            end
        end
    end
end  

% 退出 matlab
return
