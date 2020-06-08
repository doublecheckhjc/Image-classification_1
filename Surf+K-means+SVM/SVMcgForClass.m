function [bestacc,bestc,bestg] = SVMcgForClass(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
% 输入：
% train_label:训练集的标签，格式要求与svmtrain相同。
% train:训练集，格式要求与svmtrain相同。
% cmin,cmax:惩罚参数c的变化范围，即在[2^cmin,2^cmax]范围内寻找最佳的参数c，默认值为cmin=-8，cmax=8，即默认惩罚参数c的范围是[2^(-8),2^8]。
% gmin,gmax:RBF核参数g的变化范围，即在[2^gmin,2^gmax]范围内寻找最佳的RBF核参数g，默认值为gmin=-8，gmax=8，即默认RBF核参数g的范围是[2^(-8),2^8]。
% v:进行Cross Validation过程中的参数，即对训练集进行v-fold Cross Validation，默认为3，即默认进行3折CV过程。
% cstep,gstep:进行参数寻优是c和g的步进大小，即c的取值为2^cmin,2^(cmin+cstep),…,2^cmax,，g的取值为2^gmin,2^(gmin+gstep),…,2^gmax，默认取值为cstep=1,gstep=1。
% accstep:最后参数选择结果图中准确率离散化显示的步进间隔大小（[0,100]之间的一个数），默认为4.5。
% 输出：
% bestCVaccuracy:最终CV意义下的最佳分类准确率。
% bestc:最佳的参数c。
% bestg:最佳的参数g。
%% about the parameters of SVMcg 
if nargin < 10
    accstep = 4.5;
end
if nargin < 8
    cstep = 0.8;
    gstep = 0.8;
end
if nargin < 7
    v = 5;
end
if nargin < 5
    gmax = 8;
    gmin = -8;
end
if nargin < 3
    cmax = 8;
    cmin = -8;
end
%% X:c Y:g cg:CVaccuracy
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);

eps = 10^(-4);

%% record acc with different c & g,and find the bestacc with the smallest c
bestc = 1;
bestg = 0.1;
bestacc = 0;
basenum = 2;
for i = 1:m
    for j = 1:n
        cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) )];
        cg(i,j) = svmtrain(train_label, train, cmd);
        
        if cg(i,j) <= 55
            continue;
        end
        
        if cg(i,j) > bestacc
            bestacc = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end        
        
        if abs( cg(i,j)-bestacc )<=eps && bestc > basenum^X(i,j) 
            bestacc = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end        
        
    end
end
%% to draw the acc with different c & g
figure;
[C,h] = contour(X,Y,cg,70:accstep:100);
clabel(C,h,'Color','r');
xlabel('log2c','FontSize',12);
ylabel('log2g','FontSize',12);
firstline = 'SVC参数选择结果图(等高线图)[GridSearchMethod]'; 
secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
    ' CVAccuracy=',num2str(bestacc),'%'];
title({firstline;secondline},'Fontsize',12);
grid on; 

figure;
meshc(X,Y,cg);
% mesh(X,Y,cg);
% surf(X,Y,cg);
axis([cmin,cmax,gmin,gmax,30,100]);
xlabel('log2c','FontSize',12);
ylabel('log2g','FontSize',12);
zlabel('Accuracy(%)','FontSize',12);
firstline = 'SVC参数选择结果图(3D视图)[GridSearchMethod]'; 
secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
    ' CVAccuracy=',num2str(bestacc),'%'];
title({firstline;secondline},'Fontsize',12);