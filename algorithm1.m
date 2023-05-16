%基于方差稳定变换的多尺度迭代最小二乘滤波器
%------------------------------------------------------------------------------
%输入:视频帧Yz
%sigma=0.3;J=4;iter=1;lambda=1;q=0.2;epsilon=0.01;c=q*epsilon^(q/2-1);
%输出:噪声残差Nz
%------------------------------------------------------------------------------
function Nz = algorithm1(Yz)
%Yz = im2double(Yz);
heig = height(Yz);
widt = width(Yz);
sigma=0.3;J=4;iter=1;lambda=1;q=0.2;epsilon=0.01;c=q*epsilon^(q/2-1);
%第一步,计算方差稳定变换后的图像帧Yv
Yv = GenAnscombe_forward(Yz, sigma);
%第二步,在变换帧Yv上进行J阶DTCWT分解
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = cplxdual2D(Yv, J, Faf, af);
% Yv: 2-D signal
% J: number of stages
% Faf{i}: first stage filters for tree i
% af{i}:  filters for remaining stages on tree i
%
% Faf{i}(:,1), af{i}(:,1):   lowpass filter
% Faf{i}(:,2), af{i}(:, 2):  highpass filter 
%
% w: wavelet coefficients
%  w{1..J}{part}{d1}{d2}: 
%    scale = 1...J
%      part = 1 (real part), or part = 2 (imag part)
%      d1 = 1,2; d2 = 1,2,3 (orientations)
%  w{J+1}{m}{n}:
%      m = 1,2; n = 1,2 (lowpass subbands)
%------------------------------------------------------------------------------
%或者直接调用库函数
%[a,d] = dualtree2(Yv,'Level',4);
%a:final-level scaling (lowpass) coefficients;
%d:the tree A+iB wavelet coefficients at the finest scale
%------------------------------------------------------------------------------
%第三步,对每个高频子带,做迭代最小二乘滤波
%tree A
w{1}{1}{1}{1} = double(ILS_LNorm(w{1}{1}{1}{1}, lambda, q, epsilon, iter));
w{1}{1}{1}{2} = double(ILS_LNorm(w{1}{1}{1}{2}, lambda, q, epsilon, iter));
w{1}{1}{1}{3} = double(ILS_LNorm(w{1}{1}{1}{3}, lambda, q, epsilon, iter));
w{1}{1}{2}{1} = double(ILS_LNorm(w{1}{1}{2}{1}, lambda, q, epsilon, iter));
w{1}{1}{2}{2} = double(ILS_LNorm(w{1}{1}{2}{2}, lambda, q, epsilon, iter));
w{1}{1}{2}{3} = double(ILS_LNorm(w{1}{1}{2}{3}, lambda, q, epsilon, iter));
%tree B
w{1}{2}{1}{1} = double(ILS_LNorm(w{1}{2}{1}{1}, lambda, q, epsilon, iter));
w{1}{2}{1}{2} = double(ILS_LNorm(w{1}{2}{1}{2}, lambda, q, epsilon, iter));
w{1}{2}{1}{3} = double(ILS_LNorm(w{1}{2}{1}{3}, lambda, q, epsilon, iter));
w{1}{2}{2}{1} = double(ILS_LNorm(w{1}{2}{2}{1}, lambda, q, epsilon, iter));
w{1}{2}{2}{2} = double(ILS_LNorm(w{1}{2}{2}{2}, lambda, q, epsilon, iter));
w{1}{2}{2}{3} = double(ILS_LNorm(w{1}{2}{2}{3}, lambda, q, epsilon, iter));
%------------------------------------------------------------------------------
%第四步,把所有的小波子带反变换得到去噪帧Yp
Yp = icplxdual2D(w, J, Fsf, sf);
%------------------------------------------------------------------------------
%第五步,exact unbiased inverse of GAT
Yo = GenAnscombe_inverse_exact_unbiased(Yp, sigma);
%第步,计算噪声残差Nz
yo(:,:,1) = Yo(:,1:widt);
yo(:,:,2) = Yo(:,[1:widt]+widt);
yo(:,:,3) = Yo(:,[1:widt]+2*widt);

Nz = double(Yz) - yo;
%Nz = im2uint8(Nz);