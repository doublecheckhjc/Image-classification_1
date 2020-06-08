clear
clc
close  all

%��һ������ȫ��ͼ���surf�������㣬�����һ��M*N�ľ���M��ȫ��ͼ���ȫ��������ĸ�����N��sitf�㷨�ó������ĳ���
all_features = [];
for u=7:1:15
    for v=1:1:50
        str=['H:\RGB\7-15\',num2str(u),'-',num2str(v),'.jpg'];
        img = imread(str);
        features = calcSurfFeature(img);
        all_features = [all_features;features];
        fprintf('����ɵ�%d���%d������\n',u,v);
    end
end
fprintf('����ɵ�һ��ȡ��ȫ��ͼ���������\n--------���������еڶ��������ʵ�------------');

%�ڶ�����������һ���õ���������ļ��Ͽ�ʼ���࣬������K-means��K-medoids.�õ��ʵ�Ҳ�дʰ���P*N�ľ���P�������ĸ�����Nͬ��
centers = learnVocabulary(all_features,64);  %�����������㼯�Ϻ;������
fprintf('����ɵڶ��������������\n--------���������е���������ÿ��ͼ�������Ƶ��ֱ��ͼ------------');

%����������������Ƶ��ֱ��ͼҲ��������������һ��ͼ���õ�һ��������������������������H*K��H��ͼ�������K�Ǿ�����������
new_featVec = [];
for u=7:1:15
    for v=1:1:50
        str=['H:\RGB\7-15\',num2str(u),'-',num2str(v),'.jpg'];
        img = imread(str);
        features = calcSurfFeature(img);
        featVec = calcFeatVec(features, centers,64);
        new_featVec = [new_featVec;featVec];
        fprintf('����ɵ�%d���%d����������������������\n',u,v);
    end
end
fprintf('����ɵ����������������\n--------���������е��Ĳ��ͽ�SVMѵ��������------------');

%���Ĳ�
result = new_featVec;

%���ݹ�һ��
result= mapminmax(result,0,1); 

%���ݻ���
train_train = [result(1:40,:);result(51:90,:);result(101:140,:);result(151:190,:);result(201:240,:);result(251:290,:);result(301:340,:);result(351:390,:);result(401:440,:)];
test_simulation = [result(41:50,:);result(91:100,:);result(141:150,:);result(191:200,:);result(241:250,:);result(291:300,:);result(341:350,:);result(391:400,:);result(441:450,:)];

%ѵ����ǩ
k=1;
trainlabel=[];
for i = 1:1:9
    for j=1:1:40
        trainlabel = [trainlabel;k];
    end
    k=k+1;
end
%���Ա�ǩ
k=1;
testlabel=[];
for i = 1:1:9
    for j=1:1:10
        testlabel = [testlabel;k];
    end
    k=k+1;
end

%����������������Ѳ���
% [bestacc,bestc,bestg] = SVMcgForClass(trainlabel,train_train,-8,8,-8,8,3,1,1,4.5);

%ѵ��������
model = svmtrain(trainlabel, train_train, '-c 128 -g 0.03 -t 2');%�˺���
[predict_label, accuracy] = svmpredict(testlabel, test_simulation, model);
fprintf('---------------------���������----------------\n');