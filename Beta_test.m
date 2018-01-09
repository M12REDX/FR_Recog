%Fingerprint Recognition Ver:1.00

%By m12redx

% include pathes
addpath('./Testing/');
addpath('./Shared/');
addpath('./vlfeat/');
addpath('./vlfeat/toolbox');
addpath('./RidgeFilter/');
addpath('./Sauvola/');

% run vlfeat setup
vl_setup

%load pic
img = imread('./images/12.jpg');

%pre_process
imgGs = grayscaleImage(img);
imgAcc = imgGs;
imgAcc = edge(imgAcc,'Sobel');
blksze = 36; thresh = 0.05;
gradientsigma = 1; blocksigma = 15; orientsmoothsigma = 13;
[newim, binim, mask] = testfin(imgGs, blksze, thresh, gradientsigma, blocksigma, orientsmoothsigma);

show(newim);
show(binim);

imgAcc = scaleImage(bwmorph(binim, 'thin', 'inf'), 0, 255);
show(imgAcc);


% extracts the Gabor features
u = 3; v = 10; m = 20; d2 = 2;
[~, ~, imgAcc] = gaborFeatures(imgAcc,gaborFilterBank(u,v,m,m), d2, d2);
imgAcc = adaptiveThresh(imgAcc, 4, 1, 'gaussian', 'relative');
imgAcc = scaleImage(bwmorph(imgAcc, 'thin', 'inf'), 0, 255);

%load_match
imgAcc = grayscaleImage(imread('./images/sift_12.jpg'));

%match
[f1,d1] = vl_sift(im2single(imgGs));
[f2,d2] = vl_sift(im2single(imgAcc));
[matches, scores] = vl_ubcmatch(d1,d2);
matchesOk = ransac(f1, f2, matches);

figure('NumberTitle', 'off', 'Name', 'Ridge'); clf;
subplot(1,2,1);
axis equal;
axis off;
axis tight;
hold on;
imshow(imgGs);
h1 = vl_plotframe(f1);
h2 = vl_plotframe(f1);
set(h1,'color','k','linewidth',4);
set(h2,'color','y','linewidth',3);
subplot(1,2,2);
axis equal;
axis off;
axis tight;
hold on;
imshow(imgAcc);
h1 = vl_plotframe(f2);
h2 = vl_plotframe(f2);
set(h1,'color','k','linewidth',4);
set(h2,'color','y','linewidth',3);
axis image off;

figure('NumberTitle', 'off', 'Name', 'Point'); clf;
imagesc(cat(2, imgGs, imgAcc));
colormap(gray);
x1 = f1(1,matches(1,:));
x2 = f2(1,matches(2,:)) + size(imgGs,2);
y1 = f1(2,matches(1,:));
y2 = f2(2,matches(2,:));
hold on;
h = line([x1; x2], [y1; y2]);
set(h,'linewidth', 1, 'color', 'b');
vl_plotframe(f1(:,matches(1,:)));
f2(1,:) = f2(1,:) + size(imgGs,2);
vl_plotframe(f2(:,matches(2,:)));
axis image off;










