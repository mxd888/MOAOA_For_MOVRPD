% ����
function  stn = DetermineStationWithHighestSaving(data,StopSet,VehiclePath,DronePath,SavingMatrixV)
DeljStopSet = StopSet;
StopNum = length(StopSet);   
Cost0 = CalcateCostF2(data,VehiclePath,DronePath);
savingList = [];
row = 1;
stn =[];
for j = 1:StopNum
    DelStop = DeljStopSet(j);%ɾ����ͣ��������
    DeljStopSet(j) = [];
    if DelStop~=1 %�������ǲֿ��
        %�����ͣ����j����Ŀͻ��Ƿ����������ͣ������з���
       [CloseStopS,hasfound] = FindclosestStop(data,DeljStopSet);
       if hasfound==1
           SavingMatrixD = CalculateSavingDrone(data,CloseStopS);
           VPath = CW(DeljStopSet,SavingMatrixV);%���ɿ���·��
           DPath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VPath);
           Cost1 = CalcateCostF2(data,VPath,DPath);
           Savingj =Cost0 - Cost1;
           if Savingj>0 %����ɾ��j��������
               savingList(row,1) = DelStop;
               savingList(row,2) = Savingj;
           end
       end
    end
   DeljStopSet = StopSet;
end
%��������ɱ�����ͣ����
if ~isempty(savingList)
    savingList =sortrows(savingList,2,"descend");
    stn = savingList(1,1);
end

end