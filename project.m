v = VideoReader('Project/source.mp4');
while hasFrame(v)
    video = readFrame(v);
end
whos video
imshow(video);