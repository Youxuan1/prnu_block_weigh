clear all
clc
folder_names = {'D01_Samsung_GalaxyS3Mini'   'D02_Apple_iPhone4s'   'D03_Huawei_P9'     ...  
               'D04_LG_D290'   'D07_Lenovo_P70A'   'D12_Sony_XperiaZ1Compact' ...
               'D17_Microsoft_Lumia640LTE' 'D21_Wiko_Ridge4G'   'D23_Asus_Zenfone2Laser' ...
               'D24_Xiaomi_RedmiNote3'   'D25_OnePlus_A3000'};
video_folder = 'flat'; 
frame_folder = 'flat_frames';

filename = 'prnu_ref_p_mini.csv';

% Check if file exists
file_exists = exist(filename);

% If file does not exist, create it
if file_exists == 0
    fid = fopen(filename,'w');
    fclose(fid);
end

% 参考 ref
for i = 1:numel(folder_names)
    folder_name = folder_names{i};
    filename1 = [folder_name '_' frame_folder '_vid1_p_ref.jpg'];
    filename2 = [folder_name '/' frame_folder '/vid1' '/' folder_name '_' frame_folder '_vid1_p_ref.jpg'];
    try
        I = imread(filename2);
        disp([filename1 '文件已经存在']);
    catch
        % 读取失败,执行后续操作
        mkdir('tmp');
        disp('Dir ./tmp/ is made');

        % Start timer
        tic 

        % 检查 ${folder_name}/${frame_folder}/vid1/p 目录下有多少个帧
        p_frame_num = numel(dir([folder_name '/' frame_folder '/vid1/p/*.jpg']));
        disp([folder_name '/' frame_folder '/vid1/p目录里有' num2str(p_frame_num) '帧']);
        extract_p([folder_name '/' frame_folder '/vid1/p'],p_frame_num);
        copyfile('tmp/prnu_p.jpg',[folder_name '/' frame_folder '/vid1/' folder_name '_' frame_folder '_vid1_p_ref.jpg']);
        disp([folder_name '_' frame_folder '_vid1_p_ref.jpg is writen']);
        % rmdir('tmp','s');
        % rename('tmp/','prnu_p');
        movefile('tmp',[folder_name '/' frame_folder '/vid1/prnu_p']);
        disp('Dir ./prnu_p/ is moved');

        % End timer and display elapsed time  
        time = toc;
        disp(['Run ' folder_name '/' frame_folder '/vid1/p' ': Elapsed time is '  num2str(time) ' seconds.']);  

        % Open CSV file and write data
        file = fopen(filename,'a');  
        fprintf(file,'%s/%s/vid1/p, %fs\n',folder_name,frame_folder,time);
        disp([folder_name '/' frame_folder '/vid1/p, ' num2str(time) 's has been writen in file' filename]);        
        fclose(file);
    end
end  

% 退出 matlab
return
