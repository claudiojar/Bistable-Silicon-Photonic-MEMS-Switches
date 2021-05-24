function fullpath=round_edges_orthogonal_path_sine(path,radius,tol_rad)
% Only works for paths of vertical and horizontal segments
% first and last segment have to be longer than "pi*radius/sqrt(2)" (but not necessarily than sqrt(2)*pi*radius)
% if there is a U turn, the segment in the middle of the U has to be longer
% than 2*radius.
% there can't be two consecutive segments shorter than 2*radius

Nv=size(path,2);
for i_seg=1:Nv-1
    seg_vec(:,i_seg)=path(:,i_seg+1)-path(:,i_seg);
    seg_length(i_seg)=norm(seg_vec(:,i_seg));
    seg_e(:,i_seg)=seg_vec(:,i_seg)/seg_length(i_seg);
end

% output path
new_path(:,1)=path(:,1);
iv=2;
while iv<=Nv-1
    e_in=seg_e(:,iv-1);
    rot_e_in=rotate_xy(e_in); %rotates CCW
    e_out=seg_e(:,iv);
    rot_e_out=rotate_xy(e_out); %rotates CCW

    if seg_length(iv)>=sqrt(2)*pi*radius || iv==Nv-1 
        if seg_length(iv-1)>=sqrt(2)*pi*radius || iv==2           
            A=radius;
            N_points=ceil(pi/2*sqrt(radius/2/tol_rad))+1;
            x=linspace(-pi,0,N_points);
            y=A*sin(x);
            S_bend_path=[x*A;y];
            S_bend_path=rotate_angle_CCW(S_bend_path,pi/4);
            J=path(:,iv)+e_out*pi*radius/sqrt(2); %center of the segment
            S_bend_path=J+[e_in e_out]*S_bend_path;
            
            new_path=[new_path S_bend_path];
        else
            % this case should not happen
        end
    else
        % This is the case in which there is an S parallel transition 
        % U turn with too short middle segment has been ruled out as the 
        % designer will avoid them,
        H=seg_length(iv);
        r=radius;
        alpha=H/2/pi/r*sqrt(0.5*(1+sqrt(1+16*pi*pi*r*r/H/H)));
        A=alpha^2*r;
        N_points=ceil(alpha*pi*sqrt(r/2/tol_rad))+1;
        x=linspace(-pi*A/alpha,pi*A/alpha,N_points);
        y=A*sin(alpha/A*x);
        S_bend_path=[x;y];
        S_bend_path=rotate_angle_CCW(S_bend_path,atan(alpha));
        J=(path(:,iv+1)+path(:,iv))/2; %center of the segment
        S_bend_path=J+[e_in e_out]*S_bend_path;
        
        new_path=[new_path S_bend_path];
        iv=iv+1;
        
    end
    
    iv=iv+1;
end

new_path=[new_path path(:,Nv)];

fullpath=clean_path(new_path);

end