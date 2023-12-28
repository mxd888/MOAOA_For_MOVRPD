%
% CalculateMultimodelSaving
% 
% data              ��ͼ
% SavingMatrixD     ���˻�·��
% CloseStopS        ����ͣ����
% StopSet           ʮ��·��
%
function  SavingMatrixV = CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet)
%���㿨��ͣ����Ľ�Լ����
SavingMatrixV = CalculateSavingStop(data,StopSet);
Droute = GenInitialDronePath(CloseStopS);
Stoplength = length(StopSet);
Cntrij = zeros(Stoplength,Stoplength);%��¼ͣ����i��j֮�����˻��ķ��д���
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
    if (cmRouteindex~=cnRouteindex)&&(flagn==1)&&(flagm==1)&&cmRouteindex<=length(Droute) && cnRouteindex<=length(Droute)%ʹm��nֱ������һ��
        %������·�߽����ں�
        merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex);
        %�ж��غ����ͷ��о���Ҫ��
        flag = checkroutePayload(data,merged_route);
        Oi = merged_route(1);
        Dj = merged_route(end);
        CntrOindex = find(StopSet == Oi);
        CntrDindex = find(StopSet == Dj);
        OisavingIndex = find(SavingMatrixV(:,1)==Oi);
        DjsavingIndex = find(SavingMatrixV(:,2)==Dj);
        if flag ==1 && Cntrij(CntrOindex,CntrDindex)<=UAV_Nums %�������˻�������Ҫ��
            %��route1��route2��Droute��ɾ�������Ұ�merged_route��ӵ����˻�·����
            Droute([cmRouteindex,cnRouteindex])=[];
            Droute{end+1} = merged_route;
            if Oi~=Dj %����·�ߵ������յ㲻һ��
                Cntrij(CntrOindex,CntrDindex) =  Cntrij(CntrOindex,CntrDindex)+1;
                ODsavingVindex = find(SavingMatrixV(:,1)==Oi&SavingMatrixV(:,2)==Dj);
                newSavingOD = costV*SavingMatrixV(ODsavingVindex,3)+costD*SavingMatrixD(1,3);
                SavingMatrixV(ODsavingVindex,3) = newSavingOD;
                %��·�߷�ת
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
    SavingMatrixD(1,:)=[];%ɾ����һ��Ԫ��
end
%��������SavingV
SavingMatrixV = sortrows(SavingMatrixV,3,"descend");
end