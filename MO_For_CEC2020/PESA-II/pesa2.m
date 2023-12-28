%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA123
% Project Title: Pareto Envelope-based Selection Algorithm II (PESA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, PESA-II in MATLAB (URL: https://yarpiz.com/86/ypea123-pesa2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x) ZDT(x);

nVar = 3;             % Number of Decision Variables

VarSize = [nVar 1];   % Decision Variables Matrix Size

VarMin = 0;           % Decision Varibales Lower Bound
VarMax = 1;           % Decision Varibales Upper Bound

nObj = numel(CostFunction(unifrnd(VarMin, VarMax, VarSize)));   % Number of Objectives


%% PESA-II Settings

MaxIt = 100;      % Maximum Number of Iterations

nPop = 50;        % Population Size

nArchive = 50;    % Archive Size

nGrid = 7;        % Number of Grids per Dimension

InflationFactor = 0.1;    % Grid Inflation

beta_deletion = 1;
beta_selection = 2;

pCrossover = 0.5;
nCrossover = round(pCrossover*nPop/2)*2;

pMutation = 1-pCrossover;
nMutation = nPop-nCrossover;

crossover_params.gamma = 0.15;
crossover_params.VarMin = VarMin;
crossover_params.VarMax = VarMax;

mutation_params.h = 0.3;
mutation_params.VarMin = VarMin;
mutation_params.VarMax = VarMax;


%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.IsDominated = [];
empty_individual.GridIndex = [];

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
end

archive = [];

%% Main Loop

for it = 1:MaxIt
   
    pop = DetermineDomination(pop);
    
    ndpop = pop(~[pop.IsDominated]);
    
    archive = [archive
             ndpop]; %#ok
    
    archive = DetermineDomination(archive);
    
    archive = archive(~[archive.IsDominated]);

    [archive, grid] = CreateGrid(archive, nGrid, InflationFactor);
    
    if numel(archive)>nArchive
        E = numel(archive)-nArchive;
        archive = TruncatePopulation(archive, grid, E, beta_deletion);
        [archive, grid] = CreateGrid(archive, nGrid, InflationFactor);
    end
    
    PF = archive;
    
    figure(1);
    PlotCosts(PF);
    pause(0.01);
    
    disp(['Iteration ' num2str(it) ': Number of PF Members = ' num2str(numel(PF))]);
    
    if it >= MaxIt
        break;
    end
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for c = 1:nCrossover/2
        
        p1 = SelectFromPopulation(archive, grid, beta_selection);
        p2 = SelectFromPopulation(archive, grid, beta_selection);
        
        [popc(c, 1).Position, popc(c, 2).Position] = Crossover(p1.Position, ...
                                                           p2.Position, ...
                                                           crossover_params);
        
        popc(c, 1).Cost = CostFunction(popc(c, 1).Position);
        
        popc(c, 2).Cost = CostFunction(popc(c, 2).Position);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for m = 1:nMutation
        
        p = SelectFromPopulation(archive, grid, beta_selection);
        
        popm(m).Position = Mutate(p.Position, mutation_params);
        
        popm(m).Cost = CostFunction(popm(m).Position);
        
    end
    
    pop = [popc
         popm];
         
end

%% Results

disp(' ');

PFC = [PF.Cost];
for j = 1:size(PFC, 1)
    
    disp(['Objective #' num2str(j) ':']);
    disp(['      Min = ' num2str(min(PFC(j, :)))]);
    disp(['      Max = ' num2str(max(PFC(j, :)))]);
    disp(['    Range = ' num2str(max(PFC(j, :))-min(PFC(j, :)))]);
    disp(['    St.D. = ' num2str(std(PFC(j, :)))]);
    disp(['     Mean = ' num2str(mean(PFC(j, :)))]);
    disp(' ');
    
end