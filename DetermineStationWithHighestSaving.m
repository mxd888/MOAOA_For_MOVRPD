% 弃用
function  stn = DetermineStationWithHighestSaving(data,StopSet,VehiclePath,DronePath,SavingMatrixV)
DeljStopSet = StopSet;
StopNum = length(StopSet);   
Cost0 = CalcateCostF2(data,VehiclePath,DronePath);
savingList = [];
row = 1;
stn =[];
for j = 1:StopNum
    DelStop = DeljStopSet(j);%删除的停靠点索引
    DeljStopSet(j) = [];
    if DelStop~=1 %不可以是仓库点
        %检查由停靠点j服务的客户是否可以由其他停靠点进行服务
       [CloseStopS,hasfound] = FindclosestStop(data,DeljStopSet);
       if hasfound==1
           SavingMatrixD = CalculateSavingDrone(data,CloseStopS);
           VPath = CW(DeljStopSet,SavingMatrixV);%生成卡车路线
           DPath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VPath);
           Cost1 = CalcateCostF2(data,VPath,DPath);
           Savingj =Cost0 - Cost1;
           if Savingj>0 %代表删除j，有收益
               savingList(row,1) = DelStop;
               savingList(row,2) = Savingj;
           end
       end
    end
   DeljStopSet = StopSet;
end
%排序，输出成本最大的停靠点
if ~isempty(savingList)
    savingList =sortrows(savingList,2,"descend");
    stn = savingList(1,1);
end

end