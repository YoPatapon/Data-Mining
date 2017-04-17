function [ ] = Missing_Value_Process( data, option )
%% �ֱ�ʹ���������ֲ��Զ�ȱʧֵ���д���:
global index;

origin_data = data;

[m, n] = size(data); % �������Ĵ�С
ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28;

standard_line = [data(1, ATTRIBUTE_L: ATTRIBUTE_H)]; % ȡ��һ����ȱʧ����������Ϊ����2��ֵ������

%% ��ȱʧ�����޳�
if option == 1
    data(any(isnan(data),2),:) = [];
    xlswrite('MissingValueProcessFile1.xlsx', data);
    Data_Compare(origin_data, data);
end

%% �����Ƶ��ֵ���ȱʧֵ
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

%% ͨ�����Ե���ع�ϵ���ȱʧֵ
if option == 3
    cor_mat = correlation_mat_attribute(data);
    cor_size = size(cor_mat, 1); % �����С������������Ƿ���
    for i = 1: m
        for j = ATTRIBUTE_L: ATTRIBUTE_H
            if(isnan(data(i, j)))
                [~, index] = sort(cor_mat(j - ATTRIBUTE_L + 1, :));
                index_list = fliplr(index); % sort����fliplr��ת����ɽ��򣬵õ��ο����������ȶ��б�
                flag = 0; % ��ʶ�Ƿ�ȫ�ɹ�
                for k = 1: cor_size
                    ref_attr = index_list(k); % ���ڲ�ȫ�ο�������
                    if(~isnan(data(i, ref_attr)))
                        data(i, j) = standard_line(j - ATTRIBUTE_L + 1) / standard_line(ref_attr) * ...
                            data(i, ref_attr + ATTRIBUTE_L - 1); % ��������ȫ���ⲻ����õķ�����
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
%% ͨ�����ݶ���֮������������ȱʧֵ
if option == 4
    sim_mat = similarity_mat_sample(data); % �������Ծ��󣬺�������
    sim_size = size(sim_mat, 1); % �����С������������Ƿ���
    for i = 1: m
        for j = ATTRIBUTE_L: ATTRIBUTE_H
            if(isnan(data(i, j)))
                [~, index_list] = sort(sim_mat(i, :));
                flag = 0; % ��ʶ�Ƿ�ȫ�ɹ�
                for k = 1: sim_size
                    ref_samp = index_list(k); % ���ڲ�ȫ�ο�������
                    if(~isnan(data(ref_samp, j)))
                        data(i, j) = data(ref_samp, j); % ԭ�����ϣ���ȫ
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

%% CORRELATION_MAT_ATTRIBUTE ��������֮�������Ծ���
function cor_mat = correlation_mat_attribute(analytic_mat)
%   �����к��ж������ԣ�value(i,j)������i������j������ԡ����ǶԳƾ���Ӵ��
ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28; % �ڱ����ݼ�������23~28û��ȱʧֵ
COR_SIZE = ATTRIBUTE_H - ATTRIBUTE_L + 1; % ����Ծ���Ĵ�С

cor_mat = -ones(COR_SIZE, COR_SIZE); % ��ʼ������Ծ�������Ҫȡ�������ԣ���ʼΪ��Сֵ��-1��
for i = ATTRIBUTE_L: ATTRIBUTE_H - 1
    for j = i + 1: ATTRIBUTE_H
        %merge = [[analytic_mat(:, i)]', [analytic_mat(:, j)]']; % ���������ϵ�������в�����
        merge = analytic_mat(:, [i, j]);
        [NaN_line, ~] = find(isnan(merge) == 1);
        merge(NaN_line, :) = []; % ɾ������NaN�����Ա���ȷ������ϵ��
        
        cor_indx = i - ATTRIBUTE_L + 1;
        cor_indy = j - ATTRIBUTE_L + 1; % ����Ծ����±�
        cor_mat(cor_indx, cor_indy) = corr(merge(:, 1), merge(:, 2)); % merge�����м�ȥ��NaN�������ԣ������ϵ��
        cor_mat(cor_indy, cor_indx) = cor_mat(cor_indx, cor_indy); % �Գƾ���
    end
end
cor_mat(isnan(cor_mat)) = -1;
end

%% SIMILARITY_MAT_SAMPLE �������������������ԡ���correlation_mat_attribute���ơ�
function sim_mat = similarity_mat_sample(analytic_mat)

%   �˴�������ʵ��������ŷ����þ��룬���ԽСԽ���ơ������������������ƣ����������ע�͡�

ATTRIBUTE_L = 1;
ATTRIBUTE_H = 28; 

SIM_SIZE = size(analytic_mat, 1); % ���ƾ����С����analytic_mat������һ��

sim_mat = ones(SIM_SIZE, SIM_SIZE) * 999; % ��ʼ��Ϊ������
for i = 1: SIM_SIZE - 1
    for j = i + 1: SIM_SIZE
        merge = [[analytic_mat(i, ATTRIBUTE_L: ATTRIBUTE_H)]', ...
            [analytic_mat(j, ATTRIBUTE_L: ATTRIBUTE_H)]']; % ����������ת�úϲ�Ϊ������x2�ľ���
        [NaN_line, ~] = find(isnan(merge) == 1);
        merge(NaN_line, :) = [];
        
        sim_mat(i, j) = norm(merge(:, 1) - merge(:, 2)); % ��������ŷ����þ���
        sim_mat(j, i) = sim_mat(i, j); % �Գƾ���
    end
end

end

%% ��ֵ������ȱʧֵ����ǰ��Ա�
function [] = Data_Compare( odata, ndata )

global index;

%����ֱ��ͼ����qqͼ������ֲ��Ƿ�Ϊ��̬�ֲ��� 
%���ƺ�ͼ������Ⱥֵ����ʶ��
list = [4,5,6,16,19,20,22];
for i = 1:28
    if ismember(i, list)
        attribute = index(i);
        ocol = odata(:, i);
        ncol = ndata(:, i);
        figure(find(list == i));
        subplot(2,3,1), hist(ocol), title(['����ǰ��ֱ��ͼ��',index(i)]);    %����ԭֱ��ͼ
        subplot(2,3,2), qqplot(ocol), title(['����ǰ��QQͼ��',index(i)]);   %����ԭQQͼ
        subplot(2,3,3), boxplot(ocol), title(['����ǰ�ĺ�ͼ��',index(i)]);   %����ԭ��ͼ
        subplot(2,3,4), hist(ncol), title(['������ֱ��ͼ��',index(i)]);    %���ƴ����ֱ��ͼ
        subplot(2,3,5), qqplot(ncol), title(['������QQͼ��',index(i)]);   %���ƴ����QQͼ
        subplot(2,3,6), boxplot(ncol), title(['�����ĺ�ͼ��',index(i)]);   %���ƴ�����ͼ
    end
end

end