function [bestacc,bestc,bestg] = SVMcgForClass(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,accstep)
% ���룺
% train_label:ѵ�����ı�ǩ����ʽҪ����svmtrain��ͬ��
% train:ѵ��������ʽҪ����svmtrain��ͬ��
% cmin,cmax:�ͷ�����c�ı仯��Χ������[2^cmin,2^cmax]��Χ��Ѱ����ѵĲ���c��Ĭ��ֵΪcmin=-8��cmax=8����Ĭ�ϳͷ�����c�ķ�Χ��[2^(-8),2^8]��
% gmin,gmax:RBF�˲���g�ı仯��Χ������[2^gmin,2^gmax]��Χ��Ѱ����ѵ�RBF�˲���g��Ĭ��ֵΪgmin=-8��gmax=8����Ĭ��RBF�˲���g�ķ�Χ��[2^(-8),2^8]��
% v:����Cross Validation�����еĲ���������ѵ��������v-fold Cross Validation��Ĭ��Ϊ3����Ĭ�Ͻ���3��CV���̡�
% cstep,gstep:���в���Ѱ����c��g�Ĳ�����С����c��ȡֵΪ2^cmin,2^(cmin+cstep),��,2^cmax,��g��ȡֵΪ2^gmin,2^(gmin+gstep),��,2^gmax��Ĭ��ȡֵΪcstep=1,gstep=1��
% accstep:������ѡ����ͼ��׼ȷ����ɢ����ʾ�Ĳ��������С��[0,100]֮���һ��������Ĭ��Ϊ4.5��
% �����
% bestCVaccuracy:����CV�����µ���ѷ���׼ȷ�ʡ�
% bestc:��ѵĲ���c��
% bestg:��ѵĲ���g��
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
firstline = 'SVC����ѡ����ͼ(�ȸ���ͼ)[GridSearchMethod]'; 
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
firstline = 'SVC����ѡ����ͼ(3D��ͼ)[GridSearchMethod]'; 
secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ...
    ' CVAccuracy=',num2str(bestacc),'%'];
title({firstline;secondline},'Fontsize',12);