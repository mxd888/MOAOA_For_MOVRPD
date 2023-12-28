

% 最后一公里适应度函数
function [VehiclePath, DronePath, Cost, hasfound] = GetFunc(data,StopSet)
    Cost=0;
    VehiclePath=[];
    DronePath=[];
    % 计算所有距离顾客最近的停靠点
    [CloseStopS,hasfound]=FindclosestStop(data,StopSet);
    % 判断当前解决方案是否可行，不要求最优
    if hasfound==1
        % 计算保存无人机路线
        SavingMatrixD=CalculateSavingDrone(data,CloseStopS);
        % 需要根据CloseStopS来生成初始无人机路线
        SavingMatrixV=CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
        % 货车路线
        VehiclePath=CW(StopSet,SavingMatrixV);
        % 无人机路径
        DronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
        % 计算适应度函数
        Y1 = CalcateCostFunction(data,VehiclePath,DronePath);
%         Cost=CalcateCostF2(data,VehiclePath,DronePath);
        % 检查将卡车路线进行反转是否可以减小总体成本
        ReVehiclePath=VehiclePath(end:-1:1);
        % 计算翻转后的无人机路径
        ReDronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
        % 计算翻转后的适应度值
        Y2 = CalcateCostFunction(data,VehiclePath,DronePath);
%         Cost2=CalcateCostF2(data,ReVehiclePath,ReDronePath);
        % 是否支配
        VRPD_For_Dominates(Y1, Y2);
        if VRPD_For_Dominates(Y2, Y1)
            % Y2支配Y1
            VehiclePath=ReVehiclePath;
            DronePath=ReDronePath;
            Y1 = Y2;
        end
        Cost = Y1';
    end
    
end

