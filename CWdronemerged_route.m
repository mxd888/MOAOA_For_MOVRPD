function improved_route = CWdronemerged_route(routeNewStop,SavingMatrixD)
Droute = GenInitialDronePath(routeNewStop);%构建初始飞行路线
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
    if (cmRouteindex~=cnRouteindex)&&(flagn==1)&&(flagm==1)%使m与n直接连到一起
         %把两个路线进行融合
        merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex);
         %把route1和route2从Droute中删除，并且把merged_route添加到无人机路线中
        Droute([cmRouteindex,cnRouteindex]) =[];
        Droute{end+1} = merged_route;
    end
    SavingMatrixD(1,:) = [];%删除第一个元素
end
improved_route = merged_route;
end