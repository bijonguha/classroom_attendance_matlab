clc;
close all;
clear;
 
%read background image
background = imread('yeloback.png');
background = rgb2gray(background);
 
%Read Current Frame
currentFrame = imread('yelo2test.png');
currentFrame = rgb2gray(currentFrame);
 
%Display Background and Foreground
subplot(1,2,1);imshow(background);title('BackGround');
subplot(1,2,2);imshow(currentFrame);title('Current Frame');
 
%median filtering
BWm1= medfilt2(background);
BWm2= medfilt2(currentFrame);
 
%differencing
diff = imabsdiff( BWm1 , BWm2 );
 
%determine level for thresholding
level = graythresh(diff);
[level EM] = graythresh(diff);
 
%thresholding
BWmdt = im2bw(diff, level);
 
%dilation
SE = strel ('line',2,2);
BWmdtd = imdilate(BWmdt, SE);
BWmdtdi = imerode(BWmdtd, SE);
 
%median filtering
BWmdtdim = medfilt2(BWmdtdi);
 
figure
imshow(BWmdtdim,[]);

%------------------------------------------------------------------------

%faceDetection
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = currentFrame;

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;

%------------------------------------------------------------------------

%checking by differencing
 
att=ones(4,5);
att=att*0;
count=0;

BB(:,3) = BB(:,3) + BB(:,1);
BB(:,4) = BB(:,2) + BB(:,4);
  
for i = 0:3
    for j = 0:4
        if BWmdtdim( 60 + 153 * i, 49 + 115 * j ) == 1 || BWmdtdim( 60 - 20 + 153 * i, 49 + 115 * j  ) == 1 || BWmdtdim( 60 + 20 + 153 * i, 49 + 115 * j  ) == 1 || BWmdtdim( 60 + 153 * i, 49 - 20 + 115 * j  ) == 1 || BWmdtdim( 60 + 153 * i, 49 + 20 + 115 * j  ) == 1 
            for k = 1:size(BB,1)
                if 49+115*j > BB(k, 1) && 49+115*j < BB(k,3) && 60+153*i > BB(k, 2) && 60+153*i < BB(k,4)
                    att(i+1,j+1)=1; count = count + 1;
                    break;
                end
            end
        end  
       end
end
    
  
att
count



