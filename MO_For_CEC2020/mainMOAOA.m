clc;
clear;
close all;
%% Add path
addpath(genpath('MM_testfunctions/'));
addpath(genpath('Indicator_calculation/'));

global fname

N_function=24;% number of test function
runtimes=1;  % odd number  21
totalIteration = 2;
sub = 1; % Iteration  100

%% Initialize the parameters in MMO test functions

for mxd = 1: totalIteration
    disp(['Staring ' num2str(mxd)  ' ...']);
    t00 = tic;
    for i_func= 1:N_function
        t0 = tic;
        [fname, n_obj, n_var, xl, xu, repoint, N_ops] = GetFunc(i_func);
        %% Load reference PS and PF data
        load(strcat([fname,'_Reference_PSPF_data']));
        %% Initialize the population size and the maximum evaluations
        popsize=200*N_ops;
        Max_fevs=200*N_ops * sub;
        Max_Gen=fix(Max_fevs/popsize);
        
        for j=1:runtimes
            %% Search the PSs using MOAOA
            addpath(genpath('MOAOA/'));
            t1 = tic;
            [ps,pf]=MOAOA_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            
            % Indicators
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.MOAOA.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MOAOA.PSdata{j} = ps;
            Indicator.MOAOA.PFdata{j} = pf;
            Indicator.MOAOA.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MOAOA/'))

        end
        
        %% Calculate mean and std of the indicators
        % MOAOA-----------------------------1---------------------------------------------------------
        Indicator.MOAOA.Data(runtimes+1,:)=min(Indicator.MOAOA.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MOAOA.Data(runtimes+2,:)=max(Indicator.MOAOA.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MOAOA.Data(runtimes+3,:)=mean(Indicator.MOAOA.Data(1:runtimes, :));
        Indicator.MOAOA.Data(runtimes+4,:)=median(Indicator.MOAOA.Data(1:runtimes, :));
        Indicator.MOAOA.Data(runtimes+5,:)=std(Indicator.MOAOA.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MOAOA.rPSP=(Indicator.MOAOA.Data(:,1))';%Talbe II data
        Indicator.MOAOA.rHV=(Indicator.MOAOA.Data(:,2))';%Talbe III data
        Indicator.MOAOA.IGDX=(Indicator.MOAOA.Data(:,3))';%Talbe IV data
        Indicator.MOAOA.IGDF=(Indicator.MOAOA.Data(:,4))';%Talbe V data

        %% save resultdata
        folder  = ['Result/R'  num2str(mxd) ];
        if ~exist(folder,'dir')
            mkdir(folder)
        end
        PATH = [folder '/TP' num2str(i_func)];
        save(PATH, 'Indicator', 'fname');
        clear Indicator
        
        disp(['Running£º ', num2str(floor((i_func/N_function)*100)), '%, in timing: ', num2str(toc(t0))]);
    end
    disp(['Total in timing: ', num2str(toc(t00))]);
    
end
disp(['End Time:', datestr(now())])





