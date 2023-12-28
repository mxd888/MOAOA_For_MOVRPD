function [ps,pf]=MOPSO_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)
%% Problem Definition

nVar = Dim;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix

VarMin = LB;          % Lower Bound of Variables
VarMax = UB;          % Upper Bound of Variables


%% MOPSO Parameters

MaxIt = M_Iter;           % Maximum Number of Iterations

nPop = N;            % Population Size

w = 0.5;              % Inertia Weight
wdamp = 0.99;         % Intertia Weight Damping Rate
c1 = 1;               % Personal Learning Coefficient
c2 = 2;               % Global Learning Coefficient

nGrid = 7;            % Number of Grids per Dimension
alpha = 0.1;          % Inflation Rate

beta = 2;             % Leader Selection Pressure
gamma = 2;            % Deletion Selection Pressure

mu = 0.1;             % Mutation Rate

%% Initialization

empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];
empty_particle.IsDominated = [];
empty_particle.GridIndex = [];
empty_particle.GridSubIndex = [];

pop = repmat(empty_particle, nPop, 1);

for i = 1:nPop
    
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    pop(i).Velocity = zeros(VarSize);
    
    pop(i).Cost = feval(CostFunction, pop(i).Position);
    
    
    % Update Personal Best
    pop(i).Best.Position = pop(i).Position;
    pop(i).Best.Cost = pop(i).Cost;
    
end

% Determine Domination
pop = DetermineDomination(pop);

rep = pop(~[pop.IsDominated]);

Grid = CreateGrid(rep, nGrid, alpha);

for i = 1:numel(rep)
    rep(i) = FindGridIndex(rep(i), Grid);
end


%% MOPSO Main Loop

for it = 1:MaxIt
    
    for i = 1:nPop
        
        leader = SelectLeader(rep, beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
%         pop(i).Position = max(pop(i).Position, VarMin);
%         pop(i).Position = min(pop(i).Position, VarMax);
        pop(i).Position = limitToPosition(pop(i).Position,VarMin,VarMax);
        pop(i).Cost = feval(CostFunction, pop(i).Position);
        
        % Apply Mutation
        pm = (1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position = Mutate(pop(i).Position, pm, VarMin, VarMax);
            NewSol.Position = limitToPosition(NewSol.Position,VarMin,VarMax);
            NewSol.Cost = feval(CostFunction, NewSol.Position);
            if Dominates(NewSol, pop(i))
                pop(i).Position = NewSol.Position;
                pop(i).Cost = NewSol.Cost;
                
            elseif Dominates(pop(i), NewSol)
                % Do Nothing
                
            else
                if rand<0.5
                    pop(i).Position = NewSol.Position;
                    pop(i).Cost = NewSol.Cost;
                end
            end
        end
        
        if Dominates(pop(i), pop(i).Best)
            pop(i).Best.Position = pop(i).Position;
            pop(i).Best.Cost = pop(i).Cost;
            
        elseif Dominates(pop(i).Best, pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position = pop(i).Position;
                pop(i).Best.Cost = pop(i).Cost;
            end
        end
        
    end
    
    % Add Non-Dominated Particles to REPOSITORY
    rep = [rep
        pop(~[pop.IsDominated])]; %#ok
    
    % Determine Domination of New Resository Members
    rep = DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep = rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid = CreateGrid(rep, nGrid, alpha);
    
    % Update Grid Indices
    for i = 1:numel(rep)
        rep(i) = FindGridIndex(rep(i), Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra = numel(rep)-nRep;
        for e = 1:Extra
            rep = DeleteOneRepMemebr(rep, gamma);
        end
        
    end
    
    % Damping Inertia Weight
    w = w*wdamp;
    
end

%% Resluts

ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(rep(1).Cost));
for i = 1: numel(rep)
    ps(i, :)=rep(i).Position;
    pf(i, :)=rep(i).Cost';
end
end