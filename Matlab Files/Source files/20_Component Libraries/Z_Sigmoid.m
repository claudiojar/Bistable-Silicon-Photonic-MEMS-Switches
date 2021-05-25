close all;
clear variables;

%% Author : Claudio Jaramillo
% Using code written by Dr. Furci
% Originally created : 26.04.2021

%% Constants and magic numbers
w_BWG_rib = 0.6; %um
w_BWG_strip = 0.45; %um
w_etch = 2; %um width of etching for the strip WG
w_coupler = 1;

offset_taper = ((w_etch+w_BWG_strip)/2); 

a = 39.607 ; %height of sigmoid function 
b_manual = 0.1 ;%slope
length_coupler = 23; %half length, multiply by 2 for real length
%On the BWG the length bewteen the branches is 39.607 um, we add 3 um side
%to side as a buffer, and therefore we require a coupler of length 46 um
%and half length of 23 um as the smallest possible


step_counter = 1;
nb_of_points = 1000;


%% Point wise sigmoid function for data extraction
x_space = linspace(-length_coupler,length_coupler,nb_of_points);
sigmoid_y = zeros(1, nb_of_points);


%% Computing the curvature and determining the optimum slope 
%

sigmoid_diff_y = zeros(1, nb_of_points);
sigmoid_diff2_y = zeros(1, nb_of_points);
curvature_y = zeros(1,nb_of_points);
curvature_radius_y = zeros(1,nb_of_points);

b = 2;

while any(curvature_radius_y(:)<5)

    for i=1:1:nb_of_points
        sigmoid_y(i) = logistic_func(x_space(i),a,b);

        sigmoid_diff_y(i) = -logistic_func(x_space(i),a,b)*...
            (b*exp(b*x_space(i)))/(1+exp(b*x_space(i)));

        sigmoid_diff2_y(i) = logistic_func(x_space(i),a,b)*...
            ((b^2)*exp(b*x_space(i))*(exp(b*x_space(i))-1))/...
            ((1+exp(b*x_space(i)))^2);

        curvature_y(i) = abs(sigmoid_diff2_y(i))./...
            ((1+sigmoid_diff_y(i)^2)^(3/2));
        
        curvature_radius_y(i) = 1/curvature_y(i);
    end
    myMin = min(curvature_radius_y(:));
    
    b=b-0.001;
    
end

%disp(b);

%% Sigmoid func plot
figure_sigmoid = figure();

plot(x_space,sigmoid_y)

%params
title('Sigmoid function describing the coupler')
subtitle('Centered at inflection point')
xlabel('Signed coupler length [um]')
ylabel('Coupler height [um]')
set(gca,'FontSize',12)
grid on;


%% Curvature radius func plot
figure_sigmoid_curvature = figure();

plot(x_space,(1./curvature_y));

%params
title('Curvature radius of sigmoid function')
xlabel('Signed coupler length [um]')
ylabel('Curvature radius [0,20] [um]')
ylim([0 20]);
xlim([-length_coupler length_coupler]);
set(gca,'FontSize',12)
grid on;


%% Creating the GDSII file
%use of wraith toolbox to generate GDSII file


create_file = questdlg('Create GDSII file ?');

if (strcmp(create_file,'Yes'))

    write_dir = ['C:\Users\claud\Google Drive\EPFL\2. Master\MA2 - 2021\'...
        'MICRO-498 Semester Project\Design\Exports\GDS'];

    %figure();
    %layer 1
    LayerStruct.layers(1)=1;
    %1 corresponds to the GDSII layer number
    LayerStruct.widths(1)=w_coupler; %in um

    % %layer 2
    % LayerStruct.layers(2)=3; %adding other layers
    % %3 corresponds to the GDSII layer number
    % LayerStruct.widths(2)=2*w_etch; %adding other layers

    StructCode='SigmoidCoupler';
    BendLib=Raith_library('SigmoidCoupler');

    x = x_space;
    y = sigmoid_y;

    path = [x;y];

    for e=1:numel(LayerStruct.layers)
        layer=LayerStruct.layers(e);
        width=LayerStruct.widths(e); 
        BendVector(e)=Raith_element('path',layer,path,width,layer/8*1.5);
    end

    StrName=[StructCode sprintf('SigmoidCoupler_v4_suspended')];
    BendStruct=Raith_structure(StrName,BendVector);
    BendLib.append(BendStruct);

    if (isfile(write_dir))
        BendLib.writegds(write_dir,'plain');
    else
        BendLib.writegds('plain');
    end
end


%% Optical losses computation
integrand = sqrt(1+(sigmoid_diff_y).^2);

Length.Total = trapz(x_space,integrand);

min_radius = 12;

% the value for 12 um is found in literature
epsilon_ = 1;
xlims = find(curvature_radius_y>12-epsilon_ &...
    curvature_radius_y<12+epsilon_);
step_ = 0.001;

while (numel(xlims)>4)
    epsilon_ = epsilon_- step_;
    xlims = find(curvature_radius_y>12-epsilon_ &...
    curvature_radius_y<12+epsilon_);
end

%computing the length considered as ''straight''
x_space_straight1 = x_space(1, 1:xlims(1));
x_space_straight2 = x_space(1, xlims(2):xlims(3));
x_space_straight3 = x_space(1, xlims(4):end);

Length.Straight = trapz(x_space(1, 1:xlims(1)),integrand(1, 1:xlims(1)))+...
    trapz(x_space(1, xlims(2):xlims(3)),integrand(1, xlims(2):xlims(3)))+...
    trapz(x_space(1, xlims(4):end),integrand(1, xlims(4):end));


%% Computation of losses
% we will use certain values found in literature 

param.prop_loss = 1.6; %[dB/cm], from Dr. Furci's research

%all values for strip waveguides, form literature
param.loss.R5 = 2e-2; %[dB/90deg bend] at 5 um, from literature
param.loss.R8 = 9e-3; %[dB/90deg bend] at 8 um, from literature
param.loss.R10 = 8e-3;
param.loss.R15 = 9e-3; %[dB/90deg bend] at 15 um, from literature

param.low_loss_crossing =  0.011; %low loss crossing loss, from research

for i=0:15:180
   param.scale_factor.(sprintf('angle_%d', i)) = i/90 ; 
end

total_loss.coupler = (Length.Straight/10000)*param.prop_loss +...
    2*param.loss.R5*param.scale_factor.angle_90;


Length.Straight_BWG = 2*38.298;

total_loss.BWG = (Length.Straight_BWG/10000)*param.prop_loss +...
    4*param.loss.R5*param.scale_factor.angle_90 + ...
    param.low_loss_crossing;

disp(total_loss.coupler)
disp(total_loss.BWG)

close all;

%% Functions

% Function : Sigmoid function
function [y1] = logistic_func(x1,a,b)
    y1 = a ./ (1+exp(b*x1));
end
