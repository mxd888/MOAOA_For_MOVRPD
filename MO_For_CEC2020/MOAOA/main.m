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
CostFunction = @(x) MOP2(x);     %Ŀ�꺯��
nVar = 5;                                     %�������� 30

VarMin = -5;                                    %����ֵ������
VarMax = 5;                                     %ע��: �ú����������ܳ��ָ�ֵ
MaxIt = 100;                                    %����������
N = 400;                                        %��Ⱥ��ģ 40
nRep = 200;                                     %�������С 50

t0 = tic;
% ��Ŀ�������Ż��㷨
[rep]=MOAOA(N,MaxIt,VarMin,VarMax,nVar,nRep,CostFunction);
toc(t0);
% figure(1);
% location = [rep.Cost];   %ȡ���Ž��
% 
% scatter(location(1,:),location(2,:),'filled','b');
% xlabel('f1');ylabel('f2');
% title('Pareto ���ű߽�ͼ');
% box on;
