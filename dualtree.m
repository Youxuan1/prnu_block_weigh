function w = dualtree(x, J, Faf, af)

% Dual-tree Complex Discrete Wavelet Transform
%
% w = dualtree1D(x, J, Faf, af)
%
% OUTPUT
%   w{j}: scale j (j = 1..J)
%   w{j}{i}: tree i (i = 1,2)
%
% INPUT
%   x   : 1-D signal
%   J   : number of stages
%   Faf : first stage filter
%   af  : filter for remaining stages

% normalization
x = x/sqrt(2);

% Tree 1
[x1 w{1}{1}] = afb(x, Faf{1});
for k = 2:J
    [x1 w{k}{1}] = afb(x1, af{1});
end
w{J+1}{1} = x1;

% Tree 2
[x2 w{1}{2}] = afb(x, Faf{2});
for k = 2:J
    [x2 w{k}{2}] = afb(x2, af{2});
end
w{J+1}{2} = x2;