close all;
clear variables;
%% Author : Claudio Jaramillo
% Using code written by Dr. Furci
% Created : 15.03.2021

%% Constants and magic numbers
%parameter t will be contained between 0 and 1
%concatenation of 3 B-splines 
%each spline is a 4-point relaxed bezier curve 
%for this section the spline is contained in the [1,1] square

%definition of waypoints coordinates
x_0 = 0.398; %0.4;
x_2 = -0.068665; %0.2;
x_12 = 0.566; %0.7;
y_12 = 0.7;%0.553;
y_21 = 0.8;%0.7863336;

%fixed waypoints (magic numbers)
y_0 = 0.0; %fixed
x_21 = 1; %fixed
x_23 = 1; %fixed
y_23 = 1; %fixed

%computation of dependent waypoint coordinates
x_1 = (x_2+x_0)/2;
y_2 = -x_2 + x_0;
y_1 = (y_2+y_0)/2;

x_11 = 2*x_12-1;
y_11 = 0.5*(-(3*x_12-2)+x_0+y_12);

x_3 = (x_2+x_11)/2;
y_3 = (y_2+y_11)/2;
x_10 = x_3;
y_10 = y_3;

x_13 = (x_12+x_21)/2;
y_13 = (y_12+y_21)/2;
x_20 = x_13;
y_20 = y_13;
x_22 = (x_21+x_23)/2;
y_22 = (y_21+y_23)/2;

%creation of structures
P.x = [x_0, x_1, x_2, x_3];
P.y = [y_0, y_1, y_2, y_3];

Q.x = [x_10, x_11, x_12, x_13];
Q.y = [y_10, y_11, y_12, y_13];

R.x = [x_20, x_21, x_22, x_23];
R.y = [y_20, y_21, y_22, y_23];

%scaling factor to match the required size of waveguide
%this affects the width of the waveguide, change accordingly 
scale_factor = 1; 


%% Point wise Bezier function
%point wise bezier function
%used for geometry plot & datapoint extraction
%data points will be extracted for t in [0,1]
%scaling will be done when extracting the points into the GDSII

step_counter = 1;
nb_of_points = 50;

bez_curve1_x = zeros(1, nb_of_points+1);
bez_curve1_y = zeros(1, nb_of_points+1);

bez_curve2_x = zeros(1, nb_of_points+1);
bez_curve2_y = zeros(1, nb_of_points+1);

bez_curve3_x = zeros(1, nb_of_points+1);
bez_curve3_y = zeros(1, nb_of_points+1);

for t=0:(1/nb_of_points):1
    %curve 1
    bez1_X = (1-t)*((1-t)*((1-t)*P.x(1)+t*P.x(2))+t*((1-t)*P.x(2)+t*P.x(3)))+...
        t*((1-t)*((1-t)*P.x(2)+t*P.x(3))+t*((1-t)*P.x(3)+t*P.x(4)));
    bez1_Y = (1-t)*((1-t)*((1-t)*P.y(1)+t*P.y(2))+t*((1-t)*P.y(2)+t*P.y(3)))+...
        t*((1-t)*((1-t)*P.y(2)+t*P.y(3))+t*((1-t)*P.y(3)+t*P.y(4)));
    
    bez_curve1_x(step_counter) = bez1_X;
    bez_curve1_y(step_counter) = bez1_Y;
    
    %curve 2
    bez2_X = (1-t)*((1-t)*((1-t)*Q.x(1)+t*Q.x(2))+t*((1-t)*Q.x(2)+t*Q.x(3)))+...
        t*((1-t)*((1-t)*Q.x(2)+t*Q.x(3))+t*((1-t)*Q.x(3)+t*Q.x(4)));
    bez2_Y = (1-t)*((1-t)*((1-t)*Q.y(1)+t*Q.y(2))+t*((1-t)*Q.y(2)+t*Q.y(3)))+...
        t*((1-t)*((1-t)*Q.y(2)+t*Q.y(3))+t*((1-t)*Q.y(3)+t*Q.y(4)));
    
    bez_curve2_x(step_counter) = bez2_X;
    bez_curve2_y(step_counter) = bez2_Y;
    
    %curve 3
    bez3_X = (1-t)*((1-t)*((1-t)*R.x(1)+t*R.x(2))+t*((1-t)*R.x(2)+t*R.x(3)))+...
        t*((1-t)*((1-t)*R.x(2)+t*R.x(3))+t*((1-t)*R.x(3)+t*R.x(4)));
    bez3_Y = (1-t)*((1-t)*((1-t)*R.y(1)+t*R.y(2))+t*((1-t)*R.y(2)+t*R.y(3)))+...
        t*((1-t)*((1-t)*R.y(2)+t*R.y(3))+t*((1-t)*R.y(3)+t*R.y(4)));
    
    bez_curve3_x(step_counter) = bez3_X;
    bez_curve3_y(step_counter) = bez3_Y;
    
    step_counter = step_counter+1;
    
    %clear
    clear bez1_X
    clear bez1_Y
    clear bez2_X
    clear bez2_Y
    clear bez3_X
    clear bez3_Y
end


%% Symbolic Bezier function
%Symbolic Bezier
%symbolic bezier functions
%symbolic computations

%in this section t is in [0,1]
syms t

%first segment
bez1_X = (1-t)*((1-t)*((1-t)*P.x(1)+t*P.x(2))+t*((1-t)*P.x(2)+t*P.x(3)))+...
    t*((1-t)*((1-t)*P.x(2)+t*P.x(3))+t*((1-t)*P.x(3)+t*P.x(4)));
bez1_X_diff1 = diff(bez1_X);
bez1_X_diff2 = diff(bez1_X,2);

bez1_Y = (1-t)*((1-t)*((1-t)*P.y(1)+t*P.y(2))+t*((1-t)*P.y(2)+t*P.y(3)))+...
    t*((1-t)*((1-t)*P.y(2)+t*P.y(3))+t*((1-t)*P.y(3)+t*P.y(4)));
bez1_Y_diff1 = diff(bez1_Y);
bez1_Y_diff2 = diff(bez1_Y,2);

%second segment
bez2_X = (1-t)*((1-t)*((1-t)*Q.x(1)+t*Q.x(2))+t*((1-t)*Q.x(2)+t*Q.x(3)))+...
    t*((1-t)*((1-t)*Q.x(2)+t*Q.x(3))+t*((1-t)*Q.x(3)+t*Q.x(4)));
bez2_X_diff1 = diff(bez2_X);
bez2_X_diff2 = diff(bez2_X,2);

bez2_Y = (1-t)*((1-t)*((1-t)*Q.y(1)+t*Q.y(2))+t*((1-t)*Q.y(2)+t*Q.y(3)))+...
    t*((1-t)*((1-t)*Q.y(2)+t*Q.y(3))+t*((1-t)*Q.y(3)+t*Q.y(4)));
bez2_Y_diff1 = diff(bez2_Y);
bez2_Y_diff2 = diff(bez2_Y,2);

%third segment
bez3_X = (1-t)*((1-t)*((1-t)*R.x(1)+t*R.x(2))+t*((1-t)*R.x(2)+t*R.x(3)))+...
    t*((1-t)*((1-t)*R.x(2)+t*R.x(3))+t*((1-t)*R.x(3)+t*R.x(4)));
bez3_X_diff1 = diff(bez3_X);
bez3_X_diff2 = diff(bez3_X,2);

bez3_Y = (1-t)*((1-t)*((1-t)*R.y(1)+t*R.y(2))+t*((1-t)*R.y(2)+t*R.y(3)))+...
    t*((1-t)*((1-t)*R.y(2)+t*R.y(3))+t*((1-t)*R.y(3)+t*R.y(4)));
bez3_Y_diff1 = diff(bez3_Y);
bez3_Y_diff2 = diff(bez3_Y,2);

%curvature computation per segment
curvature1 = (bez1_X_diff1*bez1_Y_diff2-bez1_X_diff2*bez1_Y_diff1)/...
    ((bez1_X_diff1)^2 + (bez1_Y_diff1)^2)^(3/2);
curvature2 = (bez2_X_diff1*bez2_Y_diff2-bez2_X_diff2*bez2_Y_diff1)/...
    ((bez2_X_diff1)^2 + (bez2_Y_diff1)^2)^(3/2);
curvature3 = (bez3_X_diff1*bez3_Y_diff2-bez3_X_diff2*bez3_Y_diff1)/...
    ((bez3_X_diff1)^2 + (bez3_Y_diff1)^2)^(3/2);


%% Checking the curvature boundary conditions(no scaling needed)
%checking the curvature continuity points
curv1_0 = subs(curvature1, 0);
curv2_0 = subs(curvature2, 0);
curv3_0 = subs(curvature3, 0);

curv1_1 = subs(curvature1, 1);
curv2_1 = subs(curvature2, 1);
curv3_1 = subs(curvature3, 1);

sprintf('curvature1 must be 0 at t=0 : %.4g',curv1_0)
sprintf('curvature1 at t=1 must equal curvature2 at t=0 : %.4g = %.4g ?',curv1_1,curv2_0)
sprintf('curvature2 at t=1 must equal curvature3 at t=0 : %.4g = %.4g ?',curv2_1,curv3_0)
sprintf('curvature3 must be 0 at t=1 : %.4g',curv3_1)


%% Scaling
% INCLUDE IN THE MLX THE COMPUTATION FOR THE SCLAING LAW ON CURVATURE

x_minrad = zeros(1,3);
y_minrad = [0,0,0];
scale_factor_loop = 1;

% disp(y_minrad(:)<5e-6)
% disp(any(y_minrad(:)<5e-6))

while any(y_minrad(:)<5) %5 in um
    
    %sclaing the symbolic funcs to compute the IRL curvature
    %the scaling law for curvature is 1/alpha
    curvature1_temp = curvature1/scale_factor_loop; %curvaturei is unscaled
    curvature2_temp = curvature2/scale_factor_loop;
    curvature3_temp = curvature3/scale_factor_loop;

    %curvature radius for extra data
    curvature_radius{1} = abs(1/curvature1_temp);
    curvature_radius{2} = abs(1/curvature2_temp);
    curvature_radius{3} = abs(1/curvature3_temp);

    %computing minimum radius per segment
    %func_seg = cell(3,1); %3 is a magic number (3 function pieces)

    for i=1:1:3
        [x_minrad(i), y_minrad(i)] = fminbnd(matlabFunction(curvature_radius{i}), 0, 1);
        disp(y_minrad(i))
    end

%     if y_minrad<5e-6
%         scale_factor = scale_factor_loop;
%         break;
%     end
    
    scale_factor = scale_factor_loop;
    scale_factor_loop = scale_factor_loop+1;
    
    clear curvature1_temp
    clear curvature2_temp
    clear curvature3_temp
    
end


%% Variable change for plotting
%change of variables on plots 2 and 3
%introduces a shift to the right to be able to stitch the plots
%this is only for plotting !!!!
syms t
%second segment (t-1)
bez2_X_plot = (1-(t-1))*((1-(t-1))*((1-(t-1))*Q.x(1)+(t-1)*Q.x(2))+(t-1)*((1-(t-1))*Q.x(2)+(t-1)*Q.x(3)))+...
    (t-1)*((1-(t-1))*((1-(t-1))*Q.x(2)+(t-1)*Q.x(3))+(t-1)*((1-(t-1))*Q.x(3)+(t-1)*Q.x(4)));
bez2_X_diff1_plot = diff(bez2_X_plot);
bez2_X_diff2_plot = diff(bez2_X_plot,2);

bez2_Y_plot = (1-(t-1))*((1-(t-1))*((1-(t-1))*Q.y(1)+(t-1)*Q.y(2))+(t-1)*((1-(t-1))*Q.y(2)+(t-1)*Q.y(3)))+...
    (t-1)*((1-(t-1))*((1-(t-1))*Q.y(2)+(t-1)*Q.y(3))+(t-1)*((1-(t-1))*Q.y(3)+(t-1)*Q.y(4)));
bez2_Y_diff1_plot = diff(bez2_Y_plot);
bez2_Y_diff2_plot = diff(bez2_Y_plot,2);

%third segment (t-2)
bez3_X_plot = (1-(t-2))*((1-(t-2))*((1-(t-2))*R.x(1)+(t-2)*R.x(2))+(t-2)*((1-(t-2))*R.x(2)+(t-2)*R.x(3)))+...
    (t-2)*((1-(t-2))*((1-(t-2))*R.x(2)+(t-2)*R.x(3))+(t-2)*((1-(t-2))*R.x(3)+(t-2)*R.x(4)));
bez3_X_diff1_plot = diff(bez3_X_plot);
bez3_X_diff2_plot = diff(bez3_X_plot,2);

bez3_Y_plot = (1-(t-2))*((1-(t-2))*((1-(t-2))*R.y(1)+(t-2)*R.y(2))+(t-2)*((1-(t-2))*R.y(2)+(t-2)*R.y(3)))+...
    (t-2)*((1-(t-2))*((1-(t-2))*R.y(2)+(t-2)*R.y(3))+(t-2)*((1-(t-2))*R.y(3)+(t-2)*R.y(4)));
bez3_Y_diff1_plot = diff(bez3_Y_plot);
bez3_Y_diff2_plot = diff(bez3_Y_plot,2);

%curvature computation per segment for plotting
curvature2_plot = (bez2_X_diff1_plot*bez2_Y_diff2_plot-bez2_X_diff2_plot*bez2_Y_diff1_plot)/...
    ((bez2_X_diff1_plot)^2 + (bez2_Y_diff1_plot)^2)^(3/2);
curvature3_plot = (bez3_X_diff1_plot*bez3_Y_diff2_plot-bez3_X_diff2_plot*bez3_Y_diff1_plot)/...
    ((bez3_X_diff1_plot)^2 + (bez3_Y_diff1_plot)^2)^(3/2);

%scaling of symbolic curvature for plotting
%disp(scale_factor)
curvature1_plot = curvature1/scale_factor;%curvature1 can be plotted directly
curvature2_plot = curvature2_plot/scale_factor;
curvature3_plot = curvature3_plot/scale_factor;

%symbolic radius of curvature for plotting
curvature_radius1_plot = abs(1/curvature1_plot);
curvature_radius2_plot = abs(1/curvature2_plot);
curvature_radius3_plot = abs(1/curvature3_plot);

%% Computation of lengths

% Computation of total arc length of Bezier polygon
% We will compute the arc length of each of the 3 segments separetly and
% then add them together. We will use the SCALED value, naturally. 

syms t
%we are using the non-shifted curves and integrate from 0 to 1
%the length is scaled by multiplying the curve by scale factor
%t remians between 0 and 1

%lengths in um !

integrand_curve1 = scale_factor*sqrt((bez1_X_diff1)^2 + (bez1_Y_diff1)^2);
integrand_curve2 = scale_factor*sqrt((bez2_X_diff1)^2 + (bez2_Y_diff1)^2);
integrand_curve3 = scale_factor*sqrt((bez3_X_diff1)^2 + (bez3_Y_diff1)^2);

L_1 = vpa(int(integrand_curve1, [0 1]));
L_2 = vpa(int(integrand_curve2, [0 1]));
L_3 = vpa(int(integrand_curve3, [0 1]));

L_total = L_1+L_2+L_3;

% finding the t values for which the radius is larger than 15 um
% these values are found 
t_curve1 = vpasolve(curvature_radius1_plot==15,t,[0 1]);
t_curve2 = vpasolve(curvature_radius2_plot==15,t,[1 2]);
t_curve3a = vpasolve(curvature_radius3_plot==15,t, 2.2); %first sol
t_curve3b = vpasolve(curvature_radius3_plot==15,t, 2.7); %second sol

%finding the ''straight'' length, since we're using the non-shifted curves
%we need to correct the boundary values 
L_straight1 = vpa(int(integrand_curve1, [0 t_curve1]));
L_straight2 = vpa(int(integrand_curve2, [(t_curve2-1) 1]));
L_straight3 = vpa(int(integrand_curve3, [0 (t_curve3a-2)]));
L_straight4 = vpa(int(integrand_curve3, [(t_curve3b-2) 1]));

L_straight = L_straight4+L_straight3+L_straight2+L_straight1;

%finding the bend length at r=5
L_bend_5 = vpa(int(integrand_curve1, [t_curve1 1])) + ...
    vpa(int(integrand_curve2, [0 t_curve2-1]));

%finding the bend length at r=8
L_bend_8 = vpa(int(integrand_curve3, [t_curve3a-2 t_curve3b-2]));


%% Computation of losses
% we will use certain values found in literature 

prop_loss = 1.6; %[dB/cm], from Dr. Furci's research
loss_R5 = 4e-1; %[dB/90deg bend] at 5 um, from literature
loss_R8 = 7e-2; %[dB/90deg bend] at 8 um, from literature
low_loss_crossing =  0.011; %low loss crossing losses

total_loss = (L_straight/10000)*prop_loss + loss_R5*0.5 + loss_R8 + low_loss_crossing


%% Bezier function plot
%plot the symbolic bezier function
f1 = figure;
hold on;

%we didn't change the variable for bez1 so we can just use the original
fplot(scale_factor*bez1_X, scale_factor*bez1_Y, [0 1])

fplot(scale_factor*bez2_X_plot,scale_factor*bez2_Y_plot, [1 2])

fplot(scale_factor*bez3_X_plot,scale_factor*bez3_Y_plot, [2 3])

%creation of the diagonal asymptote
% syms x;
% diagonal_asymp = scale_factor*(-x + x_0);
% 
% fplot(diagonal_asymp, [0 x_0], ':k')

hold off;

%params
title('Bézier Curve')
ylabel('y')
xlabel('x')
%xline(1,':k');
grid on;


%% Curvature plot
%plot the symbolic curvature
syms t;

f2 = figure;
hold on;
%no change of variable for curvature 1, so we use the original
fplot(curvature1_plot, [0 1])

fplot(curvature2_plot, [1 2])

fplot(curvature3_plot, [2 3])
hold off;
%params
title('Curvature')
xlabel('Arc length')
ylabel('Signed curvature')
grid on;


%% Radius of curvature plot
%plot the symbolic curvature
syms t;
f3 = figure;
hold on;
fplot(curvature_radius1_plot, [0 1])

fplot(curvature_radius2_plot, [1 2])

fplot(curvature_radius3_plot, [2 3])
hold off;

%params
title('Curvature radius')
xlabel('Arc length [a.u.]')
ylabel('Radius [um]')
ylim([4 25])
grid on;


%% Creating the GDSII file
% Written by Dr. Furci, modified by C. Jaramillo on the 07.04.2021
% use of wraith toolbox to generate GDSII file

write_dir = ['C:\Users\claud\Google Drive\EPFL\2. Master\MA2 - 2021\'...
    'MICRO-498 Semester Project\Design\Exports'];

%figure();
%layer 1
LayerStruct.layers(1)=1;
%1 corresponds to the GDSII layer number
LayerStruct.widths(1)=0.6; %in um

%layer 2
LayerStruct.layers(2)=3; %adding other layers
%3 corresponds to the GDSII layer number
LayerStruct.widths(2)=1.8; %adding other layers

StructCode='BezierBottomWaveguide180_0p6';
BendLib=Raith_library('BezierCurve');

x = scale_factor*[bez_curve1_x bez_curve2_x bez_curve3_x];
y = scale_factor*[bez_curve1_y bez_curve2_y bez_curve3_y];

path = [x;y];

for e=1:numel(LayerStruct.layers)
    layer=LayerStruct.layers(e);
    width=LayerStruct.widths(e); 
    BendVector(e)=Raith_element('path',layer,path,width,layer/8*1.5);
end

StrName=[StructCode sprintf('BezierCurve')];
BendStruct=Raith_structure(StrName,BendVector);
BendLib.append(BendStruct);
BendLib.writegds(write_dir,'plain');

