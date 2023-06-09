clear all;
clc;
img1 = imread('img_01.jpg');
img1 = im2double(img1);
sigma=0.3;J=4;iter=1;lambda=1;q=0.2;epsilon=0.01;c=q*epsilon^(q/2-1);
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = cplxdual2D(img1, J, Faf, af);
Yp = icplxdual2D(w, J, Fsf, sf);
imshow(Yp);