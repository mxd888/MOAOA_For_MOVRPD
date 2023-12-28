clc;
clear;
close all;
addpath(genpath('./RunData'));
addpath(genpath('./MO_For_CEC2020/Indicator_calculation'));

repoint = [1.1 1.1 1.1];
for i=1: 21
    load(['VRPD_Reslut_R' i])
    
    MOAOA_Reslut.Cost;
    % Indicators
    hyp=Hypervolume_calculation(pf,repoint);
    
end



rmpath(genpath('./MO_For_CEC2020/Indicator_calculation'));
rmpath(genpath('./RunData'));