function features = calcSurfFeature(img)
%将图像转化为灰度图像
gray = rgb2gray(img);
gray = double(gray);
a2=mean2(gray);
gray = gray - a2;
%计算surf特征点
points = detectSURFFeatures(gray);
%计算描述向量
[features, vpts1] = extractFeatures(gray, points);
end
