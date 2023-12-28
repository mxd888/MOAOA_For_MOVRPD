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

function [y1, y2] = Crossover(x1, x2, params)

    gamma = params.gamma;
    VarMin = params.VarMin;
    VarMax = params.VarMax;
    
    alpha = unifrnd(-gamma, 1+gamma, size(x1));
    
    y1 = alpha.*x1+(1-alpha).*x2;
    y2 = alpha.*x2+(1-alpha).*x1;
    
    y1 = min(max(y1, VarMin), VarMax);
    y2 = min(max(y2, VarMin), VarMax);

end