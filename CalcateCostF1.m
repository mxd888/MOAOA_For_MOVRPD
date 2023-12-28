
% 目标1：
%   用于最小化总能耗。这里只考虑卡车的能源消耗，因为无人机由电力驱动，对环境的影响几乎为零。
%   卡车的能耗与其负载和行驶距离有关（Kara等人，2007年）
%   详细公式：参考【2】的公式(5), min(f1)
%   出自文章：【1】（Kara, ?., Kara, B. Y., & Yetis, M. K. (2007). Energy minimizing vehicle routing problem. 
%   In Proceedings of the 1st International Conference on Combinatorial Optimization and Applications, August 14-16, Xi'an, China, 62-71.）；
%   【2】A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance；
function Cost = CalcateCostF1(data,VehiclePath,DronePath)
% 初始化卡车能耗为0
Cost = 0;
% 停靠点总数
StoppingNum = data.stoppingNum;
% 无人机总数
UAV_Nums=data.UAVNum;
% 存放飞出去的无人机数量向量
indexUAV_NUM=data.UAVNums;
% 动态阶段性货物重量向量
totleWeight = data.customerCommodityWeight;
% 当前货物总量
currentWeight = totleWeight(1);
% 卡车行走距离向量点个数
VpathLength = length(VehiclePath);
% 计算卡车的距离
for i = 1:VpathLength-1
    % 卡车起点
    istar=VehiclePath(i);
    % 卡车终点
    iend=VehiclePath(i+1);
    % 行驶的距离
    Vdist =data.disMatrix(istar,iend);
    % 该起点无人机送出去的货物
    iflySend = 0;
    %计算无人机的距离
    DpathLength = length(DronePath);
    % 更新无人机数量，即发现当前停靠点有没有停放的无人机，有则加入卡车
    UAV_Nums = UAV_Nums + indexUAV_NUM(i);
    % 遍历所有无人机路径
    for j = 1:DpathLength
        iflyRoute = DronePath{j};
        % 找出以当前停靠点为起点的无人机
        if iflyRoute(1) == istar
            % 获得从istar停靠点发出去的无人机以及顾客序列号
            for k = 1:length(iflyRoute)
                % 无人机所经路线点
                iflyStar=iflyRoute(k);
                % iflyStar>StoppingNum 时，无人机才是为顾客服务，小于或等于时，为从停靠点起飞
                if iflyStar>StoppingNum
                    % 迭代累加每个顾客货物重量，以求得当前无人机所消费的货物重量，再次累加以求得当前停靠点总共消费货物重量
                    iflySend = iflySend + totleWeight(iflyStar);
                end
            end
            % 获取无人机终点位置
            iVend = iflyRoute(length(iflyRoute));
            if iVend ~= istar
                % 证明有无人机没有返回当前停靠点，而是去了其他停靠点等待卡车过去
                UAV_Nums = UAV_Nums - 1;
                % 更新indexUAV_NUM
                indexUAV_NUM(iVend) = indexUAV_NUM(iVend) + 1;
            end
        end
    end
    % 若当前停靠点消费了货物，则更新当前停靠点卡车货物重量
    if iflySend > 0 
        % 更新当前货物总量
        currentWeight = currentWeight - iflySend;
    end
    % 记录当前停靠点货车货物总量
    totleWeight(istar) = currentWeight;
    % 卡车皮重
    kache = 1500;
    % 有效载荷的重量PIjV = currentWeight
    % 无人机皮重
    wurenji = 25;
    % 装载的卡车v从节点i行驶到节点j 时的毛重
    Wij=kache+currentWeight+wurenji*UAV_Nums;
    % 累加计算卡车能耗适应度值（对应论文f1）
    Cost = Cost + Vdist * Wij;
end
end