% 计算所有距离顾客最近的停靠点
% 
% data              100     地图数据
% StopSet           10      停靠点集合
%
function [CloseStopS,hasfound] = FindclosestStop(data, StopSet)
Slength = length(StopSet);
stoppingNum = data.stoppingNum;
customerNum =data.customerNum;
maxFlightRange=data.maxFlightRange;
CloseStopS = zeros(customerNum,2);
%为每一个客户计算离其最近的停靠点
for i = 1:customerNum
    dist = inf;
    hasfound = 0;
    for j =1:Slength
        distij = data.disMatrix(StopSet(j),i+stoppingNum);%停靠点到客户的距离
        if distij<dist &&distij<maxFlightRange/2%位于飞行范围内
            dist=distij;
            Closti = StopSet(j);
            hasfound=1;
        end
    end
    if hasfound == 0%没有找到满足要求的停靠点
        break
    end
    CloseStopS(i,1) = i+stoppingNum;
    CloseStopS(i,2) = Closti;
end

end