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

function P = SelectFromPopulation(pop, grid, beta)

    sg = grid([grid.N]>0);

    p = 1./[sg.N].^beta;
    p = p/sum(p);

    k = RouletteWheelSelection(p);

    Members = sg(k).Members;

    i = Members(randi([1 numel(Members)]));
    
    P = pop(i);

end