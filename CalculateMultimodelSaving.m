%
% CalculateMultimodelSaving
% 
% data              地图
% SavingMatrixD     无人机路线
% CloseStopS        货车停靠点
% StopSet           十字路口
%
function  SavingMatrixV = CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet)
%计算卡车停靠点的节约矩阵
SavingMatrixV = CalculateSavingStop(data,StopSet);
Droute = GenInitialDronePath(CloseStopS);
Stoplength = length(StopSet);
Cntrij = zeros(Stoplength,Stoplength);%记录停靠点i，j之间无人机的飞行次数
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
    if (cmRouteindex~=cnRouteindex)&&(flagn==1)&&(flagm==1)&&cmRouteindex<=length(Droute) && cnRouteindex<=length(Droute)%使m与n直接连到一起
        %把两个路线进行融合
        merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex);
        %判断载荷量和飞行距离要求
        flag = checkroutePayload(data,merged_route);
        Oi = merged_route(1);
        Dj = merged_route(end);
        CntrOindex = find(StopSet == Oi);
        CntrDindex = find(StopSet == Dj);
        OisavingIndex = find(SavingMatrixV(:,1)==Oi);
        DjsavingIndex = find(SavingMatrixV(:,2)==Dj);
        if flag ==1 && Cntrij(CntrOindex,CntrDindex)<=UAV_Nums %满足无人机的数量要求
            %把route1和route2从Droute中删除，并且把merged_route添加到无人机路线中
            Droute([cmRouteindex,cnRouteindex])=[];
            Droute{end+1} = merged_route;
            if Oi~=Dj %飞行路线的起点和终点不一样
                Cntrij(CntrOindex,CntrDindex) =  Cntrij(CntrOindex,CntrDindex)+1;
                ODsavingVindex = find(SavingMatrixV(:,1)==Oi&SavingMatrixV(:,2)==Dj);
                newSavingOD = costV*SavingMatrixV(ODsavingVindex,3)+costD*SavingMatrixD(1,3);
                SavingMatrixV(ODsavingVindex,3) = newSavingOD;
                %将路线反转
                routelength = length(merged_route);
                newRoute = routelength(end:-1:1);
                flag = checkroutePayload(data,newRoute);
                if flag==1&&Cntrij(CntrDindex,CntrOindex)<=UAV_Nums
                    Cntrij(CntrDindex,CntrOindex) = Cntrij(CntrDindex,CntrOindex)+1;
                    ODsavingVindex = find(SavingMatrixV(:,1)==Dj&SavingMatrixV(:,2)==Oi);
                    newSavingOD =  costV*SavingMatrixV(ODsavingVindex,3)+costD*SavingMatrixD(1,3);
                     SavingMatrixV(ODsavingVindex,3) = newSavingOD;
                end
            end
        end
    end
    SavingMatrixD(1,:)=[];%删除第一个元素
end
%降序排列SavingV
SavingMatrixV = sortrows(SavingMatrixV,3,"descend");
end