function merged_route = mergedmnRoute(mDronePath,nDronePath,cminRindex,cninRindex)
merged_route=[];
if cminRindex == 2 && cninRindex==2 %��Ҫ�����һ��·�߽��еߵ�
    merged_route = [mDronePath(end:-1:2),nDronePath(2:end)];
elseif cminRindex == length(mDronePath)-1 && cninRindex==2
    merged_route = [mDronePath(1:end-1),nDronePath(2:end)];
elseif cminRindex ==2 && cninRindex == length(nDronePath)-1
    merged_route = [mDronePath(end:-1:2),nDronePath(end-1:-1:1)];
elseif cminRindex == length(mDronePath)-1 && cninRindex == length(nDronePath)-1
    merged_route = [mDronePath(1:end-1), nDronePath(end-1:-1:1)];
end
end