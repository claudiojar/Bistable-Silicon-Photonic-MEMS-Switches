close all;
clear variables;

%% Author : Claudio Jaramillo
% Using code written by Dr. Furci
% Created : 03.05.2021

%% Variables and magic numbers

taper_w_large = 0.6; %width of large end of taper [um]
taper_w_small = 0.45; %width of small end of taper [um]
taper_l = 15; %taper length [um] 
iter = 100; %the number of lines drawn to generate the taper


%% Coordinate of vertex generator
% we build the taper from bottom to top. The large width is at the bottom
% bottom left corner is (0,0)

coord.x = zeros(1,4);
coord.y = zeros(1,4);

coord.x(2) = taper_w_large;
coord.x(3) = (taper_w_large/2)-(taper_w_small/2);
coord.x(4) = (taper_w_large/2)+(taper_w_small/2);

coord.y(3) = taper_l;
coord.y(4) = taper_l;


%% Path generator

for i=(0):(taper_l/iter):(taper_l)
   disp(i) 
end

% 
% %% Creating the GDSII file
% % Written by Dr. Furci, modified by C. Jaramillo on the 07.04.2021
% % use of wraith toolbox to generate GDSII file
% 
% write_dir = ['C:\Users\claud\Google Drive\EPFL\2. Master\MA2 - 2021\'...
%     'MICRO-498 Semester Project\Design\Exports'];
% 
% %figure();
% %layer 1
% LayerStruct.layers(1)=1;
% %1 corresponds to the GDSII layer number
% LayerStruct.widths(1)=0.6; %in um
% 
% %layer 2
% LayerStruct.layers(2)=3; %adding other layers
% %3 corresponds to the GDSII layer number
% LayerStruct.widths(2)=1.8; %adding other layers
% 
% StructCode='Taper_0p6';
% BendLib=Raith_library('Taper');
% 
% x = scale_factor*[bez_curve1_x bez_curve2_x bez_curve3_x];
% y = scale_factor*[bez_curve1_y bez_curve2_y bez_curve3_y];
% 
% path = [x;y];
% 
% for e=1:numel(LayerStruct.layers)
%     layer=LayerStruct.layers(e);
%     width=LayerStruct.widths(e); 
%     BendVector(e)=Raith_element('path',layer,path,width,layer/8*1.5);
% end
% 
% StrName=[StructCode sprintf('Taper')];
% BendStruct=Raith_structure(StrName,BendVector);
% BendLib.append(BendStruct);
% BendLib.writegds(write_dir,'plain');
