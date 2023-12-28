
% 目标2：
%   用于最小化总交付成本。
%   CT = 卡车每单位距离的旅行成本
%   CD = 无人机每单位距离的旅行成本
%   CB = 使用配备无人机的卡车的基本成本
%   Cost = CT * Vpath + CD * Dpath + CB (粗略表达)；详细公式：参考【1】的公式(6), min(f2)
% 
%   出自文章：【1】A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance；
% 
function Cost = CalcateCostF2(data,VehiclePath,DronePath)
% 卡车每单位距离的旅行成本
costV = data.vt;
% 无人机每单位距离的旅行成本
costD = data.vd;
VpathLength = length(VehiclePath);
Vdist = 0;
%计算卡车的距离
for i = 1:VpathLength-1
    Vdist =Vdist + data.disMatrix(VehiclePath(i),VehiclePath(i+1));
end
%计算无人机的距离
DpathLength = length(DronePath);
Ddist =0;
for i = 1:DpathLength
    iflyRoute = DronePath{i};
    for j = 1:length(iflyRoute)-1
        Ddist=Ddist+data.disMatrix(iflyRoute(j),iflyRoute(j+1));
    end
end
Cost = Vdist*costV + Ddist*costD + data.CB;
end