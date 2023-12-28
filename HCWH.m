
% HCWH
%
% data            data     GenData生成的data数据
function  [Sv, Sd,Cost]=HCWH(data)
stoppingNum=data.stoppingNum;
customerNum =data.customerNum;
Sv=[];
Sd=[];
% 初始化停靠点集合
StopSet = [];
for i = 1:stoppingNum
    StopSet = [StopSet,i];
end
% 算法停止标记
Stopflag = 0;
while (Stopflag==0)
    % 计算所有距离顾客最近的停靠点
    [CloseStopS,~] = FindclosestStop(data,StopSet);
    % 计算保存无人机路线
    SavingMatrixD = CalculateSavingDrone(data,CloseStopS);
    % 需要根据CloseStopS来生成初始无人机路线
    SavingMatrixV = CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
    % 货车路线
    VehiclePath = CW(StopSet,SavingMatrixV);
    % 无人机路径
    DronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
    % 计算适应度函数
    Cost1 = CalcateCostF2(data,VehiclePath,DronePath);
    % 检查将卡车路线进行反转是否可以减小总体成本
    ReVehiclePath =VehiclePath(end:-1:1);
    ReDronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
    Cost2 = CalcateCostF2(data,ReVehiclePath,ReDronePath);
    if Cost2<Cost1
        disp('翻转获得最优值')
        VehiclePath = ReVehiclePath;
        DronePath = ReDronePath;
        Cost1 = Cost2;
    end
    % 找出比必要的停靠点，并且它的消费最大
    stn = DetermineStationWithHighestSaving(data,StopSet,VehiclePath,DronePath,SavingMatrixV);
    if ~isempty(stn) %不为空的话
        stnIndex = find(StopSet==stn);
        StopSet(stnIndex) = [];%把该停靠点删除
    else
        Stopflag = 1;%退出循环
    end
end
Cost = Cost1;
Sv = VehiclePath;
Sd = DronePath;
end