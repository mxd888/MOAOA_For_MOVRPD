function flag3 = checkmergedrouteStopC(merged_route,CloseStopS)
O = merged_route(1);
D = merged_route(end);
routeCustomerS = merged_route(2:end-1);
Customerlength = length(routeCustomerS);
flag3 = 0;
for i = 1:Customerlength
    ci = routeCustomerS(i);
    ciIndex = find(CloseStopS(:,1)==ci);
    ciCloseStop = CloseStopS(ciIndex,2);%ci客户最近的停靠点
    if ciCloseStop~=O && ciCloseStop ~= D
        flag3 =1;
        break;
    end
end
end