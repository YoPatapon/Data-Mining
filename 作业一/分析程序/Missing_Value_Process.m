function [ ] = Missing_Value_Process( data, option )
%% 分别使用下列四种策略对缺失值进行处理:
global index;

origin_data = data;

[m, n] = size(data); % 输入矩阵的大小
ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28;

standard_line = [data(1, ATTRIBUTE_L: ATTRIBUTE_H)]; % 取出一行无缺失的样本，作为方法2插值的依据

%% 将缺失部分剔除
if option == 1
    data(any(isnan(data),2),:) = [];
    xlswrite('MissingValueProcessFile1.xlsx', data);
    Data_Compare(origin_data, data);
end

%% 用最高频率值来填补缺失值
if option == 2
    for i = 1:28
        hf = mode(data(:, i));
        col = data(:, i);
        pos = find(isnan(col));
        data(pos, i) = hf;
        xlswrite('MissingValueProcessFile2.xlsx', data);
    end
    Data_Compare(origin_data, data);
end

%% 通过属性的相关关系来填补缺失值
if option == 3
    cor_mat = correlation_mat_attribute(data);
    cor_size = size(cor_mat, 1); % 矩阵大小，正常情况下是方阵
    for i = 1: m
        for j = ATTRIBUTE_L: ATTRIBUTE_H
            if(isnan(data(i, j)))
                [~, index] = sort(cor_mat(j - ATTRIBUTE_L + 1, :));
                index_list = fliplr(index); % sort升序，fliplr翻转，变成降序，得到参考的属性优先度列表
                flag = 0; % 标识是否补全成功
                for k = 1: cor_size
                    ref_attr = index_list(k); % 用于补全参考的属性
                    if(~isnan(data(i, ref_attr)))
                        data(i, j) = standard_line(j - ATTRIBUTE_L + 1) / standard_line(ref_attr) * ...
                            data(i, ref_attr + ATTRIBUTE_L - 1); % 按比例补全（这不是最好的方法）
                        flag = 1;
                        break;
                    end
                end
                if(flag == 0)
                    disp(['Insert fail at row ', num2str(i), ' col ', num2str(j)]);
                        return ;
                end
            end
        end
    end
    xlswrite('MissingValueProcessFile3.xlsx', data);
    Data_Compare(origin_data, data);
end    
%% 通过数据对象之间的相似性来填补缺失值
if option == 4
    sim_mat = similarity_mat_sample(data); % 获得相关性矩阵，函数见下
    sim_size = size(sim_mat, 1); % 矩阵大小，正常情况下是方阵
    for i = 1: m
        for j = ATTRIBUTE_L: ATTRIBUTE_H
            if(isnan(data(i, j)))
                [~, index_list] = sort(sim_mat(i, :));
                flag = 0; % 标识是否补全成功
                for k = 1: sim_size
                    ref_samp = index_list(k); % 用于补全参考的属性
                    if(~isnan(data(ref_samp, j)))
                        data(i, j) = data(ref_samp, j); % 原样填上，补全
                        flag = 1;
                        break;
                    end
                end
                if(flag == 0)
                    disp(['Insert fail at row ', num2str(i), ' col ', num2str(j)]);
                    return ;
                end
            end
        end
    end
    xlswrite('MissingValueProcessFile4.xlsx', data);
    Data_Compare(origin_data, data);
end

end

%% CORRELATION_MAT_ATTRIBUTE 计算属性之间的相关性矩阵。
function cor_mat = correlation_mat_attribute(analytic_mat)
%   就是行和列都是属性，value(i,j)是属性i和属性j的相关性。它是对称矩阵哟。
ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28; % 在本数据集中属性23~28没有缺失值
COR_SIZE = ATTRIBUTE_H - ATTRIBUTE_L + 1; % 相关性矩阵的大小

cor_mat = -ones(COR_SIZE, COR_SIZE); % 初始化相关性矩阵，由于要取最大相关性，初始为最小值（-1）
for i = ATTRIBUTE_L: ATTRIBUTE_H - 1
    for j = i + 1: ATTRIBUTE_H
        %merge = [[analytic_mat(:, i)]', [analytic_mat(:, j)]']; % 将待求相关系数的两列并起来
        merge = analytic_mat(:, [i, j]);
        [NaN_line, ~] = find(isnan(merge) == 1);
        merge(NaN_line, :) = []; % 删掉含有NaN的行以便正确求解相关系数
        
        cor_indx = i - ATTRIBUTE_L + 1;
        cor_indy = j - ATTRIBUTE_L + 1; % 相关性矩阵下标
        cor_mat(cor_indx, cor_indy) = corr(merge(:, 1), merge(:, 2)); % merge的两列即去除NaN的两属性，求相关系数
        cor_mat(cor_indy, cor_indx) = cor_mat(cor_indx, cor_indy); % 对称矩阵
    end
end
cor_mat(isnan(cor_mat)) = -1;
end

%% SIMILARITY_MAT_SAMPLE 计算各个样本间的相似性。与correlation_mat_attribute类似。
function sim_mat = similarity_mat_sample(analytic_mat)

%   此处相似性实际上求了欧几里得距离，因此越小越相似。其余与上述函数类似，不做多余的注释。

ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28; 

SIM_SIZE = size(analytic_mat, 1); % 相似矩阵大小，与analytic_mat样本数一致

sim_mat = ones(SIM_SIZE, SIM_SIZE) * 999; % 初始化为最大距离
for i = 1: SIM_SIZE - 1
    for j = i + 1: SIM_SIZE
        merge = [[analytic_mat(i, ATTRIBUTE_L: ATTRIBUTE_H)]', ...
            [analytic_mat(j, ATTRIBUTE_L: ATTRIBUTE_H)]']; % 将两行样本转置合并为属性数x2的矩阵
        [NaN_line, ~] = find(isnan(merge) == 1);
        merge(NaN_line, :) = [];
        
        sim_mat(i, j) = norm(merge(:, 1) - merge(:, 2)); % 两样本的欧几里得距离
        sim_mat(j, i) = sim_mat(i, j); % 对称矩阵
    end
end

end

%% 数值型数据缺失值处理前后对比
function [] = Data_Compare( odata, ndata )

global index;

%绘制直方图，用qq图检验其分布是否为正态分布。 
%绘制盒图，对离群值进行识别
list = [4,5,6,16,19,20,22];
for i = 1:28
    if ismember(i, list)
        attribute = index(i);
        ocol = odata(:, i);
        ncol = ndata(:, i);
        figure(find(list == i));
        subplot(2,3,1), hist(ocol), title(['处理前的直方图：',index(i)]);    %绘制原直方图
        subplot(2,3,2), qqplot(ocol), title(['处理前的QQ图：',index(i)]);   %绘制原QQ图
        subplot(2,3,3), boxplot(ocol), title(['处理前的盒图：',index(i)]);   %绘制原盒图
        subplot(2,3,4), hist(ncol), title(['处理后的直方图：',index(i)]);    %绘制处理后直方图
        subplot(2,3,5), qqplot(ncol), title(['处理后的QQ图：',index(i)]);   %绘制处理后QQ图
        subplot(2,3,6), boxplot(ncol), title(['处理后的盒图：',index(i)]);   %绘制处理后盒图
    end
end

end