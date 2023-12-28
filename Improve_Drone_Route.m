function route = Improve_Drone_Route(data,merged_route,CloseStopS)
route = merged_route;
O = merged_route(1);
D = merged_route(end);
routeCustomerS = merged_route(2:end-1);
Customerlength = length(routeCustomerS);
routeNewStop =[];
for i = 1:Customerlength
    ci = routeCustomerS(i);
    ciIndex = find(CloseStopS(:,1)==ci);
    ciCloseStop = CloseStopS(ciIndex,2);%ci客户最近的停靠点
    if ciCloseStop~=O &&ciCloseStop~=D
        %比较ci离O还是D近
        if data.disMatrix(O,ci)<data.disMatrix(D,ci)
            newStop = O;
        else
            newStop = D;
        end
    elseif ciCloseStop==O
        newStop = O;
    elseif ciCloseStop == D
        newStop = D;
    end
    routeNewStop(i,1)= ci;
    routeNewStop(i,2) = newStop;
end
SavingMatrixD = CalculateSavingDrone(data,routeNewStop);
improved_route = CWdronemerged_route(routeNewStop,SavingMatrixD);
%检查是否满足无人机载荷约束和飞行距离约束
flag = checkroutePayload(data,improved_route);  
if flag == 1
    route = improved_route;
end
end