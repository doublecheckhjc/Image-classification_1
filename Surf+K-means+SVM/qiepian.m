M=10;N=10;%M、N选择
rgb=imread('H:\RGB\Normalized Brodatz\D5.tif');
[m,n,~]=size(rgb);
xb=round(m/M)*M;yb=round(n/N)*N;%找到能被整除的M,N
rgb=imresize(rgb,[xb,yb]);
[m,n,c]=size(rgb);
count =1;
for i=1:M
    for j=1:N
        % 1） 分块
        block = rgb((i-1)*m/M+1:m/M*i,(j-1)*n/N+1:j*n/N,:); % 图像分成块
        %写上要对每一块的操作
        num = N*(i-1)+j;
        name = ['H:\RGB\Brodatz_patch\','5-',num2str(num),'.jpg'];
        imwrite(block,name);
%         subplot(M,N,count);
%         imshow(block);
%         count = count+1;
    end
end