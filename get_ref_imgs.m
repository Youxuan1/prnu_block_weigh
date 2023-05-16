function  ref_img_info = get_ref_imgs(folder_names, scene, ref_img_info)
%给保存了对应场景的参考噪声图片的结构体增添属性
%-------------------------------------------------------
 for i = 1:length(folder_names)
    % 当前文件夹名称
    folder_name = folder_names{i};  
    
    % 遍历flat_frames文件夹
    flat_folders = dir([folder_name '/flat_frames']);

    for j = 1:length(flat_folders)               
        
        % 获取子文件夹名称 
        flat_folder_name = flat_folders(j).name; 
        
        % 判断是否为隐藏文件,如果是则跳过
        if flat_folder_name(1) == '.'
            continue
        end  
    
        % 遍历子文件夹下文件
        flat_files = dir([folder_name '/' scene '_frames/' flat_folder_name]);
        for k = 1:length(flat_files)  
    
            % 判断是否为参考噪声图
            isRef = contains(flat_files(k).name,'_vid1_i_ref.jpg');
           
            % 如果是参考噪声图,保存信息
            if isRef == 1
                file_path = [folder_name '/' scene '_frames/' flat_folder_name '/' flat_files(k).name];
                ref_img_info(i).(['ref_' scene])= imread(file_path);
            end 
        end
    end
 end