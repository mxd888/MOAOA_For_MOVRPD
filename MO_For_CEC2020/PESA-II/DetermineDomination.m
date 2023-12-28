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

function pop = DetermineDomination(pop)

    n = numel(pop);

    for i = 1:n
        pop(i).IsDominated = false;
    end

    for i = 1:n
        if pop(i).IsDominated
            continue;
        end
        
        for j = 1:n
            if Dominates(pop(j), pop(i))
                pop(i).IsDominated = true;
                break;
            end
        end
    end

end