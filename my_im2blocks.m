function blocks = my_im2blocks(img, blk_size)
[m n c] = size(img);
nbr_blks_ver = floor(m/blk_size(1));   % 垂直方向块数 
nbr_blks_hor = floor(n/blk_size(2));   % 水平方向块数
blocks = cell(nbr_blks_ver, nbr_blks_hor);

for i = 1:nbr_blks_ver
    for j = 1:nbr_blks_hor
        row_start = (i-1)*blk_size(1) + 1;
        row_end = i*blk_size(1);
        col_start = (j-1)*blk_size(2) + 1;
        col_end = j*blk_size(2);
        
        blocks{i,j} = img(row_start:row_end, col_start:col_end, :);
    end 
end
