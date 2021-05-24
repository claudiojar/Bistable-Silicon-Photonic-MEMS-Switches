function [poly_out]=tapered_path(path,tap_in,tap_out)
%the path needs to contain at least two points

N=size(path,2);
S=zeros(1,N);
normal=zeros(2,N);
width=tap_in*ones(1,N);

for i=2:N
    S(i)=S(i-1)+norm(path(:,i)-path(:,i-1));
end
for i=2:N
    frac=S(i)/S(N);
    width(i)=tap_in+frac*(tap_out-tap_in);
end

v=(path(:,2)-path(:,1));
v=v/norm(v);
normal(:,1)=rotate_90_CCW(v);

v=(path(:,N)-path(:,N-1));
v=v/norm(v);
normal(:,N)=rotate_90_CCW(v);

for i=2:N-1
    v_ant=(path(:,i)-path(:,i-1));
    v_ant=v_ant/norm(v_ant);
    normal_ant=rotate_90_CCW(v_ant);
    v_pos=(path(:,i+1)-path(:,i));
    v_pos=v_pos/norm(v_pos);
    normal_pos=rotate_90_CCW(v_pos);
    normal(:,i)=normal_ant+normal_pos;
    normal(:,i)=normal(:,i)/norm(normal(:,i));
end

for i=1:N
    path_left(:,i)=path(:,i)+width(i)/2*normal(:,i);
    path_right(:,i)=path(:,i)-width(i)/2*normal(:,i);
end

poly_out=[path_left fliplr(path_right) path_left(:,1)];

end