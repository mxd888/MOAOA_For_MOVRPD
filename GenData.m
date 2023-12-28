% 生成网格数据
%
% xRange            350     X轴界限
% yRange            250     Y轴界限
% customerNum       50      顾客数量
% interval          50      间隔
% maxFlightRange    100     最大飞行范围
% payload           10      有效载荷
% vt                1
% vd                1
% UAV_Nums          3       无人机数目
%
function data = GenData(xRange,yRange,customerNum,interval,maxFlightRange,payload,UAV_Nums,Parameters)
rand('twister', sum(100*clock));
x_range = xRange/interval;
y_range = yRange/interval;
m = x_range*y_range+1;
data.customerPos(1,:)=(xRange-50)*rand(1,customerNum)+50;%一列代表一个坐标位置
data.customerPos(2,:)=(yRange-50)*rand(1,customerNum)+50;
%     Request = round(rand(1,customerNum));%产生需求序列，0-收取，1-派发
%产生Pw和dw
Pw = 5*rand(1,customerNum);
Dw = 5*rand(1,customerNum);

for i=1:x_range
    for j=1:y_range
        data.stoppingPos(1,(i-1)*y_range+j)=interval*i;
        data.stoppingPos(2,(i-1)*y_range+j)=interval*j;
    end
end
    data.depotPos = [0;0];
    data.stoppingPos = [data.depotPos,data.stoppingPos];
    data.allPos = [data.stoppingPos,data.customerPos];
    data.allKdtree = KDTreeSearcher(data.allPos');
    data.stoppingKdtree = KDTreeSearcher(data.stoppingPos');
    data.customerKdtree = KDTreeSearcher(data.customerPos');
    data.stoppingNum = length(data.stoppingPos(1,:));
    data.customerNum = length(data.customerPos(1,:));
    data.maxFlightRange = maxFlightRange;
    data.payload = payload;
    data.vt = Parameters.CT;
    data.vd = Parameters.CD;
    data.ST = Parameters.ST;
    data.SD = Parameters.SD;
    data.UAVNum = UAV_Nums;
%     data.Request = Request;
    data.Pw = Pw;
    data.Dw = Dw;
    data.CB = Parameters.CB;
    num = length(data.allPos(1,:));
    
    for i=1:num
        for j=i:num
            if i~=j
                if i<=length(data.stoppingPos) && j<=length(data.stoppingPos)
                    % 停靠点、卡车的路线采用曼哈顿距离测量
                    dist = norm(data.allPos(:,i)-data.allPos(:,j),1);
                    data.disMatrix(i,j) = dist;
                    data.disMatrix(j,i) = dist;
                else
                    % 无人机在两个节点之间直线行进，用欧氏距离测量其路线
                    dist = norm(data.allPos(:,i)-data.allPos(:,j),2);
                    data.disMatrix(i,j) = dist;
                    data.disMatrix(j,i) = dist;
                end
            else
                data.disMatrix(i,j) = 0.0;
            end
        end
    end
    
    % 顾客最大货物重量
    DroneMax = 2;
    % 每个顾客货物重量
    DroneWeight = ceil(rand(1,customerNum)*DroneMax);
    % 卡车在每个停靠点出发时的重量
    VehicleWeight = zeros(1,length(data.stoppingPos(1,:)));
    % 初始化卡车货物重量为所有货物的重量
    VehicleWeight(1) = sum(DroneWeight);
    % 将顾客货物重量、卡车动态变化的货物量进行归一化
    totleWeight = [VehicleWeight, DroneWeight];
    % 赋值给data域
    data.customerCommodityWeight = totleWeight;
    % 每个停靠点卡车上无人机数量
    data.UAVNums = zeros(1,length(data.stoppingPos(1,:)));
end
