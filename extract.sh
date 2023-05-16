folder_names=(D01_Samsung_GalaxyS3Mini   D02_Apple_iPhone4s   D03_Huawei_P9 
               D04_LG_D290   D07_Lenovo_P70A   D12_Sony_XperiaZ1Compact  
               D17_Microsoft_Lumia640LTE D21_Wiko_Ridge4G   D23_Asus_Zenfone2Laser 
               D24_Xiaomi_RedmiNote3   D25_OnePlus_A3000)
video_folders=(flat indoor outdoor)
frame_folders=(flat_frames indoor_frames outdoor_frames)
# 声明video_counts二维数组
declare -A video_counts

# 获取每个文件夹flat,indoor,outdoor的视频文件数量
for folder_name in "${folder_names[@]}"; do
 		for video_folder in "${video_folders[@]}"; do 
      	if [ -d "${folder_name}/${video_folder}" ]; then
          	vids=$(ls ${folder_name}/${video_folder} | wc -l)    
          
          	# 使用 . 连接文件夹和场景作为索引
          	video_counts[${folder_name}.${video_folder}_frames]=${vids}
          	echo "video_counts[${folder_name}.${video_folder}]=${vids}"
      	fi
 		done
done

# 建立${folder_name}/${frame_folder}
for folder_name in "${folder_names[@]}"; do
    for frame_folder in "${frame_folders[@]}"; do
      if [ -d "${folder_name}/${frame_folder}" ] ; then
      # 总文件夹存在 且 其下有其他子文件夹
        echo "Folder ${folder_name}/${frame_folder} exists."            
      else
      # 总文件夹不存在 或 其下无任何子文件夹 
        mkdir "${folder_name}/${frame_folder}"
        echo "Folder ${folder_name}/${frame_folder} created."
      fi
    done
done

# 建立${folder_name}/${frame_folder}/vid${i}
for folder_name in "${folder_names[@]}"; do
    for frame_folder in "${frame_folders[@]}"; do
        for ((i=1; i<=${video_counts[${folder_name}.${frame_folder}]}; i++)); do 
            # 1,2,3,...
            if [ -d "${folder_name}/${frame_folder}/vid${i}" ]; then
              echo "Folder ${folder_name}/${frame_folder}/vid${i} exists."
            else
              mkdir "${folder_name}/${frame_folder}/vid${i}"
              echo "Folder ${folder_name}/${frame_folder}/vid${i} created."
            fi
        done
    done
done

# 建立${folder_name}/${frame_folder}/vid${i}/i
for folder_name in "${folder_names[@]}"; do
    for frame_folder in "${frame_folders[@]}"; do
        for ((i=1; i<=${video_counts[${folder_name}.${frame_folder}]}; i++)); do 
            # 1/i,2/i,...
            if [ -d "${folder_name}/${frame_folder}/vid${i}/i" ]; then
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/i exists."
            else
              mkdir "${folder_name}/${frame_folder}/vid${i}/i"
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/i created."
            fi
            # 1/p,2/p,...
            if [ -d "${folder_name}/${frame_folder}/vid${i}/p" ]; then
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/p exists."
            else
              mkdir "${folder_name}/${frame_folder}/vid${i}/p"
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/p created."
            fi
            # 1/b,2/b,...
            if [ -d "${folder_name}/${frame_folder}/vid${i}/b" ]; then
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/b exists."
            else
              mkdir "${folder_name}/${frame_folder}/vid${i}/b"
              echo "Folder ${folder_name}/${frame_folder}/vid${i}/b created."
            fi
        done
    done
done

touch "run_time.csv"
for folder_name in "${folder_names[@]}"; do
	for video_folder in "${video_folders[@]}"; do
		# # 获取flat,indoor,outdoor目录中的第i个视频文件
		# video_num=${video_counts[${folder_name}.${video_folder}]}

		# ffmpeg
		for ((i=1; i<=${video_counts[${folder_name}.${video_folder}_frames]}; i++)); do 
			# timer_start
			start_time=$(date +%s)

			video_name=$(ls ${folder_name}/${video_folder} | sed -n "${i}p")

			#看看video_name内容是什么
			echo "video_name : ${folder_name}/${video_folder}/${video_name}"


			# I帧提取并保存
			if [ ! "$(ls -A "${folder_name}/${video_folder}_frames/vid${i}/i")" ]; then 
				ffmpeg -i "${folder_name}/${video_folder}/${video_name}" -vf select='eq(pict_type\,I)' -vsync 2 -f image2 "${folder_name}/${video_folder}_frames/vid${i}/i/i_frame_%04d.jpg"
			else 
	 			echo "Directory ${folder_name}/${video_folder}_frames/vid${i}/i is not empty"
			fi
			# P帧提取并保存
			if [ ! "$(ls -A "${folder_name}/${video_folder}_frames/vid${i}/p")" ]; then 
				ffmpeg -i "${folder_name}/${video_folder}/${video_name}" -vf select='eq(pict_type\,P)' -vsync 2 -f image2 "${folder_name}/${video_folder}_frames/vid${i}/p/p_frame_%04d.jpg"
			else 
	 			echo "Directory ${folder_name}/${video_folder}_frames/vid${i}/p is not empty"
			fi
			# B帧提取并保存
			if [ ! "$(ls -A "${folder_name}/${video_folder}_frames/vid${i}/b")" ]; then 
				ffmpeg -i "${folder_name}/${video_folder}/${video_name}" -vf select='eq(pict_type\,B)' -vsync 2 -f image2 "${folder_name}/${video_folder}_frames/vid${i}/b/b_frame_%04d.jpg"
			else 
	 			echo "Directory ${folder_name}/${video_folder}_frames/vid${i}/b is not empty"
			fi

			# timer_end
			end_time=$(date +%s)  
			time_elapsed=$((end_time - start_time))
			echo "${folder_name}/${video_folder}/${video_name},$((time_elapsed*1000)) ms" >> "run_time.csv"
		done

	done
done

# 退出 shell
exit









