function [rounded_path_ArcsSegs,fullpath]=round_edges_orthogonal_path(path,radius,NSegArcs)
% Only works for paths of vertical and horizontal segments
% first and last segment have to be longer than "radius"
% if there is a U turn, the segment in the middle of the U has to be longer
% than 2*radius.
% there can't be two consecutive segments shorter than 2*radius

Nv=size(path,2);
for i_seg=1:Nv-1
    seg_vec(:,i_seg)=path(:,i_seg+1)-path(:,i_seg);
    seg_length(i_seg)=norm(seg_vec(:,i_seg));
    seg_e(:,i_seg)=seg_vec(:,i_seg)/seg_length(i_seg);
end

% remaining straight paths
new_paths(1).Coord(:,1)=path(:,1);

for iv=2:Nv-1
    e_in=seg_e(:,iv-1);
    rot_e_in=rotate_xy(e_in);
    e_out=seg_e(:,iv);
    rot_e_out=rotate_xy(e_out);

    if seg_length(iv)>=2*radius || iv==Nv-1 
        if seg_length(iv-1)>=2*radius || iv==2
            % valid even for non-right angles
            % this is the general case in which the arcs are tangent to the
            % two lines
            arc_center(:,iv-1)=path(:,iv)+radius*(e_out-e_in)/abs(dot(rot_e_in,e_out));
            new_paths(iv-1).Coord(:,2)=path(:,iv)+radius*dot(e_out-e_in,e_in)*e_in/abs(dot(rot_e_in,e_out));
            new_paths(iv).Coord(:,1)=path(:,iv)+radius*dot(e_out-e_in,e_out)/abs(dot(rot_e_in,e_out))*e_out;
            angle_in=angle_vec(-rot_e_in*dot(rot_e_in,e_out));
            angle_out=angle_vec(-rot_e_out*dot(rot_e_in,e_out));       
        else
            % this part needs to be modified to consider non-right angles
            % at the vertice
            % this is the case in which the arc can only be tangent to the
            % exit segment
            a=radius-seg_length(iv-1)/2;
            b=sqrt(radius^2-a^2);
            arc_center(:,iv-1)=path(:,iv)-radius*e_in+b*e_out;
            new_paths(iv-1).Coord(:,2)=path(:,iv)-seg_length(iv-1)/2*e_in;
            new_paths(iv).Coord(:,1)=path(:,iv)+b*e_out;
            angle_in=angle_vec(a*e_in-b*e_out);
            angle_out=angle_vec(e_in);
        end
    else
        % this part needs to be modified to consider non-right angles at
        % the vertice
        % this is the case in which the arc can only be tangent to the
        % incoming segment
        a=radius-seg_length(iv)/2;
        b=sqrt(radius^2-a^2);
        arc_center(:,iv-1)=path(:,iv)+radius*e_out-b*e_in;
        new_paths(iv-1).Coord(:,2)=path(:,iv)-b*e_in;
        new_paths(iv).Coord(:,1)=path(:,iv)+seg_length(iv)/2*e_out;
        angle_in=angle_vec(-e_out);
        angle_out=angle_vec(-a*e_out+b*e_in);
         
    end
    if dot(rot_e_in,e_out)>0
        arc_angle(:,iv-1)=[angle_in;angle_out];
    else
        arc_angle(:,iv-1)=[angle_out;angle_in];
    end
    if arc_angle(2,iv-1)<arc_angle(1,iv-1)
        arc_angle(2,iv-1)=arc_angle(2,iv-1)+2*pi;
    end
end
new_paths(Nv-1).Coord(:,2)=path(:,Nv);

% at this stage the order of the elements is 
% new_paths(1) . arc(1) . new_paths(2) . arc(2) . ... . arc(Nv-2) . new_paths(Nv-1)

% some of the new paths may have zero length if there where segments
% initially two short:
% inner segments shorter than 2*radius
% outer segments of exactly 1*radius.
NonZeroPaths=0;
for ip=1:Nv-1
    % convert arcs to paths and connect to the straight paths
    if ip==1
        fullpath=new_paths(ip).Coord;
    else 
        fullpath=[fullpath new_paths(ip).Coord];
    end 
    if ip<Nv-1 % there is ons less arc than segments
        arc_path=convert_Arc_2_Path(arc_center(:,ip),arc_angle(:,ip),radius,NSegArcs);
        l1=norm(fullpath(:,end)-arc_path(:,1));
        l2=norm(fullpath(:,end)-arc_path(:,end));
        if l1<l2 % the arcs are always defined clockwise,
            %but on the path they may need to be concatenated in counter-clockwise
            fullpath=[fullpath arc_path];
        else
            fullpath=[fullpath arc_path(:,end:-1:1)];
        end
    end
    % store only paths with non-0 length in new_NZpaths
    if norm(new_paths(ip).Coord(:,2)-new_paths(ip).Coord(:,1))>0
        NonZeroPaths=NonZeroPaths+1;
        new_NZpaths(NonZeroPaths)=new_paths(ip);
    end
end

fullpath=clean_path(fullpath);

rounded_path_ArcsSegs.arc_center=arc_center;
rounded_path_ArcsSegs.arc_angle=arc_angle;
rounded_path_ArcsSegs.straight_path=new_NZpaths;

end