function [] = Data_Abstract( data )

global index

for i = 1:28
    %对标称属性统计频数
    if ismember(i, [1,2,3,7,8,9,10,11,12,13,14,15,17,18,21,23,24,25,26,27,28])
        attribute = index(i)
        col = data(:, i);
        col = col(find( ~ isnan(col)));
        strcol = num2str(col);
        tabulate(strcol(:));
    end
    % 数值属性，给出最大、最小、均值、中位数、四分位数及缺失值的个数
    if ismember(i, [4,5,6,16,19,20,22])
        attribute = index(i)
        col = data(:, i);
        nan_num = sum(isnan(col(:)));  %缺失值个数
        col = col(find( ~ isnan(col)));
        max_value = max(col);   %最大值
        min_value = min(col);   %最小值
        mean_value = mean(col);   %均值
        median_value = median(col);   %中位数
        Q1 = prctile(col, 25);   %上四分位数
        Q2 = prctile(col, 75);   %下四分位数
        Statistic_Info = ['Max Value:', num2str(max_value), '   Min Value:', num2str(min_value), '   Mean value:', num2str(mean_value), '   Median Value:', num2str(median_value), '   Q1 Value:', num2str(Q1), '   Q2 Value:', num2str(Q2), '   NaN Number:', num2str(nan_num)]
    end
end 

end