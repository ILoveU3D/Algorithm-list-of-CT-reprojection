clc;clear;
% 1. 定义正交算子
theta = 1:180;
N = 256;
A = @(x) radon(x,theta);
A_T = @(x) imresize(iradon(x,theta,"Linear","none"),[N,N]);
A_Inv = @(x) imresize(iradon(x,theta),[N,N]);

% 2. 图像
x = phantom(N);
p = A(x);

% 3. 定义为正态分布下的岭回归
gd = zeros(N); % 一个先验(FBP)
lambda = 1e-4; % 梯度系数
alpha = 0.1; % 正则项系数（防止过拟合）
epoch = 50;
for i = 1:epoch
    grad = A_T(A(gd) - p);
    gd = gd - grad * lambda - alpha * gd;
    gd = gd / max(gd(:));
    if mod(i,2) == 0
        subplot(5,5,i/2);
        imshow(gd);
        title(sprintf("第%d次",i));
    end
end