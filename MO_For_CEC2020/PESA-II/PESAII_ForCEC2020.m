function [ps,pf]=PESAII_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)

%% Problem Definition

nVar = Dim;             % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = LB;           % Decision Varibales Lower Bound
VarMax = UB;           % Decision Varibales Upper Bound

nObj = numel(feval(CostFunction, unifrnd(VarMin(1), VarMax(1), VarSize)));   % Number of Objectives


%% PESA-II Settings

MaxIt = M_Iter;      % Maximum Number of Iterations

nPop = N;        % Population Size

nArchive = nRep;    % Archive Size

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
    pop(i).Cost = feval(CostFunction, pop(i).Position);
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
    
%     PF = archive;
    
%     figure(1);
%     PlotCosts(PF);
%     pause(0.01);
    
%     disp(['Iteration ' num2str(it) ': Number of PF Members = ' num2str(numel(PF))]);
    
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
        
        popc(c, 1).Cost = feval(CostFunction, popc(c, 1).Position);
        
        popc(c, 2).Cost = feval(CostFunction, popc(c, 2).Position);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for m = 1:nMutation
        
        p = SelectFromPopulation(archive, grid, beta_selection);
        
        popm(m).Position = Mutate(p.Position, mutation_params);
        
        popm(m).Cost = feval(CostFunction, popm(m).Position);
        
    end
    
    pop = [popc
         popm];
         
end

%% Results
ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(archive(1).Cost));
for i = 1: numel(archive)
    ps(i, :)=archive(i).Position;
    pf(i, :)=archive(i).Cost';
end
end