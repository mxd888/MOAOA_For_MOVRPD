function DronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath)
Droute = GenInitialDronePath(CloseStopS);%构建初始飞行路线
UAV_Nums = data.UAVNum;%无人机数目限制
costV = data.vt;
costD = data.vd;
while ~isempty(SavingMatrixD)
     %从SD中取出第一个客户组mn，并且在Droute中找到两条路线的起点和终点
    cm = SavingMatrixD(1,1);
    cn = SavingMatrixD(1,2);
    Droutelength = length(Droute);
    for i = 1:Droutelength
        iRoute = Droute{i};
        if ismember(cm, iRoute)
            cmRouteindex = i;
            cminRindex = find(iRoute==cm);
            mDronePath = iRoute;
        end
        if ismember(cn,iRoute)
            cnRouteindex = i;
            cninRindex = find(iRoute==cn);
            nDronePath = iRoute;
        end
    end
    %判断m,n是否是飞行路线两端的客户点 (not intermidiate nodes)
    flagm = 0;
    flagn = 0;
    if cminRindex == length(mDronePath)-1 || cminRindex == 2
        flagm = 1;
    end
    if cninRindex == length(nDronePath)-1 || cninRindex == 2
        flagn = 1;
    end
    %m与n飞行路线是否可以合并(route1 不等于route2，not intermidate nodes)
    if cmRouteindex<=length(Droute) && cnRouteindex<=length(Droute)
        if (cmRouteindex~=cnRouteindex)&&(flagn==1)&&(flagm==1)%使m与n直接连到一起
             %把两个路线进行融合
            merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex);
            %判断载荷量和飞行距离要求
            flag1 = checkroutePayload(data,merged_route);  
            if flag1 == 1 
                %判断从卡车路线的角度看，这个路线是否可行
                flag2 = checkfromVehicle(data,merged_route,VehiclePath,Droute,cmRouteindex,cnRouteindex);
                if flag2 == 1 %从卡车的角度看，路线可行
                    %判断路线中的客户最近的停靠点是否都是O和D
                    flag3 = checkmergedrouteStopC(merged_route,CloseStopS);
                    if flag3 == 1%可以对路线进行优化
                        merged_route = Improve_Drone_Route(data,merged_route,CloseStopS);
                    end
                    %把route1和route2从Droute中删除，并且把merged_route添加到无人机路线中
                    Droute([cmRouteindex,cnRouteindex]) =[];
                    Droute{end+1} = merged_route;
                end
            end
        end
    end
    SavingMatrixD(1,:) = [];%删除第一个元素
end
DronePath = Droute;
end