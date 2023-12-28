clc;
clear;
close all;
%% Add path
addpath(genpath('./'))
rmpath(genpath('./'))
addpath(genpath('MM_testfunctions/'));
addpath(genpath('Indicator_calculation/'));

global fname

N_function=24;% number of test function
runtimes=3;  % odd number  21
totalIteration = 1;
sub = 1; % Iteration  100

%% Initialize the parameters in MMO test functions

for mxd = 1: totalIteration
    disp(['Staring ' num2str(mxd)  ' ...']);
    t00 = tic;
    for i_func= 22:N_function
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
            
            %% Search the PSs using MOPSO
            addpath(genpath('MOPSO/'));
            t1 = tic;
            [ps,pf]=MOPSO_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            % Indicators
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.MOPSO.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MOPSO.PSdata{j} = ps;
            Indicator.MOPSO.PFdata{j} = pf;
            Indicator.MOPSO.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MOPSO/'))
            %% Search the PSs using NSGA-II
            addpath(genpath('NSGAII/'));
            t1 = tic;
%             [ps,pf]=NSGAII(fname,xl,xu,n_var,popsize,Max_Gen);
            [ps,pf]=NSGAII_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.NSGAII.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.NSGAII.PSdata{j} = ps;
            Indicator.NSGAII.PFdata{j} = pf;
            Indicator.NSGAII.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('NSGAII/'))
            %% Search the PSs using NSGA-III
            addpath(genpath('NSGA-III/'));
            t1 = tic;
            [ps,pf]=NSGAIII_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.NSGAIII.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.NSGAIII.PSdata{j} = ps;
            Indicator.NSGAIII.PFdata{j} = pf;
            Indicator.NSGAIII.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('NSGA-III/'))
            %% Search the PSs using MOEA/D
            addpath(genpath('MOEA-D/'));
            t1 = tic;
            [ps,pf]=MOEAD_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.MOEAD.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MOEAD.PSdata{j} = ps;
            Indicator.MOEAD.PFdata{j} = pf;
            Indicator.MOEAD.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MOEA-D/'))
            %% Search the PSs using MODA
            addpath(genpath('MODA/'));
            t1 = tic;
            [ps,pf]=MODA_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.MODA.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MODA.PSdata{j} = ps;
            Indicator.MODA.PFdata{j} = pf;
            Indicator.MODA.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MODA/'))
            %% Search the PSs using PESA-II
            addpath(genpath('PESA-II/'));
            t1 = tic;
            [ps,pf]=PESAII_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.PESAII.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.PESAII.PSdata{j} = ps;
            Indicator.PESAII.PFdata{j} = pf;
            Indicator.PESAII.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('PESA-II/'))
            %% Search the PSs using MOGWO
            addpath(genpath('MOGWO/'));
            t1 = tic;
            [ps,pf]=MOGWO_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;
            Indicator.MOGWO.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MOGWO.PSdata{j} = ps;
            Indicator.MOGWO.PFdata{j} = pf;
            Indicator.MOGWO.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MOGWO/'))
            %% Search the PSs using MSSA
            addpath(genpath('MSSA/'));
            t1 = tic;
            [ps,pf]=MSSA_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;%
            Indicator.MSSA.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MSSA.PSdata{j} = ps;
            Indicator.MSSA.PFdata{j} = pf;
            Indicator.MSSA.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MSSA/'))
            %% Search the PSs using MOALO
            addpath(genpath('MOALO/'));
            t1 = tic;
            [ps,pf]=MOALO_ForCEC2020(popsize, Max_Gen, xl, xu, n_var, popsize/2, fname);
            hyp=Hypervolume_calculation(pf,repoint);
            IGDx=IGD_calculation(ps,PS);
            IGDf=IGD_calculation(pf,PF);
            CR=CR_calculation(ps,PS);
            PSP=CR/IGDx;%
            Indicator.MOALO.Data(j,:)=[1./PSP,1./hyp,IGDx,IGDf];
            Indicator.MOALO.PSdata{j} = ps;
            Indicator.MOALO.PFdata{j} = pf;
            Indicator.MOALO.Times(1, j) = toc(t1);
            clear ps pf hyp IGDx IGDf CR PSP t1
            rmpath(genpath('MOALO/'))
            
            
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
        % MOPSO------------------------------2--------------------------------------------------------
        Indicator.MOPSO.Data(runtimes+1,:)=min(Indicator.MOPSO.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MOPSO.Data(runtimes+2,:)=max(Indicator.MOPSO.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MOPSO.Data(runtimes+3,:)=mean(Indicator.MOPSO.Data(1:runtimes, :));
        Indicator.MOPSO.Data(runtimes+4,:)=median(Indicator.MOPSO.Data(1:runtimes, :));
        Indicator.MOPSO.Data(runtimes+5,:)=std(Indicator.MOPSO.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MOPSO.rPSP=(Indicator.MOPSO.Data(:,1))';%Talbe II data
        Indicator.MOPSO.rHV=(Indicator.MOPSO.Data(:,2))';%Talbe III data
        Indicator.MOPSO.IGDX=(Indicator.MOPSO.Data(:,3))';%Talbe IV data
        Indicator.MOPSO.IGDF=(Indicator.MOPSO.Data(:,4))';%Talbe V data
        % NSGA-II------------------------------3--------------------------------------------------------
        Indicator.NSGAII.Data(runtimes+1,:)=min(Indicator.NSGAII.Data(1:runtimes, :)); %the minimum is the best
        Indicator.NSGAII.Data(runtimes+2,:)=max(Indicator.NSGAII.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.NSGAII.Data(runtimes+3,:)=mean(Indicator.NSGAII.Data(1:runtimes, :));
        Indicator.NSGAII.Data(runtimes+4,:)=median(Indicator.NSGAII.Data(1:runtimes, :));
        Indicator.NSGAII.Data(runtimes+5,:)=std(Indicator.NSGAII.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.NSGAII.rPSP=(Indicator.NSGAII.Data(:,1))';%Talbe II data
        Indicator.NSGAII.rHV=(Indicator.NSGAII.Data(:,2))';%Talbe III data
        Indicator.NSGAII.IGDX=(Indicator.NSGAII.Data(:,3))';%Talbe IV data
        Indicator.NSGAII.IGDF=(Indicator.NSGAII.Data(:,4))';%Talbe V data
        % NSGA-III-----------------------------4--------------------------------------------------------
        Indicator.NSGAIII.Data(runtimes+1,:)=min(Indicator.NSGAIII.Data(1:runtimes, :)); %the minimum is the best
        Indicator.NSGAIII.Data(runtimes+2,:)=max(Indicator.NSGAIII.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.NSGAIII.Data(runtimes+3,:)=mean(Indicator.NSGAIII.Data(1:runtimes, :));
        Indicator.NSGAIII.Data(runtimes+4,:)=median(Indicator.NSGAIII.Data(1:runtimes, :));
        Indicator.NSGAIII.Data(runtimes+5,:)=std(Indicator.NSGAIII.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.NSGAIII.rPSP=(Indicator.NSGAIII.Data(:,1))';%Talbe II data
        Indicator.NSGAIII.rHV=(Indicator.NSGAIII.Data(:,2))';%Talbe III data
        Indicator.NSGAIII.IGDX=(Indicator.NSGAIII.Data(:,3))';%Talbe IV data
        Indicator.NSGAIII.IGDF=(Indicator.NSGAIII.Data(:,4))';%Talbe V data
        % MOEAD----------------------------------5----------------------------------------------------
        Indicator.MOEAD.Data(runtimes+1,:)=min(Indicator.MOEAD.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MOEAD.Data(runtimes+2,:)=max(Indicator.MOEAD.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MOEAD.Data(runtimes+3,:)=mean(Indicator.MOEAD.Data(1:runtimes, :));
        Indicator.MOEAD.Data(runtimes+4,:)=median(Indicator.MOEAD.Data(1:runtimes, :));
        Indicator.MOEAD.Data(runtimes+5,:)=std(Indicator.MOEAD.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MOEAD.rPSP=(Indicator.MOEAD.Data(:,1))';%Talbe II data
        Indicator.MOEAD.rHV=(Indicator.MOEAD.Data(:,2))';%Talbe III data
        Indicator.MOEAD.IGDX=(Indicator.MOEAD.Data(:,3))';%Talbe IV data
        Indicator.MOEAD.IGDF=(Indicator.MOEAD.Data(:,4))';%Talbe V data
        % MODA----------------------------------6----------------------------------------------------
        Indicator.MODA.Data(runtimes+1,:)=min(Indicator.MODA.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MODA.Data(runtimes+2,:)=max(Indicator.MODA.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MODA.Data(runtimes+3,:)=mean(Indicator.MODA.Data(1:runtimes, :));
        Indicator.MODA.Data(runtimes+4,:)=median(Indicator.MODA.Data(1:runtimes, :));
        Indicator.MODA.Data(runtimes+5,:)=std(Indicator.MODA.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MODA.rPSP=(Indicator.MODA.Data(:,1))';%Talbe II data
        Indicator.MODA.rHV=(Indicator.MODA.Data(:,2))';%Talbe III data
        Indicator.MODA.IGDX=(Indicator.MODA.Data(:,3))';%Talbe IV data
        Indicator.MODA.IGDF=(Indicator.MODA.Data(:,4))';%Talbe V data
        % PESAII----------------------------------7----------------------------------------------------
        Indicator.PESAII.Data(runtimes+1,:)=min(Indicator.PESAII.Data(1:runtimes, :)); %the minimum is the best
        Indicator.PESAII.Data(runtimes+2,:)=max(Indicator.PESAII.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.PESAII.Data(runtimes+3,:)=mean(Indicator.PESAII.Data(1:runtimes, :));
        Indicator.PESAII.Data(runtimes+4,:)=median(Indicator.PESAII.Data(1:runtimes, :));
        Indicator.PESAII.Data(runtimes+5,:)=std(Indicator.PESAII.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.PESAII.rPSP=(Indicator.PESAII.Data(:,1))';%Talbe II data
        Indicator.PESAII.rHV=(Indicator.PESAII.Data(:,2))';%Talbe III data
        Indicator.PESAII.IGDX=(Indicator.PESAII.Data(:,3))';%Talbe IV data
        Indicator.PESAII.IGDF=(Indicator.PESAII.Data(:,4))';%Talbe V data
        % MOGWO----------------------------------8----------------------------------------------------
        Indicator.MOGWO.Data(runtimes+1,:)=min(Indicator.MOGWO.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MOGWO.Data(runtimes+2,:)=max(Indicator.MOGWO.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MOGWO.Data(runtimes+3,:)=mean(Indicator.MOGWO.Data(1:runtimes, :));
        Indicator.MOGWO.Data(runtimes+4,:)=median(Indicator.MOGWO.Data(1:runtimes, :));
        Indicator.MOGWO.Data(runtimes+5,:)=std(Indicator.MOGWO.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MOGWO.rPSP=(Indicator.MOGWO.Data(:,1))';%Talbe II data
        Indicator.MOGWO.rHV=(Indicator.MOGWO.Data(:,2))';%Talbe III data
        Indicator.MOGWO.IGDX=(Indicator.MOGWO.Data(:,3))';%Talbe IV data
        Indicator.MOGWO.IGDF=(Indicator.MOGWO.Data(:,4))';%Talbe V data
        % PESAII----------------------------------9----------------------------------------------------
        Indicator.MSSA.Data(runtimes+1,:)=min(Indicator.MSSA.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MSSA.Data(runtimes+2,:)=max(Indicator.MSSA.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MSSA.Data(runtimes+3,:)=mean(Indicator.MSSA.Data(1:runtimes, :));
        Indicator.MSSA.Data(runtimes+4,:)=median(Indicator.MSSA.Data(1:runtimes, :));
        Indicator.MSSA.Data(runtimes+5,:)=std(Indicator.MSSA.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MSSA.rPSP=(Indicator.MSSA.Data(:,1))';%Talbe II data
        Indicator.MSSA.rHV=(Indicator.MSSA.Data(:,2))';%Talbe III data
        Indicator.MSSA.IGDX=(Indicator.MSSA.Data(:,3))';%Talbe IV data
        Indicator.MSSA.IGDF=(Indicator.MSSA.Data(:,4))';%Talbe V data
        % MOGWO----------------------------------10----------------------------------------------------
        Indicator.MOALO.Data(runtimes+1,:)=min(Indicator.MOALO.Data(1:runtimes, :)); %the minimum is the best
        Indicator.MOALO.Data(runtimes+2,:)=max(Indicator.MOALO.Data(1:runtimes, :)); %the maximum is the worst
        Indicator.MOALO.Data(runtimes+3,:)=mean(Indicator.MOALO.Data(1:runtimes, :));
        Indicator.MOALO.Data(runtimes+4,:)=median(Indicator.MOALO.Data(1:runtimes, :));
        Indicator.MOALO.Data(runtimes+5,:)=std(Indicator.MOALO.Data(1:runtimes, :));
        % Generate Table data in the report
        Indicator.MOALO.rPSP=(Indicator.MOALO.Data(:,1))';%Talbe II data
        Indicator.MOALO.rHV=(Indicator.MOALO.Data(:,2))';%Talbe III data
        Indicator.MOALO.IGDX=(Indicator.MOALO.Data(:,3))';%Talbe IV data
        Indicator.MOALO.IGDF=(Indicator.MOALO.Data(:,4))';%Talbe V data
        
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





