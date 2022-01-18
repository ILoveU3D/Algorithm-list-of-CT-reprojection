clc;clear;
p = phantom(256);

% 1. 扇束
D = 500;
projdata = fanbeam(p,D,'FanSensorGeometry','line','FanSensorSpacing',1,'FanRotationIncrement',1);
PrjD = flipud(projdata');

% 2. 设计滤波器（时域）
M = size(PrjD,2); % gamma角范围
hRL = zeros(2*M-1,1);
for i = 1:M-1
    if mod(i,2) == 0
        hRL(i) = -1/(pi^2*(M-i)^2);
        hRL(2*M-i) = hRL(i);
    end
end
hRL(M) = 1/4;

% 3. 卷积
for i = 1:360
    for j = 1:M
        PrjD(i,j) = PrjD(i,j)*D/sqrt(D^2+(M/2-j+0.5)^2);
    end
    A = conv(PrjD(i,:),hRL);
    PrjD(i,:) = A(M:2*M-1);
end

% 4. 反投影
fbp = zeros(256);
for i = 1:360
    rad = deg2rad(i-1);
    for j = 1:256        
        for k = 1:256
            % 直角坐标转极坐标
            XX = (j - 256/2)*cos(rad)+(256/2 - k)*sin(rad); %到中心射线距离的垂线（D-XX是多出来的小段）
            YY = (256/2 - j)*sin(rad)+(256/2 - k)*cos(rad); %到中心射线距离
            dd = floor(M/2-YY/(D-XX)*D); %在探测器上的位置
            if dd>0 && dd<M
                fbp(k,j) = fbp(k,j)+(D/(D-XX))^2*(PrjD(i,dd));
            end
        end
    end
end

subplot(1, 2, 1), imshow(p), title('Original')
subplot(1, 2, 2), imshow(fbp'/max(fbp(:))), title('FBP')