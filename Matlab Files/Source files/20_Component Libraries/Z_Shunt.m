pitch=127.0;
N=9;
recess=55.0;
U_width=150.0;
y1=100;
y2=200;
y3=-190;
r=75;
tol_rad=0.005;

x_in=-pitch*N/2;
x_out=-x_in;
x_left=x_in-recess;
x_right=-x_left;

r_U=U_width*sqrt(2)/pi;

path_1=[x_in x_in x_left x_left; 0 y1 y1 y2];
path_1=round_edges_orthogonal_path_sine(path_1,r,tol_rad);
path_5=[-path_1(1,:); path_1(2,:)];
path_5=fliplr(path_5);

path_2=Uturn_SineCircSine(r_U,tol_rad,path_1(:,end),'i');
path_4=[-path_2(1,:); path_2(2,:)];
path_4=fliplr(path_4);

x_turn_in=path_2(1,end);
x_turn_out=path_4(1,1);

path_3=[x_turn_in x_turn_in x_turn_out x_turn_out; path_2(2,end) y3 y3 path_4(2,1)];
path_3=round_edges_orthogonal_path_sine(path_3,r,tol_rad);

path=[path_1 path_2 path_3 path_4 path_5];
path=clean_path(path);

plotpath(path);
hold on
scatter(-127*4.5:127:127*4.5,zeros(1,10),'r');

GDSData=Raith_library('OptShunt10');
GDS_Elements=[];
layer(1)=1;
layer(2)=3;
width(1)=0.6;
width(2)=3.0;
for i=1:2
    GDS_Elements=[GDS_Elements Raith_element('path',layer(i),path,width(i),layer(i)/8*1.5)];
end
GDSDataStruct=Raith_structure('Shunt10',GDS_Elements);
GDSData.append(GDSDataStruct);
GDSData.writegds('plain');