function [output_args] = PlotResult(data,solution,xRange,yRange)
UAVNums = data.UAVNum;
stoppingNum = data.stoppingNum;
scatter(data.stoppingPos(1,:),data.stoppingPos(2,:),80,'s','filled','b');hold on;
%根据客户需求不同画不同颜色
for i = 1:data.customerNum
%         scatter(data.customerPos(1,i),data.customerPos(2,i),50,'filled','g');
    scatter(data.customerPos(1,i),data.customerPos(2,i),50,'filled','r');
end

uavPath = solution.uavpath;
Clr = hsv(UAVNums);
Dlength = length(uavPath);
for i = 1:Dlength%为
    subroute = uavPath{i};
    subRLength = length(subroute);
    k = 1;
    start = 0;
    ending = 0;
    for j = 1:subRLength-1
        if subroute(j) <= stoppingNum && start == 0
            start = 1;
        elseif subroute(j) <= stoppingNum && start == 1 
            ending = 1;
            start = 0;
        end
        plot([data.allPos(1,subroute(j)),data.allPos(1,subroute(j+1))],[data.allPos(2,subroute(j)),data.allPos(2,subroute(j+1))],'Color',Clr(k,:),'LineWidth',1.5);
        if ending == 1
            ending =0;
            k = k +1;
            if k > UAVNums
                k = 1;
            end
        end
    end
end
truckPath = solution.truckPath;
truckPathlength = length(truckPath);
for j  =1:truckPathlength-1
     plot([data.allPos(1,truckPath(j)),data.allPos(1,truckPath(j+1))],[data.allPos(2,truckPath(j)),data.allPos(2,truckPath(j+1))],'k','LineWidth',2);
end
% scatter(data.customerPos(1,:),data.customerPos(2,:),50,'filled');
% allNodeSum = data.stoppingNum + data.customerNum;
% % for i = 1: allNodeSum
% %    str = sprintf('%d',i);
% %    text(data.allPos(1,i)+4,data.allPos(2,i)+8,str);
% % end
% num = length(solution.route);
% start = 1;
% % str = sprintf('%d',solution.route(start));
% % text(data.allPos(1,solution.route(start))+4,data.allPos(2,solution.route(start))+8,str);
% for i =2:num
%     plot([data.allPos(1,solution.route(i-1)),data.allPos(1,solution.route(i))],...
%         [data.allPos(2,solution.route(i-1)),data.allPos(2,solution.route(i))],'r');
%     if solution.route(i) <= data.stoppingNum
%        rendz = i;
%        plot([data.allPos(1,solution.route(start)),data.allPos(1,solution.route(rendz))],...
%            [data.allPos(2,solution.route(start)),data.allPos(2,solution.route(rendz))],'LineWidth',2,'Color','b');
%        start = rendz;
%     end
% end
xlim([-5 400]);
ylim([-5 300]);
hold off;
end