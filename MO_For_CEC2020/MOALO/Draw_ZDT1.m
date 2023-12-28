%_________________________________________________________________________%
%  Multi-Objective Ant Lion Optimizer (MALO) source codes demo            %
%                           version 1.0                                   %
%                                                                         %
%  Developed in MATLAB R2011b(7.13)                                       %
%                                                                         %
%  Author and programmer: Seyedali Mirjalili                              %
%                                                                         %
%         e-Mail: ali.mirjalili@gmail.com                                 %
%                 seyedali.mirjalili@griffithuni.edu.au                   %
%                                                                         %
%       Homepage: http://www.alimirjalili.com                             %
% Paper: Mirjalili, Seyedali, Pradeep Jangir, and Shahrzad Saremi.        %
% Multi-objective ant lion optimizer: a multi-objective optimization      % 
%  algorithm for solving engineering problems." Applied Intelligence      %
% (2016): 1-17, DOI: http://dx.doi.org/10.1007/s10489-016-0825-8          %
%_________________________________________________________________________%


function TPF=Draw_ZDT1()

% TPF is the true Pareto optimal front
addpath('ZDT_set')

ObjectiveFunction=@(x) ZDT1(x);
x=0:0.01:1;
for i=1:size(x,2)
    TPF(i,:)=ObjectiveFunction([x(i) 0 0 0]);
end
line(TPF(:,1),TPF(:,2));
title('ZDT1')

xlabel('f1')
ylabel('f2')
box on

fig=gcf;
set(findall(fig,'-property','FontName'),'FontName','Garamond')
set(findall(fig,'-property','FontAngle'),'FontAngle','italic')
