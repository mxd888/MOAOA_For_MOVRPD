%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
%
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
%
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
%
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function popm = Mutate(empty_individual, nMutation, pop, LB, UB, CostFunction)

sigma = 0.1*(UB-LB);                            % Mutation Step Size
mu = 0.02;                                      % 变异概率
nVar = numel(pop);

popm = repmat(empty_individual, nMutation, 1);
for k = 1:nMutation
    m = randi([1 nVar]);
    p = pop(m);
    popm(k).Position = limitToPosition(Mutate0(p.Position, mu, sigma),LB,UB);
    
    % 判断结构体是否具有 'data' 属性
    if isfield(pop, 'VehiclePath')
        [popm(k).VehiclePath, popm(k).DronePath, popm(k).Cost, popm(k).hasfound] = CostFunction(unique(floor(popm(k).Position)));
    else
        popm(k).Cost = feval(CostFunction, popm(k).Position);
    end
    
end


end

function y0 = Mutate0(x, mu, sigma)

nVar = numel(x);

nMu = ceil(mu*nVar);

j = randsample(nVar, nMu);
if numel(sigma)>1
    sigma = sigma(j);
end

y0 = x;

y0(j) = x(j)+sigma.*randn(size(j));

end




