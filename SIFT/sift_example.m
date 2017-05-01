run('SIFT/vlfeat-0.9.20/toolbox/vl_setup');
Img1= imread('SIFT/Capture3.JPG');
if size(Img1,3)>1 
    Img1 = rgb2gray(Img1); 
end
Img1 = single(Img1); % Convert to single precision floating point
imshow(Img1,[]);
% These parameters limit the number of features detected
peak_thresh = 5; % increase to limit; default is 0
edge_thresh = 10; % decrease to limit; default is 10
[f1,d1] = vl_sift(Img1,'PeakThresh', peak_thresh, 'edgethresh', edge_thresh );
% % Show all SIFT features detected
h = vl_plotframe(f1) ;
set(h,'color','r','linewidth',1) ;

I2 = imread('SIFT/Capture.JPG') ;
if size(I2,3)>1 I2 = rgb2gray(I2); end
I2=single(I2);
figure, imshow(I2,[]);
% These parameters limit the number of features detected
peak_thresh = 5; % increase to limit; default is 0
edge_thresh = 10; % decrease to limit; default is 10
[f2,d2] = vl_sift(I2,'PeakThresh', peak_thresh,'edgethresh', edge_thresh );
% Show all SIFT features detected
h = vl_plotframe(f2) ;
set(h,'color','y','linewidth',2) ; 

% Threshold for matching
% Descriptor D1 is matched to a descriptor D2 only if the distance d(D1,D2)
% multiplied by THRESH is not greater than the distance of D1 to all other descriptors
thresh = 2.5; % default = 1.5; increase to limit matches
[matches, scores] = vl_ubcmatch(d1, d2, thresh);
indices1 = matches(1,:); % Get matching features
f1match = f1(:,indices1);
d1match = d1(:,indices1);
indices2 = matches(2,:);
f2match = f2(:,indices2);
d2match = d2(:,indices2);
% Show matches
x = zeros(size(f2match,2), 1);
y = zeros(size(f2match,2), 1);
for i=1:size(f2match,2)
    x(i) = f2match(1, i);
    y(i) = f2match(2, i);
end
figure, imshow(I2,[]);
rectangle('Position', [y(x==min(x)), min(y(:)) , min(x(:)) - min(y(:)), max(y(:)) - min(y(:))], 'LineWidth', 2, 'EdgeColor', 'g');


