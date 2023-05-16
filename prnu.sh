folder_names=(D01_Samsung_GalaxyS3Mini   D02_Apple_iPhone4s   D03_Huawei_P9 
               D04_LG_D290   D07_Lenovo_P70A   D12_Sony_XperiaZ1Compact  
               D17_Microsoft_Lumia640LTE D21_Wiko_Ridge4G   D23_Asus_Zenfone2Laser 
               D24_Xiaomi_RedmiNote3   D25_OnePlus_A3000)
video_folders=(flat indoor outdoor)
frame_folders=(flat_frames indoor_frames outdoor_frames)
# 声明video_counts二维数组
declare -A video_counts

# # 启动 matlab
# matlab -nodesktop -nosplash

# # 等待 matlab 启动完毕
# sleep 5

# 建立临时文件夹 tmp 来存储搬运过来的视频帧
mkdir "tmp"

# 获取每个文件夹flat,indoor,outdoor的视频文件数量
for folder_name in "${folder_names[@]}"; do
   		for video_folder in "${video_folders[@]}"; do 
        	if [ -d "${folder_name}/${video_folder}" ]; then
            	#获取每个文件夹flat,indoor,outdoor的视频文件数量
            	vids=$(ls ${folder_name}/${video_folder} | wc -l)    
            
            	# 使用 . 连接文件夹和场景作为索引
            	video_counts[${folder_name}.${video_folder}]=${vids}
            	echo "video_counts[${folder_name}.${video_folder}]=${vids}"
        	fi
    	done
done

# 把一个视频的 i 帧搬运到 tmp，并保存 prnu 到帧文件夹下的对应视频目录里当参考 ref
for folder_name in "${folder_names[@]}"; do
	for frame_folder in "${frame_folders[@]}"; do
		for ((i=1; i<=${video_counts[${folder_name}.${video_folder}]}; i++)); do 
			# 检查 ${folder_name}/${frame_folder}/vids${i}/i 目录下有多少个帧
			i_frame_num=$(ls ${folder_name}/${frame_folder}/vids${i}/i/* | wc -l)
			echo ${i_frame_num}
			matlab -nodesktop -nosplash -r "extract(${folder_name}/${frame_folder}/vids${i}/i,${i_frame_num});"
			cp "tmp/i.jpg" "${folder_name}/${frame_folder}/vids${i}/${folder_name}_${frame_folder}_vids${i}_i_ref.jpg"
		done
	done
done

# 退出 matlab
matlab -nodesktop -nosplash -r "exit;"

# 移除临时文件夹 tmp
rm -rf "tmp"

# 退出 shell 脚本
exit