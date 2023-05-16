function y = zeropad(x, targetSize)
sizeX = size(x);       % 获取x当前大小  
padSize = targetSize - sizeX;  % 计算需要填充的大小

blockSize = 1024 * 1024;   % 设置分块大小  
x = mat2cell(x, blockSize, blockSize);  % 将x分块

y = cell(size(x));      % 创建空cell数组
for i = 1:numel(x)          
    y{i} = padarray(x{i}, [padSize padSize], 0, 'both');   % 对每块分别上采样  
end

y = cell2mat(y);        % 拼接上采样后的块