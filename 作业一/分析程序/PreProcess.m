%% ����ͨ��excel�ļ�����matlab
horse_data = xlsread('D:\ѧϰ\�γ�\�����ھ�\��ҵһ\horse-colic.xlsx');
%����������
ind = {'Surgery'; 'Age'; 'Hospital Number'; 'Rectal Temperature'; 'pulse'; 'respiratory rate'; 'temperature of extremities';'peripheral pulse';'mucous membranes'; 'capillary refill time'; 'pain'; 'peristalsis'; 'abdominal distension'; 'nasogastric tube'; 'nasogastric reflux'; 'nasogastric reflux PH'; 'rectal examination'; 'abdomen'; 'packed cell volume'; 'total protein'; 'abdominocentesis appearance'; 'abdomcentesis total protein'; 'outcome'; 'surgical lesion'; 'type of lesion1'; 'type of lesion2'; 'type of lesion3'; 'cp_data'};
global index;
index = reshape(ind, 1, 28);
%�ֱ��ȡ��ֵ�����ݺͱ�������ݷֱ�������
numerical_mat = horse_data(:, [4,5,6,16,19,20,22]);
nominal_mat = horse_data(:, [1,2,3,7,8,9,10,11,12,13,14,15,17,18,21,23,24,25,26,27,28]);

%% ����ժҪ
%�Ա������ͳ��Ƶ��
% ��ֵ���ԣ����������С����ֵ����λ�����ķ�λ����ȱʧֵ�ĸ���
%Data_Abstract( horse_data )

%% ���ݿ��ӻ�
%����ֱ��ͼ����mxPH����qqͼ������ֲ��Ƿ�Ϊ��̬�ֲ���
%���ƺ�ͼ������Ⱥֵ����ʶ��
%Data_Visualization( horse_data )

%% ȱʧֵ����
Missing_Value_Process(horse_data, 4)