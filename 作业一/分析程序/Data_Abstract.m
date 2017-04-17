function [] = Data_Abstract( data )

global index

for i = 1:28
    %�Ա������ͳ��Ƶ��
    if ismember(i, [1,2,3,7,8,9,10,11,12,13,14,15,17,18,21,23,24,25,26,27,28])
        attribute = index(i)
        col = data(:, i);
        col = col(find( ~ isnan(col)));
        strcol = num2str(col);
        tabulate(strcol(:));
    end
    % ��ֵ���ԣ����������С����ֵ����λ�����ķ�λ����ȱʧֵ�ĸ���
    if ismember(i, [4,5,6,16,19,20,22])
        attribute = index(i)
        col = data(:, i);
        nan_num = sum(isnan(col(:)));  %ȱʧֵ����
        col = col(find( ~ isnan(col)));
        max_value = max(col);   %���ֵ
        min_value = min(col);   %��Сֵ
        mean_value = mean(col);   %��ֵ
        median_value = median(col);   %��λ��
        Q1 = prctile(col, 25);   %���ķ�λ��
        Q2 = prctile(col, 75);   %���ķ�λ��
        Statistic_Info = ['Max Value:', num2str(max_value), '   Min Value:', num2str(min_value), '   Mean value:', num2str(mean_value), '   Median Value:', num2str(median_value), '   Q1 Value:', num2str(Q1), '   Q2 Value:', num2str(Q2), '   NaN Number:', num2str(nan_num)]
    end
end 

end