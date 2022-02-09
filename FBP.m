clc;clear;
P = phantom(256);
theta = 1:180; %��ת�Ƕ�

% 1. ƽ����
[R,xp] = radon(P,theta);

% 2. Ƶ��任
width = 2^nextpow2(size(R,1)); % ����Ҷ�任�Ŀ��
proj_fft = fft(R, width);

% 3. �˲�
% Ramp �˲�����0 - width - 0��
filter = 2*[0:(width/2-1), width/2:-1:1]'/width;
proj_filtered = zeros(width,180);
for i = 1:180
    proj_filtered(:,i) = proj_fft(:,i).*filter;
end

% 4. ���任
proj_ifft = real(ifft(proj_filtered)); % ȡʵ���������鲿Ϊ0

% 5. ��ͶӰ
fbp = zeros(256);
for i = theta
% ���i��ͶӰ�ǣ�����ͶӰ����x��нǣ�����֮����� pi/2
    rad = deg2rad(i-1);
    for x = (-256/2+1):256/2
        for y = (-256/2+1):256/2
            t = round(x*cos(rad+pi/2)+y*sin(rad+pi/2));
            fbp(x+256/2,y+256/2)=fbp(x+256/2,y+256/2)+proj_ifft(t+round(size(R,1)/2),i);
        end
    end
end
fbp = fbp/180;
fbp = fbp/max(fbp(:));

subplot(1, 2, 1), imshow(P), title('Original')
subplot(1, 2, 2), imshow(fbp), title('FBP')