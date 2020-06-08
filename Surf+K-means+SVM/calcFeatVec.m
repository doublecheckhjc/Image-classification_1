%%�����ֵ����ͼƬ����������
function featVec = calcFeatVec(features, centers,K)
featVec = zeros(1,K);
%m��ʾ������ĸ�����n��ʾ�������ά��
[m,n] = size(features);
for i = 1:m
    fi = features(i,:);
    %%������1*64�����ֵ���K*64����Ҫ����������ĸ��ʴ����
    res = zeros(K,64);
    for j = 1:K
        res(j,:) = fi;
    end
    %�������������Ʊ��K*64
    %�������
    distance = sum((res - centers).^2,2);
    distance = sqrt(distance);
    %���������������С�ľ���
    [x,y] = min(distance);
    featVec(y) = featVec(y)+1;
end
end
