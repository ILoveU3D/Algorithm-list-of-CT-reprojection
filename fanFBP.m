clc;clear;
p = phantom(256);

% 1. ����
D = 500;
projdata = fanbeam(p,D,'FanSensorGeometry','line','FanSensorSpacing',1,'FanRotationIncrement',1);
PrjD = flipud(projdata');

% 2. ����˲�����ʱ��
M = size(PrjD,2); % gamma�Ƿ�Χ
hRL = zeros(2*M-1,1);
for i = 1:M-1
    if mod(i,2) == 0
        hRL(i) = -1/(pi^2*(M-i)^2);
        hRL(2*M-i) = hRL(i);
    end
end
hRL(M) = 1/4;

% 3. ���
for i = 1:360
    for j = 1:M
        PrjD(i,j) = PrjD(i,j)*D/sqrt(D^2+(M/2-j+0.5)^2);
    end
    A = conv(PrjD(i,:),hRL);
    PrjD(i,:) = A(M:2*M-1);
end

% 4. ��ͶӰ
fbp = zeros(256);
for i = 1:360
    rad = deg2rad(i-1);
    for j = 1:256        
        for k = 1:256
            % ֱ������ת������
            XX = (j - 256/2)*cos(rad)+(256/2 - k)*sin(rad); %���������߾���Ĵ��ߣ�D-XX�Ƕ������С�Σ�
            YY = (256/2 - j)*sin(rad)+(256/2 - k)*cos(rad); %���������߾���
            dd = floor(M/2-YY/(D-XX)*D); %��̽�����ϵ�λ��
            if dd>0 && dd<M
                fbp(k,j) = fbp(k,j)+(D/(D-XX))^2*(PrjD(i,dd));
            end
        end
    end
end

subplot(1, 2, 1), imshow(p), title('Original')
subplot(1, 2, 2), imshow(fbp'/max(fbp(:))), title('FBP')