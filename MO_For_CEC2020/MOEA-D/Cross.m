function Y = Cross(empty_individual, nMutation, pop, leader, sigma, LB, UB, CostFunction)

q = 0.5;

N = numel(pop);

w = 1/(sqrt(2*pi)*q*N)*exp(-0.5*(((1:N)-1)/(q*N)).^2);

p = w/sum(w);

repository = repmat(empty_individual, nMutation, 1);


for i = 1: nMutation
    pop(i).Position = UB + LB - pop(i).Position;
%     pop(i).Cost = feval(CostFunction, pop(i).Position);
    % 判断结构体是否具有 'data' 属性
    if isfield(pop, 'VehiclePath')
        [pop(i).VehiclePath, pop(i).DronePath, pop(i).Cost, pop(i).hasfound] = CostFunction(unique(floor(pop(i).Position)));
    else
        pop(i).Cost = feval(CostFunction, pop(i).Position);
    end
end

Dim = size(pop(1).Position, 2);
for t = 1:nMutation
    
    repository(t).Position = zeros([1 Dim]);
    
    for i = 1:Dim
        
        l = RouletteWheelSelection(p);
        
        repository(t).Position(i)=limitToPosition(leader.Position(i)+sigma(l, i)*randn,LB,UB);
        
    end
    
%     repository(t).Cost = feval(CostFunction, repository(t).Position);
    if isfield(pop, 'VehiclePath')
        [repository(t).VehiclePath, repository(t).DronePath, repository(t).Cost, repository(t).hasfound] = CostFunction(unique(floor(repository(t).Position)));
    else
        repository(t).Cost = feval(CostFunction, repository(t).Position);
    end
end

Y = [pop(1: nMutation)
    repository];

end