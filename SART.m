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
fbp = A_Inv(p);

% 3. ART�������������ӹ�һ����
art = zeros(size(x));
A_T_A = A_T(A(ones(size(art))));
epoch = 50;
for i = 1:epoch
    art = art + A_T(p - A(art)) ./ A_T_A;
    if mod(i,2) == 0
        subplot(5,5,i/2);
        imshow(art);
        title(sprintf("��%d��",i));
    end
end