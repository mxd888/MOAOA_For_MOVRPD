function rep = MOEAD_ForVRPD(N,M_Iter,LB,UB,Dim,nRep,CostFunction)
%% Problem Definition

nVar = Dim;             % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = LB;         % Decision Variables Lower Bound
VarMax = UB;         % Decision Variables Upper Bound

nObj = 3;
pMutation = 0.5;
nMutation = round(pMutation*N);
beta = 2;
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
empty_individual.VehiclePath = [];
empty_individual.DronePath = [];
empty_individual.hasfound = [];
% Initialize Goal Point
%z = inf(nObj, 1);
z = zeros(nObj, 1);

% Create Initial Population
pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
%     pop(i).Cost = feval(CostFunction, pop(i).Position);
    [pop(i).VehiclePath, pop(i).DronePath, pop(i).Cost, pop(i).hasfound] = CostFunction(unique(floor(pop(i).Position)));
    z = min(z, pop(i).Cost);
end

for i = 1:nPop
    pop(i).g = DecomposedCost(pop(i), z, sp(i).lambda);
end

% Determine Population Domination Status
pop = DetermineDomination(pop);
index = find([pop.hasfound] > 0);
% Initialize Estimated Pareto Front
EP = pop(index);

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
        
%         y.Cost = feval(CostFunction, y.Position);
        [y.VehiclePath, y.DronePath, y.Cost, y.hasfound] = CostFunction(unique(floor(y.Position)));
        z = min(z, y.Cost);
        
        for j = sp(i).Neighbors
            y.g = DecomposedCost(y, z, sp(j).lambda);
            if y.g <= pop(j).g
                pop(j) = y;
            end
        end

    end
    sigma = zeros(N, Dim);
    % Determine Population Domination Status
	pop = DetermineDomination(pop);
    index = find([pop.hasfound] > 0);
    ndpop = pop(index);
    popc = Cross(empty_individual, nMutation, pop, SelectLeader(EP, beta), sigma, LB, UB, CostFunction);
    EP = [EP
        ndpop
        popc]; %#ok
    
    EP = DetermineDomination(EP);
    index = find([EP.hasfound] > 0);
    EP = EP(index);
    
    if numel(EP)>nArchive
        Extra = numel(EP)-nArchive;
        ToBeDeleted = randsample(numel(EP), Extra);
        EP(ToBeDeleted) = [];
    end
end

rep = EP;
end