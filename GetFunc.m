

% ���һ������Ӧ�Ⱥ���
function [VehiclePath, DronePath, Cost, hasfound] = GetFunc(data,StopSet)
    Cost=0;
    VehiclePath=[];
    DronePath=[];
    % �������о���˿������ͣ����
    [CloseStopS,hasfound]=FindclosestStop(data,StopSet);
    % �жϵ�ǰ��������Ƿ���У���Ҫ������
    if hasfound==1
        % ���㱣�����˻�·��
        SavingMatrixD=CalculateSavingDrone(data,CloseStopS);
        % ��Ҫ����CloseStopS�����ɳ�ʼ���˻�·��
        SavingMatrixV=CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
        % ����·��
        VehiclePath=CW(StopSet,SavingMatrixV);
        % ���˻�·��
        DronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
        % ������Ӧ�Ⱥ���
        Y1 = CalcateCostFunction(data,VehiclePath,DronePath);
%         Cost=CalcateCostF2(data,VehiclePath,DronePath);
        % ��齫����·�߽��з�ת�Ƿ���Լ�С����ɱ�
        ReVehiclePath=VehiclePath(end:-1:1);
        % ���㷭ת������˻�·��
        ReDronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
        % ���㷭ת�����Ӧ��ֵ
        Y2 = CalcateCostFunction(data,VehiclePath,DronePath);
%         Cost2=CalcateCostF2(data,ReVehiclePath,ReDronePath);
        % �Ƿ�֧��
        VRPD_For_Dominates(Y1, Y2);
        if VRPD_For_Dominates(Y2, Y1)
            % Y2֧��Y1
            VehiclePath=ReVehiclePath;
            DronePath=ReDronePath;
            Y1 = Y2;
        end
        Cost = Y1';
    end
    
end

