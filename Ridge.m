clc;clear;
% 1. ������������
theta = 1:180;
N = 256;
A = @(x) radon(x,theta);
A_T = @(x) imresize(iradon(x,theta,"Linear","none"),[N,N]);
A_Inv = @(x) imresize(iradon(x,theta),[N,N]);

% 2. ͼ��
x = phantom(N);
p = A(x);

% 3. ����Ϊ��̬�ֲ��µ���ع�
gd = A_Inv(p)'; % һ������(FBP)
lambda = 1; % �ݶ�ϵ��
alpha = 0.1; % ������ϵ������ֹ����ϣ�
epoch = 200;
A_T_A = A_T(A(ones(size(gd))));
for i = 1:epoch
    grad = A_T(A(gd) - p) ./ A_T_A;
    gd = gd - grad * lambda - alpha * gd;
    if mod(i,8) == 0
        subplot(5,5,i/8);
        imshow(gd);
        title(sprintf("��%d��",i));
    end
end