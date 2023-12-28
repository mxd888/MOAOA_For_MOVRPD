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

function leader = SelectLeader(rep, beta)
    

    nRep = numel(rep);
    if nRep <= 2
        leader = rep(1);
    else
        nRep = ceil(nRep/10);
        if nRep > 10
            nRep = 10;
        end
        
    % Number of Particles in Occupied Cells
    N = zeros(nRep);
    for k = 1:nRep
        N(k) = 1/(k);
    end
    
    % Selection Probabilities
    P = exp(-beta*N);
    P = sort(P/sum(P), 'descend');
    
    % Selected Cell Index
    sci = RouletteWheelSelection(P);
    
    % Selected Cell
    leader = rep(sci);
    % disp(sci)
    end
        

end