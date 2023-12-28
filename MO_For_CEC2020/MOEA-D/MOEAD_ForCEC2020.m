function [ps,pf]=MOEAD_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)
%% Problem Definition

nVar = Dim;             % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = LB;         % Decision Variables Lower Bound
VarMax = UB;         % Decision Variables Upper Bound

nObj = numel(feval(CostFunction, unifrnd(VarMin(1), VarMax(1), VarSize)));


%% MOEA/D Settings

MaxIt = M_Iter;  % Maximum Number of Iterations

nPop = N;    % Population Size (Number of Sub-Problems)

nArchive = nRep;

T = max(ceil(0.15*nPop), 2);    % Number of Neighbors
T = min(max(T, 2), 15);

crossover_params.gamma = 0.5;
crossover_params.VarMin = VarMin;
crossover_params.VarMax = VarMax;

%% Initialization

% Create Sub-problems
sp = CreateSubProblems(nObj, nPop, T);

% Empty Individual
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.g = [];
empty_individual.IsDominated = [];

% Initialize Goal Point
%z = inf(nObj, 1);
z = zeros(nObj, 1);

% Create Initial Population
pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = feval(CostFunction, pop(i).Position);
    z = min(z, pop(i).Cost);
end

for i = 1:nPop
    pop(i).g = DecomposedCost(pop(i), z, sp(i).lambda);
end

% Determine Population Domination Status
pop = DetermineDomination(pop);

% Initialize Estimated Pareto Front
EP = pop(~[pop.IsDominated]);

%% Main Loop

for it = 1:MaxIt
    for i = 1:nPop
        
        % Reproduction (Crossover)
        K = randsample(T, 2);
        
        j1 = sp(i).Neighbors(K(1));
        p1 = pop(j1);
        
        j2 = sp(i).Neighbors(K(2));
        p2 = pop(j2);
        
        y = empty_individual;
        y.Position = Crossover(p1.Position, p2.Position, crossover_params);
        
        y.Cost = feval(CostFunction, y.Position);
        
        z = min(z, y.Cost);
        
        for j = sp(i).Neighbors
            y.g = DecomposedCost(y, z, sp(j).lambda);
            if y.g <= pop(j).g
                pop(j) = y;
            end
        end
        
    end
    
    % Determine Population Domination Status
	pop = DetermineDomination(pop);
    
    ndpop = pop(~[pop.IsDominated]);
    
    EP = [EP
        ndpop]; %#ok
    
    EP = DetermineDomination(EP);
    EP = EP(~[EP.IsDominated]);
    
    if numel(EP)>nArchive
        Extra = numel(EP)-nArchive;
        ToBeDeleted = randsample(numel(EP), Extra);
        EP(ToBeDeleted) = [];
    end
end

%% Reults
ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(EP(1).Cost));
for i = 1: numel(EP)
    ps(i, :)=EP(i).Position;
    pf(i, :)=EP(i).Cost';
end
end