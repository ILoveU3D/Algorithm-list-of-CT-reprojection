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

% 3. E-M
ML_EM = rand(N);
A_T_A = A_T(A(ones(size(ML_EM))));
epoch = 50;
for i = 1:epoch
    ML_EM = ML_EM .* A_T(p ./ (A(ML_EM)+0.0001)) ./ A_T_A;
    ML_EM = ML_EM / max(ML_EM(:));
    if mod(i,2) == 0
        subplot(5,5,i/2);
        imshow(ML_EM);
        title(sprintf("第%d次",i));
    end
end