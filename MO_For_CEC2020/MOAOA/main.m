%
% Copyright (c) 2022, Xiao Dong Mi & MDong
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: MDong
% Project Title: Multi-Objective Arithmetic Optimization Algorithm (MOAOA)
% Publisher: MDong (https://gitee.com/starboot)
% 
% Developer: Xiao Dong Mi (Member of GXMZ Team)
% 
% Cite as:
% Xiao Dong Mi, Multi-Objective AOA in MATLAB (URL: https://gitee.com/starboot), MDong, 2022.
% 
% Contact Info: 15511090450@163.com, 1191998028@qq.com
%

clc; clear; close all;
CostFunction = @(x) MOP2(x);     %目标函数
nVar = 5;                                     %变量个数 30

VarMin = -5;                                    %变量值定义域
VarMax = 5;                                     %注意: 该函数变量不能出现负值
MaxIt = 100;                                    %最大迭代次数
N = 400;                                        %种群规模 40
nRep = 200;                                     %档案库大小 50

t0 = tic;
% 多目标算术优化算法
[rep]=MOAOA(N,MaxIt,VarMin,VarMax,nVar,nRep,CostFunction);
toc(t0);
% figure(1);
% location = [rep.Cost];   %取最优结果
% 
% scatter(location(1,:),location(2,:),'filled','b');
% xlabel('f1');ylabel('f2');
% title('Pareto 最优边界图');
% box on;
