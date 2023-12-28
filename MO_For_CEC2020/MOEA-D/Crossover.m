%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA124
% Project Title: Implementation of MOEA/D
% Muti-Objective Evolutionary Algorithm based on Decomposition
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, MOEA/D in MATLAB (URL: https://yarpiz.com/95/ypea124-moead), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function y = Crossover(x1, x2, params)

    gamma = params.gamma;
    VarMin = params.VarMin;
    VarMax = params.VarMax;
    
    alpha = unifrnd(-gamma, 1+gamma, size(x1));
    
    y = alpha.*x1+(1-alpha).*x2;

    y = min(max(y, VarMin), VarMax);
    
end