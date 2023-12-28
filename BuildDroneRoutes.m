function DronePath = BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath)
Droute = GenInitialDronePath(CloseStopS);%������ʼ����·��
UAV_Nums = data.UAVNum;%���˻���Ŀ����
costV = data.vt;
costD = data.vd;
while ~isempty(SavingMatrixD)
     %��SD��ȡ����һ���ͻ���mn��������Droute���ҵ�����·�ߵ������յ�
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
    %�ж�m,n�Ƿ��Ƿ���·�����˵Ŀͻ��� (not intermidiate nodes)
    flagm = 0;
    flagn = 0;
    if cminRindex == length(mDronePath)-1 || cminRindex == 2
        flagm = 1;
    end
    if cninRindex == length(nDronePath)-1 || cninRindex == 2
        flagn = 1;
    end
    %m��n����·���Ƿ���Ժϲ�(route1 ������route2��not intermidate nodes)
    if cmRouteindex<=length(Droute) && cnRouteindex<=length(Droute)
        if (cmRouteindex~=cnRouteindex)&&(flagn==1)&&(flagm==1)%ʹm��nֱ������һ��
             %������·�߽����ں�
            merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex);
            %�ж��غ����ͷ��о���Ҫ��
            flag1 = checkroutePayload(data,merged_route);  
            if flag1 == 1 
                %�жϴӿ���·�ߵĽǶȿ������·���Ƿ����
                flag2 = checkfromVehicle(data,merged_route,VehiclePath,Droute,cmRouteindex,cnRouteindex);
                if flag2 == 1 %�ӿ����ĽǶȿ���·�߿���
                    %�ж�·���еĿͻ������ͣ�����Ƿ���O��D
                    flag3 = checkmergedrouteStopC(merged_route,CloseStopS);
                    if flag3 == 1%���Զ�·�߽����Ż�
                        merged_route = Improve_Drone_Route(data,merged_route,CloseStopS);
                    end
                    %��route1��route2��Droute��ɾ�������Ұ�merged_route��ӵ����˻�·����
                    Droute([cmRouteindex,cnRouteindex]) =[];
                    Droute{end+1} = merged_route;
                end
            end
        end
    end
    SavingMatrixD(1,:) = [];%ɾ����һ��Ԫ��
end
DronePath = Droute;
end