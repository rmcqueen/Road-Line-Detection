# Description
This project takes an input video of a car driving down a road, computes the road boundaries, and estimates lane divider markings regardless of whether or not there is a strong edge present.

# Assumptions
1. Driving on the right side of a two-lane road (see the video for an example)

2. Driving during daylight; due to limitations on a sufficient quality video, night time conditions were not tested.

3. Speed limit signs are on the right side of the road

4. One way street signs are in the upper third of a frame

# Algorithm
1. Edge Detection (Canny Used)
    - The edges in the sample video are rather weak due to the illumination, and amount of noise caused by vehicles, the degraded road, and faded paint.
    - A low threshold was needed in order to preserve important edges.

2. Otsu's Method (Not Included due to improper usage)
    - Needed to segment regions in order to emphasize the road lines to allow for easier detection. The regions segmented were in the lower quadrants of frames due to that being the area of concern.

3. Dilation
    - To improve the detection of the Kernel Hough Transformation, dilation was used in order to increase the sizes of the edges.
    - An undesired effect of using dilation was the edges from shadows were also emphasized, however, this did not effect the detection.

4. Kernel Hough Transformation
    - Involves detecting the road boundary edges
    - A faster version of the classic Hough Transformation, and enables detection in real-time, however, due to the hardware constraints, the framerate of the source video was reduced heavily.
    - Please see the paper by Leandro A. F. Fernandes, and Manuel M. Oliveira titled, <i>Real-time line detection through an improved Hough transform voting scheme</i>

5. Lane Markings Estimation
    - TODO

6. Traffic Sign Recognition
    - Segment frames to look in the areas outlined in Assumptions to improve classification accuracy
    - Extract feature points of the speed limit signs, and one way street signs by using a training/testing dataset
    - Scale Invariant Feature Transform to locate the feature points in the frames

# Example of line detection
[![Line Detection](http://i.imgur.com/QgD2MPj.png)](https://vimeo.com/215546924 " Line Detection - Click to Watch!")

# Example of sign recognition
[![Traffic Sign Recognition](http://i.imgur.com/qY8jjn6.png)](https://vimeo.com/215547643 " Traffic Sign Recognition - Click to Watch!")

# Retrospective
- Otsu's Method should have been implemented using a local thresholding approach, as opposed to global thresholding. Global thresholding resulted in a heavy emphasis on areas with illumination corruption, and skewed the threshold value by a large margin.

- SIFT is very slow for a video feed, and an alternative approach should have been used. Perhaps a support vector machine (SVM) would produce better results.

- The frame rate of the video is extremely poor, and should be able to produce these results in near real-time. Further exploration into how to improve the framerate without sacrificing prediction quality should have been done.