function [poly_out]=tapered_path_steps(path,WidthVals,iBoundaries)
%the path needs to contain at least two points
%iBoundaries containes a 1 in the first elements

N=size(path,2);
Nzones=numel(iBoundaries)-1;
W_in=WidthVals(1:end-1);
W_out=WidthVals(2:end);
i_In=iBoundaries(1:end-1);
i_Out=iBoundaries(2:end);
N_inZone=i_Out-i_In;

S=zeros(1,N);
normal=zeros(2,N);
width=W_in(1)*ones(1,N);

for i=2:N
    S(i)=S(i-1)+norm(path(:,i)-path(:,i-1));
end

for j=1:Nzones 
    for i=i_In(j):i_Out(j)
        frac=(S(i)-S(i_In(j)))/(S(i_Out(j))-S(i_In(j)));
        width(i)=W_in(j)+frac*(W_out(j)-W_in(j));
    end
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