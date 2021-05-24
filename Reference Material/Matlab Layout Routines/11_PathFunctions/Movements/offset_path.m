function new_path=offset_path(path,offset) %offsets the curve to the left for positive offset

Nv=size(path,2);
new_path=path;

%first point of the path
vec1=path(:,2)-path(:,1);
e1=vec1/norm(vec1);
rot_e1(1,1)=-e1(2,1);
rot_e1(2,1)=e1(1,1);
new_path(:,1)=path(:,1)+rot_e1*offset;

%last point of the path
vec1=path(:,Nv)-path(:,Nv-1);
e1=vec1/norm(vec1);
rot_e1(1,1)=-e1(2,1);
rot_e1(2,1)=e1(1,1);
new_path(:,Nv)=path(:,Nv)+rot_e1*offset;

for i_vert=2:Nv-1
    
    vec1=path(:,i_vert)-path(:,i_vert-1);
    vec2=path(:,i_vert+1)-path(:,i_vert);
    
    e1=vec1/norm(vec1);
    e2=vec2/norm(vec2);
    
    rot_e1(1,1)=-e1(2,1);
    rot_e1(2,1)=e1(1,1);
    
    new_path(:,i_vert)=path(:,i_vert)+offset*(e2-e1)/dot(rot_e1,e2);
    
end

end
