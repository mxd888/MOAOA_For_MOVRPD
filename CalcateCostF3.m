
% 目标3：
%   用于最小化交付时间。
%   详细公式：参考【1】的公式(7), min(f3)
% 
%   出自文章：【1】A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance；
% 
function Cost = CalcateCostF3(data,VehiclePath,DronePath)
% 初始化卡车能耗为0
Cost = 0;
% 卡车速度
VV = data.ST;
% 无人机速度
VD = data.SD;
% 卡车行走距离向量点个数
VpathLength = length(VehiclePath);
% 计算卡车的距离
for i = 1:VpathLength-1
    % 卡车当前停靠点
    istar=VehiclePath(i);
    % 卡车下一个停靠点
    iend=VehiclePath(i+1);
    % 行驶的距离
    Vdist =data.disMatrix(istar,iend);
    % 飞行时间最长的无人机所需路程
    Ddist = 0;
    %计算无人机的距离
    DpathLength = length(DronePath);
    % 遍历所有无人机路径
    for j = 1:DpathLength
        iDdist = 0;
        iflyRoute = DronePath{j};
        % 获取无人机终点位置
        iVend = iflyRoute(length(iflyRoute));
        % 找出以当前停靠点为起点的无人机，并且终点为起点的无人机
        if iflyRoute(1) == istar && iVend == istar
            % 获得从istar停靠点发出去的无人机以及顾客序列号
            for k = 1:length(iflyRoute) -1
                % 无人机飞行时间
                iDdist=iDdist+data.disMatrix(iflyRoute(k),iflyRoute(k+1));
            end
        end
        if iDdist>Ddist
            Ddist = iDdist;
        end
    end
    % 卡车前往下一个停靠点所需时间
    TV = Vdist/VV;
    % 无人机所需时间
    TD = Ddist/VD;
    % 从当前停靠点前往下一个停靠点所需总时间
    TotalTime = TV + TD;
    % 累加计算卡车能耗适应度值（对应论文f3）
    Cost = Cost + TotalTime;
end
end