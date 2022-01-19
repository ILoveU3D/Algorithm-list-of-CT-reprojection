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
gd = zeros(N); % һ������(FBP)
lambda = 1e-4; % �ݶ�ϵ��
alpha = 0.1; % ������ϵ������ֹ����ϣ�
epoch = 50;
for i = 1:epoch
    grad = A_T(A(gd) - p);
    gd = gd - grad * lambda - alpha * gd;
    gd = gd / max(gd(:));
    if mod(i,2) == 0
        subplot(5,5,i/2);
        imshow(gd);
        title(sprintf("��%d��",i));
    end
end