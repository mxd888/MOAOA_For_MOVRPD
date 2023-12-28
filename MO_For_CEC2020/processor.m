% clear
% clc
% close all;
% 首先加载Result下的R1
% 本页代码主要用于计算四个指标，画图的话使用PlotCEC2020
%% Add path
addpath(genpath('MM_testfunctions/'));
addpath(genpath('Indicator_calculation/'));
Func = 24;
Arms = 10;
TD_rPSP = zeros(Func + 1,Arms);
TD_rHV = zeros(Func + 1,Arms);
TD_IGDX = zeros(Func + 1,Arms);
TD_IGDF = zeros(Func + 1,Arms);
for i = 1: Func
    
    Indicator = ResultData(i).Indicator;
    if Arms == 10
        j = 1;
        TD_rPSP(i, j) = Indicator.MOAOA.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MOAOA.rPSP(end);
        TD_rHV(i, j) = Indicator.MOAOA.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MOAOA.rHV(end);
        TD_IGDX(i, j) = Indicator.MOAOA.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MOAOA.IGDX(end);
        TD_IGDF(i, j) = Indicator.MOAOA.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MOAOA.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MOPSO.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MOPSO.rPSP(end);
        TD_rHV(i, j) = Indicator.MOPSO.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MOPSO.rHV(end);
        TD_IGDX(i, j) = Indicator.MOPSO.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MOPSO.IGDX(end);
        TD_IGDF(i, j) = Indicator.MOPSO.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MOPSO.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.NSGAII.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.NSGAII.rPSP(end);
        TD_rHV(i, j) = Indicator.NSGAII.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.NSGAII.rHV(end);
        TD_IGDX(i, j) = Indicator.NSGAII.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.NSGAII.IGDX(end);
        TD_IGDF(i, j) = Indicator.NSGAII.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.NSGAII.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.NSGAIII.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.NSGAIII.rPSP(end);
        TD_rHV(i, j) = Indicator.NSGAIII.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.NSGAIII.rHV(end);
        TD_IGDX(i, j) = Indicator.NSGAIII.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.NSGAIII.IGDX(end);
        TD_IGDF(i, j) = Indicator.NSGAIII.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.NSGAIII.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MOEAD.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MOEAD.rPSP(end);
        TD_rHV(i, j) = Indicator.MOEAD.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MOEAD.rHV(end);
        TD_IGDX(i, j) = Indicator.MOEAD.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MOEAD.IGDX(end);
        TD_IGDF(i, j) = Indicator.MOEAD.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MOEAD.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MODA.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MODA.rPSP(end);
        TD_rHV(i, j) = Indicator.MODA.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MODA.rHV(end);
        TD_IGDX(i, j) = Indicator.MODA.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MODA.IGDX(end);
        TD_IGDF(i, j) = Indicator.MODA.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MODA.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.PESAII.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.PESAII.rPSP(end);
        TD_rHV(i, j) = Indicator.PESAII.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.PESAII.rHV(end);
        TD_IGDX(i, j) = Indicator.PESAII.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.PESAII.IGDX(end);
        TD_IGDF(i, j) = Indicator.PESAII.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.PESAII.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MOGWO.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MOGWO.rPSP(end);
        TD_rHV(i, j) = Indicator.MOGWO.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MOGWO.rHV(end);
        TD_IGDX(i, j) = Indicator.MOGWO.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MOGWO.IGDX(end);
        TD_IGDF(i, j) = Indicator.MOGWO.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MOGWO.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MSSA.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MSSA.rPSP(end);
        TD_rHV(i, j) = Indicator.MSSA.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MSSA.rHV(end);
        TD_IGDX(i, j) = Indicator.MSSA.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MSSA.IGDX(end);
        TD_IGDF(i, j) = Indicator.MSSA.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MSSA.IGDF(end);
        
        j = j + 1;
        TD_rPSP(i, j) = Indicator.MOALO.rPSP(end-2);
        TD_rPSP(i + Func + 1, j) = Indicator.MOALO.rPSP(end);
        TD_rHV(i, j) = Indicator.MOALO.rHV(end-2);
        TD_rHV(i + Func + 1, j) = Indicator.MOALO.rHV(end);
        TD_IGDX(i, j) = Indicator.MOALO.IGDX(end-2);
        TD_IGDX(i + Func + 1, j) = Indicator.MOALO.IGDX(end);
        TD_IGDF(i, j) = Indicator.MOALO.IGDF(end-2);
        TD_IGDF(i + Func + 1, j) = Indicator.MOALO.IGDF(end);
    else
        TD_rPSP(i, 1) = Indicator.MOAOA.rPSP(end-2);
        TD_rPSP(i + Func, 1) = Indicator.MOAOA.rPSP(end);
        TD_rHV(i, 1) = Indicator.MOAOA.rHV(end-2);
        TD_rHV(i + Func, 1) = Indicator.MOAOA.rHV(end);
        TD_IGDX(i, 1) = Indicator.MOAOA.IGDX(end-2);
        TD_IGDX(i + Func, 1) = Indicator.MOAOA.IGDX(end);
        TD_IGDF(i, 1) = Indicator.MOAOA.IGDF(end-2);
        TD_IGDF(i + Func, 1) = Indicator.MOAOA.IGDF(end);
    end
    
    
end

save ('Table', 'TD_IGDF', 'TD_IGDX', 'TD_rHV', 'TD_rPSP');

