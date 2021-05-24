close all
clear all
r=[2:9  10:5:150];
alphadeg=1;
alpha=alphadeg*pi/180;
tol_rad=0.001;
offset=r/100;%straight line to stick it properly
LayerStruct.layers(1)=1;
LayerStruct.widths(1)=0.45;
StructCode=sprintf('CircSpline90_450nm');
BendLib=Raith_library(sprintf('CircSpline90_450nm_Ang%02.0fdeg_Lib',alphadeg));
%LayerStruct.layers(2)=3;
%LayerStruct.widths(2)=3.0;
%StructCode='CircSpline90_0p6Alumina';
%BendLib=Raith_library(sprintf('CircSpline90Alumina_0p6_Ang%02.0fdeg_Lib',alphadeg));
figure(1);
for i=1:numel(r)
    [path,length]=spline_param(r(i),alpha,tol_rad,0,0);
    path=[[path(1,1)+offset(i);path(2,1)] path [path(1,end);path(2,end)+offset(i)]];
    figure(1);
    plot(path(1,:),path(2,:));
    hold on
    axis equal
    
    BendVector=[];
    for e=1:numel(LayerStruct.layers)
        layer=LayerStruct.layers(e);
        width=LayerStruct.widths(e);
        BendVector=[BendVector Cut_RaithPath(Raith_element('path',layer,path,width,1.0),1000)];
    end
    StrName=[StructCode sprintf('_R%06.0fnm_Ang%02.0fdeg',1000*r(i),alphadeg)];
    BendStruct=Raith_structure(StrName,BendVector);
    BendLib.append(BendStruct);
end
BendLib.writegds('plain');
    