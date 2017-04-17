function [] = Data_Visualization( data )
%��ֵ�����ݵĿ��ӻ�
global index;

%����ֱ��ͼ����qqͼ������ֲ��Ƿ�Ϊ��̬�ֲ���
%���ƺ�ͼ������Ⱥֵ����ʶ��
list = [4,5,6,16,19,20,22];
for i = 1:28
    if ismember(i, list)
        attribute = index(i);
        col = data(:, i);
        figure(find(list == i));
        subplot(1,3,1), hist(col), title(index(i));    %����ֱ��ͼ
        subplot(1,3,2), qqplot(col), title(index(i));   %����QQͼ
        subplot(1,3,3), boxplot(col), title(index(i));   %���ƺ�ͼ
    end
end

