function features = calcSurfFeature(img)
%��ͼ��ת��Ϊ�Ҷ�ͼ��
gray = rgb2gray(img);
gray = double(gray);
a2=mean2(gray);
gray = gray - a2;
%����surf������
points = detectSURFFeatures(gray);
%������������
[features, vpts1] = extractFeatures(gray, points);
end
