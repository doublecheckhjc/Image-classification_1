%%����ʴ�
function centers = learnVocabulary(features,K)
%���ôʴ�����
% use k-means to cluster a bag of features
%[�����ţ����λ��] = [���룬�����������ʼ���ĵ㣬�����ظ�����]
opts = statset('Display','final','MaxIter',1000);
% [idx ,centers] = kmeans(features ,K,'Replicates',10, 'Options',opts);
[idx ,centers] = kmedoids(features ,K,'Replicates',10, 'Options',opts);
end
