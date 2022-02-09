clc;clear;
% 1. 定义正交算子
theta = 1:180;
N = 256;
A = @(x) radon(x,theta);
A_T = @(x) imresize(iradon(x,theta,"Linear","none"),[N,N]);
A_Inv = @(x) imresize(iradon(x,theta),[N,N]);
L1 = @(x) norm(x,1);
L2 = @(x) power(norm(x,'fro'),2);
CostFun = @(x,y,lambda) 0.5 * L2(A(x)-y) + lambda * L1(x);

% 2. 图像
x = phantom(N);
p = A(x);
fbp = A_Inv(p);

% 4. FISTA迭代
epoch = 100;
lambda = 0.1;
L = 5e-4;
I = zeros(size(x));
t = 1;
Ip = I;
y = I;
for i = 1:epoch
    d = y - L * A_T(A(y) - p);
    I = max((abs(d) - lambda * L),0) .* sign(d);
    tp = (1+sqrt(1+4*t^2))/2;
    y = I + (t - 1)/tp * (I - Ip);
    Ip = I;
    t = tp;
    if mod(i,10) == 0
        subplot(2,5,i/10);
        imshow(I);
        title(sprintf("第%d次 cost=%d",i,CostFun(I,p,lambda)));
    end
end