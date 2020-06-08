%%根据字典计算图片的特征向量
function featVec = calcFeatVec(features, centers,K)
featVec = zeros(1,K);
%m表示特征点的个数，n表示特征点的维度
[m,n] = size(features);
for i = 1:m
    fi = features(i,:);
    %%特征是1*64，而字典是K*64，需要求该特征与哪个词袋最近
    res = zeros(K,64);
    for j = 1:K
        res(j,:) = fi;
    end
    %将该特征纵向复制变成K*64
    %求出距离
    distance = sum((res - centers).^2,2);
    distance = sqrt(distance);
    %将距离排序，求得最小的距离
    [x,y] = min(distance);
    featVec(y) = featVec(y)+1;
end
end
