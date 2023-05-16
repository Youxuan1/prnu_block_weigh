clear all
clc
camera_model_names = {'D01_Samsung_GalaxyS3Mini'   'D02_Apple_iPhone4s'   'D03_Huawei_P9'     ...  
               'D04_LG_D290'   'D07_Lenovo_P70A'   'D12_Sony_XperiaZ1Compact' ...
               'D17_Microsoft_Lumia640LTE' 'D21_Wiko_Ridge4G'   'D23_Asus_Zenfone2Laser' ...
               'D24_Xiaomi_RedmiNote3'   'D25_OnePlus_A3000'};
video_scene_names = {'flat' 'indoor' 'outdoor'}; 
frame_folders = {'flat_frames' 'indoor_frames' 'outdoor_frames'};

filename = 'prnu_corr_exp4.csv';

num_frames_for_voting = 31;

% Check if file exists
file_exists = exist(filename);

% If file does not exist, create it
if file_exists == 0
    fid = fopen(filename,'w');
    fclose(fid);
end

fid = fopen(filename,'w');

% 怎么分块
block_row_size_num = 2;
block_col_size_num = 2;

% 创建结构体保存参考噪声图信息
ref_img_info = struct(); 
for i = numel(folder_names)
    ref_dir_i = [camera_model_names{i} '/flat_frames/vid1/' camera_model_names{i} '_flat_frames_vid1_i_ref.jpg'];
	ref_dir_p = [camera_model_names{i} '/flat_frames/vid1/' camera_model_names{i} '_flat_frames_vid1_p_ref.jpg'];
    ref_img_info(i).name = [camera_model_names '_flat_frames_vid1_0.8i0.2p'];
	im_i = imread(ref_dir_i);
	im_p = imread(ref_dir_p);
    ref_img_info(i).photo = 0.8 * im_i + 0.2 * im_p;
    block_row_size = floor(size(ref_img_info(i).photo,1) / block_row_size_num);
    block_col_size = floor(size(ref_img_info(i).photo,2) / block_col_size_num);
	ref_img_info(i).block_2_2 = my_im2blocks(ref_img_info(i).photo, [block_row_size block_col_size]);
end

% 计算相关系数
for i = 1:numel(camera_model_names)
	for j = 1:3
		vid_files = dir([camera_model_names{i} '/' frame_folders{j} ]);
		for k = 1:numel(vid_files)
			% 排除隐藏文件
			if vid_files(k).name(1) == '.'
				continue
			end

			% 排除参考噪声
			if (j == 1) & (vid_files(k).name(end-3:end) == '.jpg')
				continue
			end
			
            disp(['当前待检视频为：' [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name] ]);

			frame_files = dir([camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i']);

			% 得到待测31 帧的blocks
			test_frames = struct();
			test_frames_count = 1;
            step = floor((numel(frame_files) - 3) / num_frames_for_voting); % 尽可能排除隐藏文件干扰
			abundance = mod((numel(frame_files) - 3) , num_frames_for_voting) ;
    		for frame_count = 4:step:(numel(frame_files) - abundance)
				test_frames(test_frames_count).name = [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i/' frame_files(frame_count).name];
				test_frames(test_frames_count).photo = imread([camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i/' frame_files(frame_count).name]);
                block_row_size = floor(size(test_frames(test_frames_count).photo, 1) / block_row_size_num);
                block_col_size = floor(size(test_frames(test_frames_count).photo, 2) / block_col_size_num);
				test_frames(test_frames_count).block_2_2 = my_im2blocks(test_frames(test_frames_count).photo, [block_row_size block_col_size]);
				test_frames_count = test_frames_count + 1;
            end
            clear test_frames_count

			block_num = 1;
			% 遍历每个子块
			for block_row = 1:block_row_size
				for block_col = 1:block_col_size
                    ticket_counter = struct();
					for ref_count = 1:numel(camera_model_names)
						ticket_counter(ref_count).name = camera_model_names{ref_count};
						ticket_counter(ref_count).tickets = 0;
                    end
                end
            end

			% 遍历每个子块
			for block_row = 1:block_row_size
				for block_col = 1:block_col_size

					voter = struct();
					voter_count = 1;
                    step = floor((numel(frame_files) - 3) / num_frames_for_voting); % 尽可能排除隐藏文件干扰
			        abundance = mod((numel(frame_files) - 3) , num_frames_for_voting) ;
					for frame_count = 4:step:(numel(frame_files) - abundance)
						voter(voter_count).name = [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i/' frame_files(frame_count).name 'block_num:' num2str(block_num)];
						voter_count = voter_count + 1;
                    end
                
                    voter_count = 1;
					for frame_count = 4:step:(numel(frame_files) - abundance)
						prnu_corr_exp3 = struct();

						for ref_count = 1:numel(camera_model_names)
							prnu_corr_exp3(ref_count).name = camera_model_names{ref_count};

							wait_to_test = test_frames(voter_count).block_2_2{(1 + floor((block_num - 1) / block_row_size)), (1 + mod((block_num - 1), block_col_size))};
							wait_to_test_prnu = algorithm1(wait_to_test);
                            
                            prnu_corr_exp3(ref_count).corr = corr2_rgb(wait_to_test_prnu ,  ref_img_info(ref_count).block_2_2{(1 + floor((block_num - 1) / block_row_size)), (1 + mod((block_num - 1), block_col_size))});
							fprintf(fid,[camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i/' frame_files(frame_count).name ' block:[' num2str((1 + floor((block_num - 1) / block_row_size))) '_' num2str((1 + mod((block_num - 1), block_col_size))) '],ref:' camera_model_names{ref_count} ',' num2str(prnu_corr_exp3(ref_count).corr) '\n']);
						end
                        disp(['待测帧' frame_files(frame_count).name ' block:[' num2str((1 + floor((block_num - 1) / block_row_size))) '_' num2str((1 + mod((block_num - 1), block_col_size))) '] 与所有参考之间相关系数计算完毕！']);

                        maxi = -1;

						% 找出 prnu_corr_exp3.corr 中的最大值
						for ref_count = 1:numel(camera_model_names)
							if prnu_corr_exp3(ref_count).corr > maxi
								maxi = prnu_corr_exp3(ref_count).corr;
								voter(voter_count).ref = camera_model_names{ref_count};
							end
							fprintf(fid, [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name '/i/' frame_files(frame_count).name ' block:[' num2str((1 + floor((block_num - 1) / block_row_size))) '_' num2str((1 + mod((block_num - 1), block_col_size))) '],voted ' voter(voter_count).ref ',with maxi-corr' num2str(maxi) '\n']);
						end
						clear prnu_corr_exp3 maxi
                        voter_count = voter_count + 1;
					end


					% 统计该分块的票数
					for vote_seq = 1:numel(voter)
						for ref_count = 1:numel(camera_model_names)
							if strcmp(voter(vote_seq).ref, ticket_counter(ref_count).name)
								ticket_counter(ref_count).tickets = ticket_counter(ref_count).tickets + 1;
							end
						end
					end
                    disp(['当前待检视频:' [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name] ' block:[' num2str((1 + floor((block_num - 1) / block_row_size))) '_' num2str((1 + mod((block_num - 1), block_col_size))) '] 计票完毕！']);


					% 找到该分块的票王
					% [max_tickets, winner] = max([ticket_counter.tickets]);
					winner = [];
					max_tickets = 0;
					for ref_count = 1:numel(camera_model_names)
						if ticket_counter(ref_count).tickets > max_tickets
							winner = ticket_counter(ref_count).name;
							max_tickets = ticket_counter(ref_count).tickets;
						end
					end

					fprintf(fid, [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name ' block:[' num2str((1 + floor((block_num - 1) / block_row_size))) '_' num2str((1 + mod((block_num - 1), block_col_size))) '],winner:' winner ',with ' num2str(max_tickets) 'tickets!\n---------------------------------------\n']);
					test_frames(frame_count).block_vote{(1 + floor((block_num - 1) / block_row_size)), (1 + mod((block_num - 1), block_col_size))} = winner;

					clear voter voter_count winner max_tickets step abundance ticket_counter
					block_num = block_num + 1;

				end
			end
			clear block_num

			block_tickets = struct();
			for ref_count = 1:numel(camera_model_names)
				block_tickets(ref_count).name = camera_model_names{ref_count};
				block_tickets(ref_count).tickets = 0; 
			end


			% 统计票数
			block_num = 1;
			for block_row = 1:block_row_size
				for block_col = 1:block_col_size
					for vote_seq = 1:numel(voter)
						for ref_count = 1:numel(camera_model_names)
							if strcmp(test_frames(vote_seq).block_vote{(1 + floor((block_num - 1) / block_row_size)), (1 + mod((block_num - 1), block_col_size))}, camera_model_names{ref_count})
								block_tickets(ref_count).tickets = block_tickets(ref_count).tickets + 1;
							end
						end
                    end
                    block_num = block_num + 1;
				end
			end
			clear block_num
            disp(['当前待检视频:' [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name] '块计票完毕！']);
					
			% 找到票王
			block_num = 1;
			for block_row = 1:block_row_size
				for block_col = 1:block_col_size

					% [max_corr, winner] = max([ticket_counter.tickets]);

					winner = [];
					max_tickets = 0;
					for ref_count = 1:numel(camera_model_names)
						if block_tickets(ref_count).tickets > max_tickets
							winner = block_tickets(ref_count).name;
							max_tickets = block_tickets(ref_count).tickets;
						end
					end

					block_num = block_num + 1;
				end
			end
			clear block_num

			fprintf(fid, [camera_model_names{i} '/' frame_folders{j} '/' vid_files(k).name ',' winner ',' max_tickets '\n===========================================\n']);

			clear winner  max_tickets
		end
	end
end

fclose(fid);







