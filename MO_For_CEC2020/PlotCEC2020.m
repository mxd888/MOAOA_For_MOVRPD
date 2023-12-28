% clear
% clc
% close all;
% 首先加载Result下的R1
addpath(genpath('MM_testfunctions/'));
addpath(genpath('Indicator_calculation/'));
Func = 24;
for i = 11: 21  % 11 21
    Indicator = ResultData(i).Indicator;
    
    [~, MOAOA] = min(Indicator.MOAOA.Data(1:21,1)+Indicator.MOAOA.Data(1:21,2)+Indicator.MOAOA.Data(1:21,3)+Indicator.MOAOA.Data(1:21,4));
    [~, MOPSO] = max(Indicator.MOPSO.Data(1:21,1)+Indicator.MOPSO.Data(1:21,2)+Indicator.MOPSO.Data(1:21,3)+Indicator.MOPSO.Data(1:21,4));
    [~, NSGAII] = max(Indicator.NSGAII.Data(1:21,1)+Indicator.NSGAII.Data(1:21,2)+Indicator.NSGAII.Data(1:21,3)+Indicator.NSGAII.Data(1:21,4));
    [~, NSGAIII] = max(Indicator.NSGAIII.Data(1:21,1)+Indicator.NSGAIII.Data(1:21,2)+Indicator.NSGAIII.Data(1:21,3)+Indicator.NSGAIII.Data(1:21,4));
    [~, MOEAD] = max(Indicator.MOEAD.Data(1:21,1)+Indicator.MOEAD.Data(1:21,2)+Indicator.MOEAD.Data(1:21,3)+Indicator.MOEAD.Data(1:21,4));
    [~, MODA] = max(Indicator.MODA.Data(1:21,1)+Indicator.MODA.Data(1:21,2)+Indicator.MODA.Data(1:21,3)+Indicator.MODA.Data(1:21,4));
    [~, PESAII] = max(Indicator.PESAII.Data(1:21,1)+Indicator.PESAII.Data(1:21,2)+Indicator.PESAII.Data(1:21,3)+Indicator.PESAII.Data(1:21,4));
    [~, MOGWO] = max(Indicator.MOGWO.Data(1:21,1)+Indicator.MOGWO.Data(1:21,2)+Indicator.MOGWO.Data(1:21,3)+Indicator.MOGWO.Data(1:21,4));
    [~, MSSA] = max(Indicator.MSSA.Data(1:21,1)+Indicator.MSSA.Data(1:21,2)+Indicator.MSSA.Data(1:21,3)+Indicator.MSSA.Data(1:21,4));
    [~, MOALO] = max(Indicator.MOALO.Data(1:21,1)+Indicator.MOALO.Data(1:21,2)+Indicator.MOALO.Data(1:21,3)+Indicator.MOALO.Data(1:21,4));
    
    if i == 11
        Plot_figure(ResultData(i).Method, Indicator.MOAOA, MOAOA, i);
        Plot_figure(ResultData(i).Method, Indicator.MOPSO, MOPSO, i);
        Plot_figure(ResultData(i).Method, Indicator.NSGAII, NSGAII, i);
        Plot_figure(ResultData(i).Method, Indicator.NSGAIII, NSGAIII, i);
        Plot_figure(ResultData(i).Method, Indicator.MOEAD, MOEAD, i);
        Plot_figure(ResultData(i).Method, Indicator.MODA, MODA, i);
        Plot_figure(ResultData(i).Method, Indicator.PESAII, PESAII, i);
        Plot_figure(ResultData(i).Method, Indicator.MOGWO, MOGWO, i);
        Plot_figure(ResultData(i).Method, Indicator.MSSA, MSSA, i);
        Plot_figure(ResultData(i).Method, Indicator.MOALO, MOALO, i);
    end
end




function Plot_figure(fname, AData, num, i)
load(strcat([fname,'_Reference_PSPF_data']));
choose_ps= AData.PSdata{num};
choose_pf= AData.PFdata{num};

%% Plot PS
if size(choose_ps, 2)==2
    figure('Position',[454   445   400   300])
    plot(choose_ps(:,1),choose_ps(:,2),'o');
    hold on;
    plot(PS(:,1),PS(:,2),'r+');
    legend 'Obtained PS' 'True PS'
    
elseif size(choose_ps,2)==3
    figure('Position',[454   445   400   300])
    plot3(choose_ps(:,1),choose_ps(:,2),choose_ps(:,3),'o');
    hold on;
    plot3(PS(:,1),PS(:,2),PS(:,3),'r.');
    legend 'Obtained PS' 'True PS'
    
end
title(['\fontsize{12}\bf The PS convergence on P' num2str(i)]);
xlabel('x1');
ylabel('x2');
zlabel('x3');

%% Plot PF
% 
% if size(choose_pf, 2)==2
%     figure('Position',[454   445   400   300])
%     plot(choose_pf(:,1),choose_pf(:,2),'o');
%     
% elseif size(choose_pf,2)==3
%     figure('Position',[454   445   400   300])
%     plot3(choose_pf(:,1),choose_pf(:,2),choose_pf(:,3),'o');
%     
% end
% title(['\fontsize{12}\bf The PF convergence on P' num2str(i)]);
% xlabel('f1');
% ylabel('f2');
% zlabel('f3');
clear choose_ps PF PS;
end
