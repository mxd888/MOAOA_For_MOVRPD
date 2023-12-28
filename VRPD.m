clc;
clear;
close all;
addpath(genpath('./'))
rmpath(genpath('./'))

xRange = 350;                   % X�����
yRange = 250;                   % Y�����
customerNum = [25, 50, 100, 200];% ����������
interval = 50;
maxFlightRange = 100;           % �����з�Χ
UAV_Nums = 3;                   % ���˻���Ŀ
payload = 10;
Parameters.CT = 25;             % ������λ����ĳɱ�
Parameters.CD = 1;              % ���˻���λ����ĳɱ�
Parameters.CB = 500;            % ʹ���䱸���˻��Ŀ����Ļ����ɱ�
Parameters.QT = 1000;           % �����ĸ�������
Parameters.QD = 5;              % ���˻��ĸ�������
Parameters.WT = 1500;           % ������Ƥ�أ��գ�������
Parameters.WD = 25;             % ���˻���Ƥ�أ��գ�����
Parameters.ST = 60;             % ������ƽ����ʻ�ٶ�
Parameters.SD = 65;             % ���˻���ƽ����ʻ�ٶ�
Costtotal =zeros(1,10);
Time =zeros(1,10);

popsize = 50;
M_Iter = 200; % 500

for num = 1: numel(customerNum)
    % ����data
    data = GenData(xRange,yRange,customerNum(num),interval,maxFlightRange,payload,UAV_Nums,Parameters);
    % [Sv, Sd,Cost1]=HCWH(data);
    % [Sv, Sd, Cost1]=SOAOA(data, N, M_Iter); % [BestVehiclePath, BestDronePath, BestCost]
    
    % Ӧ�ò���
    stoppingNum=data.stoppingNum;
    % ��ʼ��ͣ���㼯��
    StopSet = zeros(1,stoppingNum);
    for i = 1:stoppingNum
        StopSet(i) = i;
    end
    
    CostFunction = @(StopSet) GetFunc(data,StopSet);     %Ŀ�꺯��
    nObj=3;       % the dimensions of the decision space
    LB = StopSet(1);
    UB = StopSet(stoppingNum);
    Dim = stoppingNum;
    repoint=UB + 1; % reference point used to calculate the Hypervolume, it is set to 1.1*(max value of f_i)
    N_ops=2;
    mixiaodongTotal = 21;
    
    empty_particle.MOAOA= [];
    empty_particle.NSGAII=[];
    empty_particle.MOPSO= [];
    empty_particle.PESAII=[];
    empty_particle.MOEAD=[];
    
    ResultData = repmat(empty_particle, mixiaodongTotal, 1);
    for mixiaodong = 1: mixiaodongTotal
        t0 = tic;
        % ----------------------------MOAOA----------------------------------------
        addpath(genpath('./MO_For_CEC2020/MOAOA'));
        disp('Staring MOAOA ...');
        ResultData(mixiaodong).MOAOA = MOAOA_ForVRPD(popsize, M_Iter, LB, UB, Dim, popsize/2, CostFunction);
        rmpath(genpath('./MO_For_CEC2020/MOAOA'));
        % ----------------------------NSGAII----------------------------------------
        addpath(genpath('./MO_For_CEC2020/NSGAII'));
        disp('Staring NSGAII ...');
        ResultData(mixiaodong).NSGAII = NSGAII_ForVRPD(popsize, M_Iter, LB, UB, Dim, popsize/2, CostFunction);
        rmpath(genpath('./MO_For_CEC2020/NSGAII'));
        % ----------------------------MOPSO----------------------------------------
        addpath(genpath('./MO_For_CEC2020/MOPSO'));
        disp('Staring MOPSO ...');
        ResultData(mixiaodong).MOPSO = MOPSO_ForVRPD(popsize, M_Iter, LB, UB, Dim, popsize/2, CostFunction);
        rmpath(genpath('./MO_For_CEC2020/MOPSO'));
        % ----------------------------PESA-II--------------------------------------
        addpath(genpath('./MO_For_CEC2020/PESA-II'));
        disp('Staring PESA-II ...');
        ResultData(mixiaodong).PESAII = PESAII_ForVRPD(popsize, M_Iter, LB, UB, Dim, popsize/2, CostFunction);
        rmpath(genpath('./MO_For_CEC2020/PESA-II'));
        % ----------------------------MOEA/D--------------------------------------
        addpath(genpath('./MO_For_CEC2020/MOEA-D'));
        disp('Staring MOEA/D ...');
        ResultData(mixiaodong).MOEAD = MOEAD_ForVRPD(popsize, M_Iter, LB, UB, Dim, popsize/2, CostFunction);
        rmpath(genpath('./MO_For_CEC2020/MOEA-D'));
        
        disp(['Running�� ', num2str(floor((mixiaodong/mixiaodongTotal)*100)), '%, in timing: ', num2str(toc(t0))]);
    end
    path = ['RunData/VRPD_Reslut_R' num2str(num)];
    save(path, 'ResultData');
end



% ��Sv��Sd��Ϊ���룬Ϊ���չʾ����ÿ�����˻���·��
% Droute = GenEachDroute(data,Sv,Sd);
% figure(1)
% PlotCWresult(data,Sv,Sd);
% figure(2)
% PlotEachDrone(data,Sv,Droute);
%
% Cost1




