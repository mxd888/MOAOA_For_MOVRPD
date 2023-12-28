function PlotEachDrone(data,Sv,Droute)
Svlength = length(Sv);
Droutelength = size(Droute,1);
allPos = data.allPos';
scatter(data.stoppingPos(1,:),data.stoppingPos(2,:),80,'s','filled','b');hold on;
for i = 1:data.customerNum
%         scatter(data.customerPos(1,i),data.customerPos(2,i),50,'filled','g');
    scatter(data.customerPos(1,i),data.customerPos(2,i),50,'filled','r');
end
for i = 1:Svlength-1
    plot([allPos(Sv(i),1),allPos(Sv(i+1),1)],[allPos(Sv(i),2),allPos(Sv(i+1),2)],"Color",'k',"LineWidth",1.5);%画卡车路线
    hold on
end
clr = hsv(Droutelength);
for j = 1:Droutelength
     jDroneRoute = Droute(j,:);
     Droutelength = length(jDroneRoute);
     jColor = clr(j,:);
     for s = 1:Droutelength
         sFlyRoute = jDroneRoute{s};
         if ~isempty(sFlyRoute)
             for k = 1:length(sFlyRoute)-1
                 plot([allPos(sFlyRoute(k),1),allPos(sFlyRoute(k+1),1)],[allPos(sFlyRoute(k),2),allPos(sFlyRoute(k+1),2)],"Color",jColor,"LineWidth",1.2);%画无人机路线
             end
         end
     end
end
xlim([-5 400]);
ylim([-5 300]);
hold off;
end