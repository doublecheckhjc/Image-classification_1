clear
clc
close  all

%第一步：求全部图像的surf的特征点，结果是一个M*N的矩阵，M是全部图像的全部特征点的个数，N是sitf算法得出特征的长度
all_features = [];
for u=7:1:15
    for v=1:1:50
        str=['H:\RGB\7-15\',num2str(u),'-',num2str(v),'.jpg'];
        img = imread(str);
        features = calcSurfFeature(img);
        all_features = [all_features;features];
        fprintf('已完成第%d类第%d个样本\n',u,v);
    end
end
fprintf('已完成第一步取出全部图像的特征点\n--------接下来进行第二步构建词典------------');

%第二步：根据上一步得到的特征点的集合开始聚类，方法是K-means或K-medoids.得到词典也叫词包。P*N的矩阵，P是特征的个数，N同上
centers = learnVocabulary(all_features,64);  %参数是特征点集合和聚类个数
fprintf('已完成第二步求出聚类中心\n--------接下来进行第三步计算每个图像的特征频率直方图------------');

%第三步：计算特征频率直方图也就是特征向量。一个图像会得到一行特征向量，所以特征向量是H*K，H是图像个数，K是聚类中心数。
new_featVec = [];
for u=7:1:15
    for v=1:1:50
        str=['H:\RGB\7-15\',num2str(u),'-',num2str(v),'.jpg'];
        img = imread(str);
        features = calcSurfFeature(img);
        featVec = calcFeatVec(features, centers,64);
        new_featVec = [new_featVec;featVec];
        fprintf('已完成第%d类第%d个样本的特征向量的输入\n',u,v);
    end
end
fprintf('已完成第三步求出特征向量\n--------接下来进行第四步送进SVM训练并分类------------');

%第四步
result = new_featVec;

%数据归一化
result= mapminmax(result,0,1); 

%数据划分
train_train = [result(1:40,:);result(51:90,:);result(101:140,:);result(151:190,:);result(201:240,:);result(251:290,:);result(301:340,:);result(351:390,:);result(401:440,:)];
test_simulation = [result(41:50,:);result(91:100,:);result(141:150,:);result(191:200,:);result(241:250,:);result(291:300,:);result(341:350,:);result(391:400,:);result(441:450,:)];

%训练标签
k=1;
trainlabel=[];
for i = 1:1:9
    for j=1:1:40
        trainlabel = [trainlabel;k];
    end
    k=k+1;
end
%测试标签
k=1;
testlabel=[];
for i = 1:1:9
    for j=1:1:10
        testlabel = [testlabel;k];
    end
    k=k+1;
end

%网格搜索法搜索最佳参数
% [bestacc,bestc,bestg] = SVMcgForClass(trainlabel,train_train,-8,8,-8,8,3,1,1,4.5);

%训练并分类
model = svmtrain(trainlabel, train_train, '-c 128 -g 0.03 -t 2');%核函数
[predict_label, accuracy] = svmpredict(testlabel, test_simulation, model);
fprintf('---------------------本程序结束----------------\n');