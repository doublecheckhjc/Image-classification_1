M=10;N=10;%M��Nѡ��
rgb=imread('H:\RGB\Normalized Brodatz\D5.tif');
[m,n,~]=size(rgb);
xb=round(m/M)*M;yb=round(n/N)*N;%�ҵ��ܱ�������M,N
rgb=imresize(rgb,[xb,yb]);
[m,n,c]=size(rgb);
count =1;
for i=1:M
    for j=1:N
        % 1�� �ֿ�
        block = rgb((i-1)*m/M+1:m/M*i,(j-1)*n/N+1:j*n/N,:); % ͼ��ֳɿ�
        %д��Ҫ��ÿһ��Ĳ���
        num = N*(i-1)+j;
        name = ['H:\RGB\Brodatz_patch\','5-',num2str(num),'.jpg'];
        imwrite(block,name);
%         subplot(M,N,count);
%         imshow(block);
%         count = count+1;
    end
end