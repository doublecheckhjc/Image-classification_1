%%计算词袋
function centers = learnVocabulary(features,K)
%设置词袋数量
% use k-means to cluster a bag of features
%[聚类编号，点的位置] = [输入，聚类个数，初始中心点，聚类重复次数]
opts = statset('Display','final','MaxIter',1000);
% [idx ,centers] = kmeans(features ,K,'Replicates',10, 'Options',opts);
[idx ,centers] = kmedoids(features ,K,'Replicates',10, 'Options',opts);
end
