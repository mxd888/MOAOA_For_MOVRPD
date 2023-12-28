function flag = checkroutePayload(data,merged_route)
kmax = data.payload;
Pw = data.Pw;
Dw = data.Dw;
stoppingNum=data.stoppingNum;
routeLength = length(merged_route);
paylist = [0];
flagpayload = 1;
for i = 1:routeLength-2%ͬһ���ͻ���������ȡ���������Ͱ�����
    Pwi = Pw(merged_route(i+1)-stoppingNum);
    Dwi = Dw(merged_route(i+1)-stoppingNum);
    kpayload = Dwi;
    paylist = paylist + ones(1,length(paylist))*kpayload;
    kpayload = paylist(end)+Pwi;
    paylist = [paylist,kpayload];
end
for i = 1:routeLength-1
    if paylist(i) > kmax
        flagpayload = 0;%�����غ�����
    end
end
%������˻����о�������
flagflydist=1;
maxFlightRange = data.maxFlightRange;
dist = 0;
for j = 1:routeLength-1
    dist = dist + data.disMatrix(merged_route(j),merged_route(j+1));
    if dist>maxFlightRange
        flagflydist = 0;
        break
    end
end
if flagflydist == 1&&flagpayload==1 %��������
    flag = 1;
else
    flag=0;
end
end