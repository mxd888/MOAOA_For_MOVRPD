function VehiclePath = CW(StopSet,SavingMatrixV)

%先生成初始路线
Vroute = GenInitialVehickePath(StopSet);
while ~isempty(SavingMatrixV) %把StopSet中的所有点都连成一条路径
    %取出SavingMatrix的第一个元素
    si = SavingMatrixV(1,1);
    sj = SavingMatrixV(1,2);
    if ismember(si,StopSet)&&ismember(sj,StopSet) %同时是停靠点集合中的一员
        if si ~=1&&sj~=1 %两个停靠点都不可以是仓库点
            Vroutelength = length(Vroute);
            for i = 1:Vroutelength
                iVroute = Vroute{i};
                if ismember(si,iVroute)
                    siInrouteIndex = i;%si在路线集中的索引
                    siVroute = iVroute;
                    siIndex = find(iVroute == si);%用来判断是否是端点
                end
                if ismember(sj,iVroute)
                    sjInrouteIndex = i;%sj在路线集中的索引
                    sjVroute = iVroute;
                    sjIndex = find(iVroute==sj);%用来判断是否是端点
                end
            end
            flag =0;
            if siIndex == length(siVroute)-1 || siIndex ==2 %si，sj均在路线的两端，则可以将其融合
                if sjIndex == length(sjVroute)-1 || sjIndex==2
                    flag =1;
                end
            end
            if flag == 1&&siInrouteIndex~=sjInrouteIndex %确保两个路线是不一样的路线
                %将两个停靠点所在的路线进行融合
                merged_route = mergedmnRoute(siVroute,sjVroute,siIndex,sjIndex);
                %将两个路线从Vroute中删除
                Vroute([siInrouteIndex,sjInrouteIndex]) = [];
                Vroute{end+1} = merged_route;%把新路线加入到路线集中
    %            %将si与sj从StopSet中删除
    %             siInStop = find(si==StopSet);
    %             sjInStop = find(sj==StopSet);
    %             StopSet([siInStop,sjInStop]) = [];
            end
        end
    end
    %将第一个节约矩阵进行删除
    SavingMatrixV(1,:)=[];
end
VehiclePath = Vroute{1};
end