close all
clear all


%% Constants and magic numbers
w_BWG_rib = 0.6; %um
w_BWG_strip = 0.45; %um
w_etch = 2; %um width of etching for the strip WG
offset_taper = ((w_etch+w_BWG_strip)/2); 


%% Component creation

%r=[1:10];
r=15;
tol_rad=0.001;
offset=0.5;
figure;

write_dir = ['C:\Users\claud\Google Drive\EPFL\2. Master\MA2 - 2021\'...
    'MICRO-498 Semester Project\Design\Exports\GDS'];

LayerStruct.layers(1)=1;
LayerStruct.widths(1)=2*w_etch;

LayerStruct.layers(2)=3;
LayerStruct.widths(2)=w_BWG_strip;

StructCode='SineTurn_ang45_w0p6';
BendLib=Raith_library('SineTurn_ang45_w0p6_Lib');
%StructCode='Bend90Sine0p6Alumina';
%BendLib=Raith_library('BendSineAlumina_Lib');
TurnAngle=pi/4;
for i=1:numel(r)
    N=round(pi/4*sqrt(r(i)/(2*tol_rad))); %This formula is for a tolerance of tol_rad and for a circular arc of angle pi/2
    x_raw=0:(pi/2)/N:pi;
    y_raw=tan(TurnAngle/2)*sin(x_raw);
    x=x_raw*r(i)*tan(TurnAngle/2);
    y=y_raw*r(i)*tan(TurnAngle/2);
    x=[x(1)-offset*cos(TurnAngle/2) x x(end)+offset*cos(TurnAngle/2)];
    y=[y(1)-offset*sin(TurnAngle/2) y y(end)-offset*sin(TurnAngle/2)];
    path=[x;y];
    path_rot=rotate_angle_CCW(path,-TurnAngle/2);
    plot(path_rot(1,:),path_rot(2,:));
    hold on
    axis equal
    for e=1:numel(LayerStruct.layers)
        layer=LayerStruct.layers(e);
        width=LayerStruct.widths(e);
        BendVector(e)=Raith_element('path',layer,path_rot,width,layer/8*1.5);
    end
    StrName=[StructCode sprintf('_R%06.0fnm_Off%03.0fnm_fullyetched',...
        1000*r(i),1000*offset)];
    BendStruct=Raith_structure(StrName,BendVector);
    BendLib.append(BendStruct);
end
BendLib.writegds(write_dir,'plain')
    