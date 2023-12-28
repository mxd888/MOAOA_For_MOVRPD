function [ps,pf] = NSGAII_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)

nVar = Dim;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix

VarMin = LB;          % Lower Bound of Variables
VarMax = UB;          % Upper Bound of Variables



%% NSGA-II Parameters

MaxIt = M_Iter;      % Maximum Number of Iterations

nPop = N;        % Population Size

pCrossover = 0.7;                         % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation = 0.4;                          % Mutation Percentage
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = 0.02;                    % Mutation Rate

sigma = 0.1*(VarMax-VarMin);  % Mutation Step Size


%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop
    
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    pop(i).Cost = feval(CostFunction, pop(i).Position);
    
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop);

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop

for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);
        popc(k, 1).Position = limitToPosition(popc(k, 1).Position,LB,UB);
        popc(k, 2).Position = limitToPosition(popc(k, 2).Position,LB,UB);
        
        popc(k, 1).Cost = feval(CostFunction, popc(k, 1).Position);
        popc(k, 2).Cost = feval(CostFunction, popc(k, 2).Position);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        
        i = randi([1 nPop]);
        p = pop(i);
        
        popm(k).Position = Mutate(p.Position, mu, sigma);
        popm(k).Position = limitToPosition(popm(k).Position,LB,UB);
        
        popm(k).Cost = feval(CostFunction, popm(k).Position);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1});
    
    % Show Iteration Information
%     disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
%     figure(1);
%     PlotCosts(F1);
%     pause(0.01);
    
end

%% Results

ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(F1(1).Cost));
for i = 1: numel(F1)
    ps(i, :)=F1(i).Position;
    pf(i, :)=F1(i).Cost';
end
end
    
    
    
    

    




