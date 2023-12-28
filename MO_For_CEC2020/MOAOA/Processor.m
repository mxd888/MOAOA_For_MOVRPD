
% 非支配排序处理
function [pop, F] = Processor(pop, P)

    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    if rand() > P
        [pop, F] = SortPopulation(pop);
    else
        [pop, F] = SortPopulationOnlyCrowd(pop);
    end
    
end