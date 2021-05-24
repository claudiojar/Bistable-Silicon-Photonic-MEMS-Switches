close all
clear all


%% Constants and magic numbers
w_BWG_rib = 0.6; %um
w_BWG_strip = 0.45; %um
w_etch = 2; %um width of etching for the strip WG
offset_taper = ((w_etch+w_BWG_strip)/2); 


%% Component creation
%r=[5:9  10:5:150];
r=8;
tol_rad=0.001;
offset=0.001;
figure;

write_dir = ['C:\Users\claud\Google Drive\EPFL\2. Master\MA2 - 2021\'...
    'MICRO-498 Semester Project\Design\Exports\GDS'];

%First layer
LayerStruct.layers(1)=1;
LayerStruct.widths(1)=2*w_etch;
StructCode='HalfSine0p6';
BendLib=Raith_library('HalfSine_Lib');

%Second layer
LayerStruct.layers(2)=3;
LayerStruct.widths(2)=w_BWG_strip;

%StructCode='Bend90Sine0p6Alumina';
%BendLib=Raith_library('BendSineAlumina_Lib');
%the spline turns by pi/4 rad
for i=1:numel(r)
    N=round(pi/4*sqrt(r(i)/(2*tol_rad))); %This formula is for a tolerance of tol_rad and for a circular arc of angle pi/2
    x_raw=-pi/2:(pi/2)/N:0;
    y_raw=cos(x_raw)-pi/2;
    x=x_raw*r(i);
    y=y_raw*r(i);
    x=[x(1)-offset x x(end)+offset];
    y=[y(1)-offset y y(end)];
    path=[x;y];
    path_rot=rot_angle_CCW(path,pi/4);
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
    