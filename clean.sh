folder_names=(D01_Samsung_GalaxyS3Mini   D02_Apple_iPhone4s   D03_Huawei_P9 
               D04_LG_D290   D07_Lenovo_P70A   D12_Sony_XperiaZ1Compact  
               D17_Microsoft_Lumia640LTE D21_Wiko_Ridge4G   D23_Asus_Zenfone2Laser 
               D24_Xiaomi_RedmiNote3   D25_OnePlus_A3000)
frame_folders=(flat_frames indoor_frames outdoor_frames)

for folder_name in "${folder_names[@]}"; do
	for frame_folder in "${frame_folders[@]}"; do 
		rm -rf "${folder_name}/${frame_folder}"
	done
done

rm "run_time.log"
