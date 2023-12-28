function VehiclePath = CW(StopSet,SavingMatrixV)

%�����ɳ�ʼ·��
Vroute = GenInitialVehickePath(StopSet);
while ~isempty(SavingMatrixV) %��StopSet�е����е㶼����һ��·��
    %ȡ��SavingMatrix�ĵ�һ��Ԫ��
    si = SavingMatrixV(1,1);
    sj = SavingMatrixV(1,2);
    if ismember(si,StopSet)&&ismember(sj,StopSet) %ͬʱ��ͣ���㼯���е�һԱ
        if si ~=1&&sj~=1 %����ͣ���㶼�������ǲֿ��
            Vroutelength = length(Vroute);
            for i = 1:Vroutelength
                iVroute = Vroute{i};
                if ismember(si,iVroute)
                    siInrouteIndex = i;%si��·�߼��е�����
                    siVroute = iVroute;
                    siIndex = find(iVroute == si);%�����ж��Ƿ��Ƕ˵�
                end
                if ismember(sj,iVroute)
                    sjInrouteIndex = i;%sj��·�߼��е�����
                    sjVroute = iVroute;
                    sjIndex = find(iVroute==sj);%�����ж��Ƿ��Ƕ˵�
                end
            end
            flag =0;
            if siIndex == length(siVroute)-1 || siIndex ==2 %si��sj����·�ߵ����ˣ�����Խ����ں�
                if sjIndex == length(sjVroute)-1 || sjIndex==2
                    flag =1;
                end
            end
            if flag == 1&&siInrouteIndex~=sjInrouteIndex %ȷ������·���ǲ�һ����·��
                %������ͣ�������ڵ�·�߽����ں�
                merged_route = mergedmnRoute(siVroute,sjVroute,siIndex,sjIndex);
                %������·�ߴ�Vroute��ɾ��
                Vroute([siInrouteIndex,sjInrouteIndex]) = [];
                Vroute{end+1} = merged_route;%����·�߼��뵽·�߼���
    %            %��si��sj��StopSet��ɾ��
    %             siInStop = find(si==StopSet);
    %             sjInStop = find(sj==StopSet);
    %             StopSet([siInStop,sjInStop]) = [];
            end
        end
    end
    %����һ����Լ�������ɾ��
    SavingMatrixV(1,:)=[];
end
VehiclePath = Vroute{1};
end