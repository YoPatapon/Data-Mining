%% 数据通过excel文件读入matlab
horse_data = xlsread('D:\学习\课程\数据挖掘\作业一\horse-colic.xlsx');
%建立索引项
ind = {'Surgery'; 'Age'; 'Hospital Number'; 'Rectal Temperature'; 'pulse'; 'respiratory rate'; 'temperature of extremities';'peripheral pulse';'mucous membranes'; 'capillary refill time'; 'pain'; 'peristalsis'; 'abdominal distension'; 'nasogastric tube'; 'nasogastric reflux'; 'nasogastric reflux PH'; 'rectal examination'; 'abdomen'; 'packed cell volume'; 'total protein'; 'abdominocentesis appearance'; 'abdomcentesis total protein'; 'outcome'; 'surgical lesion'; 'type of lesion1'; 'type of lesion2'; 'type of lesion3'; 'cp_data'};
global index;
index = reshape(ind, 1, 28);
%分别抽取数值型数据和标称型数据分别建立数组
numerical_mat = horse_data(:, [4,5,6,16,19,20,22]);
nominal_mat = horse_data(:, [1,2,3,7,8,9,10,11,12,13,14,15,17,18,21,23,24,25,26,27,28]);

%% 数据摘要
%对标称属性统计频数
% 数值属性，给出最大、最小、均值、中位数、四分位数及缺失值的个数
%Data_Abstract( horse_data )

%% 数据可视化
%绘制直方图，如mxPH，用qq图检验其分布是否为正态分布。
%绘制盒图，对离群值进行识别
%Data_Visualization( horse_data )

%% 缺失值处理
Missing_Value_Process(horse_data, 4)