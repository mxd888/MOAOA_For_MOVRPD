
% HCWH
%
% data            data     GenData���ɵ�data����
function  [Sv, Sd,Cost]=HCWH(data)
stoppingNum=data.stoppingNum;
customerNum =data.customerNum;
Sv=[];
Sd=[];
% ��ʼ��ͣ���㼯��
StopSet = [];
for i = 1:stoppingNum
    StopSet = [StopSet,i];
end
% �㷨ֹͣ���
Stopflag = 0;
while (Stopflag==0)
    % �������о���˿������ͣ����
    [CloseStopS,~] = FindclosestStop(data,StopSet);
    % ���㱣�����˻�·��
    SavingMatrixD = CalculateSavingDrone(data,CloseStopS);
    % ��Ҫ����CloseStopS�����ɳ�ʼ���˻�·��
    SavingMatrixV = CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
    % ����·��
    VehiclePath = CW(StopSet,SavingMatrixV);
    % ���˻�·��
    DronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
    % ������Ӧ�Ⱥ���
    Cost1 = CalcateCostF2(data,VehiclePath,DronePath);
    % ��齫����·�߽��з�ת�Ƿ���Լ�С����ɱ�
    ReVehiclePath =VehiclePath(end:-1:1);
    ReDronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
    Cost2 = CalcateCostF2(data,ReVehiclePath,ReDronePath);
    if Cost2<Cost1
        disp('��ת�������ֵ')
        VehiclePath = ReVehiclePath;
        DronePath = ReDronePath;
        Cost1 = Cost2;
    end
    % �ҳ��ȱ�Ҫ��ͣ���㣬���������������
    stn = DetermineStationWithHighestSaving(data,StopSet,VehiclePath,DronePath,SavingMatrixV);
    if ~isempty(stn) %��Ϊ�յĻ�
        stnIndex = find(StopSet==stn);
        StopSet(stnIndex) = [];%�Ѹ�ͣ����ɾ��
    else
        Stopflag = 1;%�˳�ѭ��
    end
end
Cost = Cost1;
Sv = VehiclePath;
Sd = DronePath;
end