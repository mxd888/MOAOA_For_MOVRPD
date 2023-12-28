function flag2 = checkfromVehicle(data,merged_route,VehiclePath,Droute,cmRouteindex,cnRouteindex)
UAV_Nums = data.UAVNum;%无人机数目限制
%把m，n的路线从Droute中删除，并且把merged_route更新到Droute中
Droute([cmRouteindex,cnRouteindex]) =[];
Droute{end+1} = merged_route;
Vpathlength = length(VehiclePath);
flag2 = 1;

%检查第一个规则(无人机起飞点和降落点之间的无人机数目限制)
DispatchList = zeros(1,Vpathlength);%无人机起飞点数目列表
CollectList = zeros(1,Vpathlength);%无人机回收点数目列表
Droutelength = length(Droute);
for i = 1:Droutelength
    idRoute = Droute{i};
    Oi = idRoute(1);%飞行路线起点
    Di = idRoute(end);%飞行路线的终点
    if Oi ~=Di %起点和终点不一样，需要统计无人机数目
        Oindex = find(VehiclePath==Oi);
        Dindex = find(VehiclePath == Di);
        if Oi  ~= 1&&Di~=1%起飞点和降落点都不是仓库
            DispatchList(Oindex) = DispatchList(Oindex) + 1;
            CollectList(Dindex) = CollectList(Dindex) + 1;
        elseif Oi  == 1&&Di~=1%仓库是起飞点
            DispatchList(Oindex(1)) = DispatchList(Oindex(1)) + 1;
            CollectList(Dindex) = CollectList(Dindex) + 1;
        elseif Oi  ~= 1&&Di==1%仓库是降落点
            DispatchList(Oindex) = DispatchList(Oindex) + 1;
            CollectList(Dindex(2)) = CollectList(Dindex(2)) + 1;
        end
    end
end
%判断每一个点是否违反无人机数目要求
for i = 1:Vpathlength
    if DispatchList(i)>UAV_Nums || CollectList(i)>UAV_Nums
        flag2 = 0;
        break
    end
end
if flag2 == 0  %违反第一个规则，直接返回
    return
end

%检查第二个规则（起飞点必须在降落点之前）
for i = 1:Droutelength
    idRoute = Droute{i};
    Oi = idRoute(1);%飞行路线起点
    Di = idRoute(end);%飞行路线的终点
    if Oi ~=Di %起点和终点不一样，需要统计无人机数目
        Oindex = find(VehiclePath==Oi);
        Dindex = find(VehiclePath == Di);
         if Oi  ~= 1&&Di~=1%起飞点和降落点都不是仓库
             if Dindex<Oindex
                 flag2 =0;
                 break;
             end
        end
    end
end
if flag2==0%违反第二个规则，直接返回
    return
end

%检查第三个规则(确保每一个停靠点之后都有一架无人机来服务下一个停靠点周围的客户)
DispatchList = zeros(1,Vpathlength);%无人机起飞点数目列表
CollectList = zeros(1,Vpathlength);%无人机回收点数目列表
remainNum = UAV_Nums;
for i = 1:Vpathlength %沿着卡车路线进行检查
    Vi = VehiclePath(i);
    for j = 1:Droutelength
        jdRoute = Droute{j};
        Oj = jdRoute(1);%飞行路线起点
        Dj = jdRoute(end);%飞行路线的终点
        if Oj~=Dj %起点和终点不一样，需要统计无人机数目
            if Oj == Vi %流出点
                DispatchList(i) = DispatchList(i)+1;
            elseif Dj == Vi %汇入点
                CollectList(i) = CollectList(i) + 1;
            end
        end
    end
    if i == Vpathlength %为仓库点
        remainNum = UAV_Nums;
    elseif i == 1
        remainNum = UAV_Nums - DispatchList(i);
        if remainNum <1
            flag2 =0;
            break;
        end
    elseif i~=1 && i ~= Vpathlength
        remainNum = remainNum + CollectList(i) - DispatchList(i);
        if i == Vpathlength-1 && remainNum<0 %可以全部都派出去
            flag2 =0;
            break;
        elseif i ~= Vpathlength-1  && remainNum<1 %至少要留一架无人机在卡车上驶向下一个停靠点
            flag2 =0;
            break;
        end
    end  
end
if flag2 == 0
    return
end
end