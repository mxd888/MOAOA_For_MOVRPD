%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Multi-Objective PSO in MATLAB (URL: https://yarpiz.com/59/ypea121-mopso), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [rep, pop] = DetermineDomination(rep, pop)

    nPop=numel(pop);
    
    for i = 1:nPop
        
        pop(i).DominationSet = [];
        
        pop(i).DominatedCount = 0;
        
    end
    
    nRep=numel(rep);
    
    for i = 1:nRep
        
        rep(i).DominationSet = [];
        
        rep(i).DominatedCount = 0;
        
    end
    
    for i=1:nPop
        
        p=pop(i);
        
        for j=1:nRep
            
            q=rep(j);
            
            if Dominates(p, q)
                
                p.DominationSet = [p.DominationSet j];
                
                q.DominatedCount = q.DominatedCount+1;
                
            elseif Dominates(q, p)
                
                q.DominationSet = [q.DominationSet i];
                
                p.DominatedCount = p.DominatedCount+1;
                
            end
            
            rep(j) = q;
            
        end
        
        pop(i) = p;
        
    end

end