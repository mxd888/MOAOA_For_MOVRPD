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

function xnew = Mutate(x, pm, VarMin, VarMax)

    nVar = numel(x);
    j = randi([1 nVar]);

    vmin = 0;
    vmax = 0;
    if numel(VarMin) > 1
        vmin = VarMin(j);
        vmax = VarMax(j);
    else
        vmin = VarMin;
        vmax = VarMax;
    end
    dx = pm*(vmax-vmin);
    
    lb = x(j) - dx;
    if lb < vmin
        lb = vmin;
    end
    
    ub = x(j) + dx;
    if ub > vmax
        ub = vmax;
    end
    
    xnew = x;
    xnew(j) = unifrnd(lb, ub);

end