clear
clc
close all;
% Éú³ÉR1
empty_particle.Indicator= [];
empty_particle.Method=[];

N_function = 24;

for i = 1: 1
    PATH = ['R' num2str(i)];
    addpath(genpath(PATH));
    ResultData = repmat(empty_particle, N_function, 1);
    for j = 1: N_function
        DATA_PATH = ['TP' num2str(j) '.mat'];
        load(DATA_PATH);
        ResultData(j).Indicator = Indicator;
        ResultData(j).Method = fname;
        clear DATA_PATH fname Indicator;
    end
    save (PATH, 'ResultData');
    rmpath(genpath(PATH))
    clear ResultData;
end
