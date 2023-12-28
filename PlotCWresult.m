function  PlotCWresult(data,Sv,Sd)
Svlength = length(Sv);
Sdlength = length(Sd);
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
for j = 1:Sdlength
    jFlyroute = Sd{j};
    for k = 1:length(jFlyroute)-1
        plot([allPos(jFlyroute(k),1),allPos(jFlyroute(k+1),1)],[allPos(jFlyroute(k),2),allPos(jFlyroute(k+1),2)],"Color",'b',"LineWidth",1.2);%画无人机路线
    end
end
xlim([-5 400]);
ylim([-5 300]);
hold off;
end