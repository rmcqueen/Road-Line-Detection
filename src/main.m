%% Performing KHT
clear;
addpath Realtime_Hough/matlab/;
videoReader = vision.VideoFileReader('source.mp4');
videoPlayer = vision.VideoPlayer('Name', 'KHT');
videoPlayer.Position(3:4) = [720, 1280];
while ~isDone(videoReader)
   frame = step(videoReader);
   frame = frame(400:size(frame, 1), :, :);
   % Store a temp frame to use with Otsu's Method
%    tempFrame = frame;
   imshow(frame, []);
   frame = rgb2gray(frame);
   frame = edge(frame, 'canny', 0.4, 3);
   % Otsu threshold to improve line boundaries (didn't work so well
   % unfortunately.)
%    otsuLevel = graythresh(tempFrame);
%    frame = im2bw(tempFrame, otsuLevel);
   frame = imdilate(frame, strel('disk', 2));
   % Segment the frame to the lower quadrant as we only care about it
   
   % Perform Kernal Hough Transform **SEE LICENSE FROM AUTHORS**
   lines = kht(frame);
   [height width c] = size(frame);
   % Specify how many lines you want to view. Determines the x most important
   relevantLines = 2;
   % Draw the j amount of relevant lines
   for j = 1:relevantLines
       % Remove unwanted horizontal lines, focus on the angled vertical
       % ones
       if sind(lines(j,2)) < 0.94
               x = [-width width/2-1];
               y = (lines(j,1) - x * cosd(lines(j,2))) / sind(lines(j,2));
               % Draw the boundaries between your side of the "road"
               result = patch(x + width / 2, y + height / 2, [1 1 0], 'EdgeColor', 'b', 'LineWidth', 5); % Draws lane lines
               % Draw estimated lane divider
               line([(x(:,1) + width + y(:,2)), x(:,2) - asind(y(:,2)/x(:,2))], [y(:,1)+width/2, ((y(:,2) + y(:,1))/2)- asind(y(:,2)/x(:,2))], 'Color', 'g', 'LineWidth', 5);
       end
   end
           
   step(videoPlayer, frame); % display the results
end
release(videoReader)


%% Traffic Sign Recognition
clear;
clc;
run('SIFT/vlfeat-0.9.20/toolbox/vl_setup');

% None of the SVM was used as we couldn't get it to be fully functional in
% time, and needed more train/test data.




% folder = 'Signs/turns/one_way_left';
% folder2 = 'Signs/turns/one_way_right';
% dirImage = dir( folder );
% dirImage2 = dir( folder2 ); 
% 
% numData = size(dirImage,1); 
% numData2 = size(dirImage2,1);
% M ={} ; 
% 
% for i=1:numData
%     nam = dirImage(i).name;
%     if regexp(nam, '[0-9].png')
%         B = cell(1,2); 
%         B{1,1} = double(imread([folder, '/', nam]));
%         B{1,2} = 1;  
%         M = cat(1,M,B); 
%     end
% end
% 
% for i=1:numData2
%     nam = dirImage2(i).name;
%     if regexp(nam, '[0-9].png')
%         B = cell(1,2); 
%         B{1,1} = double(imread([folder2, '/', nam]));
%         B{1,2} = -1;  
%         M = cat(1,M,B); 
%     end
% end
% 
% numDataTrain = size(M,1); 
% class = zeros(numDataTrain,1);
% arrayImage = zeros(numDataTrain, 100 * 100);
% 
% for i=1:numDataTrain
%     im = M{i,1} ;
%     im = rgb2gray(im); 
%     im = imresize(im, [100 100]); 
%     im = reshape(im', 1, 100*100); 
%     arrayImage(i,:) = im; 
%     class(i) = M{i,2}; 
% end
% 
% SVMStruct = svmtrain(arrayImage, class);

videoReader = VideoReader('source.mp4');
videoPlayer = vision.VideoPlayer('Name', 'SVM');
videoPlayer.Position(3:4) = [720, 1280];
for i = 1:20:videoReader.NumberOfFrames
    % Initialize the frame to read
    frame = read(videoReader, i);
    %imshow(frame, []); 
    frame = rgb2gray(frame);
    
    % Get the size for the upper third of the frame
    topSize = length(frame(1:size(frame(:, 1)), 2))/3;
    topThirdFrame = frame(1:topSize, :);
    
    % Load in the left one way street sign
    leftOneWay = rgb2gray(imread('Signs/turns/one_way_left/7.png'));
    
    % Get the right half of the frame only
    rightHalfFrame = frame(:, size(frame, 2)/2:end);
    % Load in the speed limit sign
    speedLimit = rgb2gray(imread('Signs/speed_limit/3.png'));
    
    leftOneWay = single(leftOneWay);
    peak_thresh = 5;
    edge_thresh = 10;
    [f1,d1] = vl_sift(leftOneWay,'PeakThresh', peak_thresh, 'edgethresh', edge_thresh );
    
    topThirdFrame=single(topThirdFrame);
    peak_thresh = 9;
    edge_thresh = 10; 
    [f2,d2] = vl_sift(topThirdFrame,'PeakThresh', peak_thresh,'edgethresh', edge_thresh );
    
    speedLimit = single(speedLimit);
    peak_thresh = 9;
    edge_thresh = 10;
    [f3,d3] = vl_sift(speedLimit,'PeakThresh', peak_thresh,'edgethresh', edge_thresh );
    
    frame = single(frame);
    % These parameters limit the number of features detected
    peak_thresh = 9; % increase to limit; default is 0
    edge_thresh = 10; % decrease to limit; default is 10
    [f4,d4] = vl_sift(frame,'PeakThresh', peak_thresh, 'edgethresh', edge_thresh );
    

    % Threshold for matching
    % Descriptor D1 is matched to a descriptor D2 only if the distance d(D1,D2)
    % multiplied by THRESH is not greater than the distance of D1 to all other descriptors
    thresh = 3; % Increases match limits
    [matches, scores] = vl_ubcmatch(d1, d2, thresh);
    if size(matches, 1) > 0
        indices1 = matches(1,:); % Get matching features
        f1match = f1(:,indices1);
        d1match = d1(:,indices1);
        indices2 = matches(2,:);
        f2match = f2(:,indices2);
        d2match = d2(:,indices2);
        drawBoxes(f2match, frame, 'one_way');
    end
    
    thresh = 6;
    [matches2, scores2] = vl_ubcmatch(d3, d4, thresh);
    if size(matches2, 1) > 0
        indices1 = matches2(1,:); % Get matching features
        f1match = f3(:,indices1);
        d1match = d3(:,indices1);
        indices2 = matches2(2,:);
        f2match = f4(:,indices2);
        d2match = d4(:,indices2);
        drawBoxes(f2match, frame, 'speed_limit');
    end
end
