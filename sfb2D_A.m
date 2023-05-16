function y = sfb2D_A(lo, hi, sf, d)

% 2D Synthesis Filter Bank
% (along single dimension only)
%
% y = sfb2D_A(lo, hi, sf, d);
% sf - synthesis filters
% d  - dimension of filtering
% see afb2D_A


lpf = sf(:, 1);     % lowpass filter
hpf = sf(:, 2);     % highpass filter

if d == 2
   lo = lo';
   hi = hi';
end

N = 2*size(lo,1);
L = length(sf);


% y = upfirdn(lo, lpf, 2, 1) + upfirdn(hi, hpf, 2, 1);
y1 = upfirdn(lo, lpf, 2, 1);
y2 = upfirdn(hi, hpf, 2, 1);

size_y1 = size(y1);
size_y2 = size(y2);

if size_y1(1) ~= size_y2(1)  % 如果行数不同
    if size_y1(1) > size_y2(1)  
        y2 = [y2; zeros(size_y1(1)-size_y2(1), size_y2(2))];
    else
        y1 = [y1; zeros(size_y2(1)-size_y1(1), size_y1(2))];
    end
end 

if size_y1(2) ~= size_y2(2)   % 如果列数不同
    if size_y1(2) > size_y2(2)  
        y2 = [y2, zeros(size_y2(1), size_y1(2)-size_y2(2))]; 
    else
        y1 = [y1, zeros(size_y1(1), size_y2(2)-size_y1(2))];
    end
end

y = y1 + y2;     % 添加条件后的相加操作




y(1:L-2, :) = y(1:L-2, :) + y(N+[1:L-2], :);
y = y(1:N, :);
y = cshift2D(y, 1-L/2);

if d == 2
   y = y';
end

