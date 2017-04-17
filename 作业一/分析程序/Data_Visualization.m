function [] = Data_Visualization( data )
%数值型数据的可视化
global index;

%绘制直方图，用qq图检验其分布是否为正态分布。
%绘制盒图，对离群值进行识别
list = [4,5,6,16,19,20,22];
for i = 1:28
    if ismember(i, list)
        attribute = index(i);
        col = data(:, i);
        figure(find(list == i));
        subplot(1,3,1), hist(col), title(index(i));    %绘制直方图
        subplot(1,3,2), qqplot(col), title(index(i));   %绘制QQ图
        subplot(1,3,3), boxplot(col), title(index(i));   %绘制盒图
    end
end

