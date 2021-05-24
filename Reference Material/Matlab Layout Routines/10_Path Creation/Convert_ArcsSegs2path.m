function fullpath=Convert_ArcsSegs2path(segs,arc_center,arc_angle,radius,NSegArcs)

for ip=1:numel(segs)
    % convert arcs to paths and connect to the straight paths
    if ip==1
        fullpath=segs(ip).Coord;
    else 
        fullpath=[fullpath segs(ip).Coord];
    end 
    if ip<numel(segs) % there is ons less arc than segments
        arc_path=convert_Arc_2_Path(arc_center(:,ip),arc_angle(:,ip),radius,NSegArcs);
        l1=norm(fullpath(:,end)-arc_path(:,1));
        l2=norm(fullpath(:,end)-arc_path(:,end));
        if l1<l2 % the arcs are always defined clockwise,
            %but on the path they may need to be concatenated in counter-clockwise
            fullpath=[fullpath arc_path];
        else
            fullpath=[fullpath fliplr(arc_path)];
        end
    end
end

fullpath=clean_path(fullpath);
end