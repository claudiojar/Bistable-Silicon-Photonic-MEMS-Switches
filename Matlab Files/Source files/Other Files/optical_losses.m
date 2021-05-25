%% EPFL - Q-Lab Research Project: Bistable Silicon Photonic MEMS Switches
% Computation of optical losses
%
% Author: C. JARAMILLO
% MT - Master
% email: claudio.jaramilloconcha@epfl.ch
% 24 May 2021

clear variables;
close all;


%% Parameters 

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

clear i;

%% Bézier BWG losses

% Because of the lack of data, the losses for the Bezier BWG are computed
% in "/Z_Bezier_BottomWaveguide.m"


%% Linear Coupler BWG losses
% Lengths in um
% We approximate the sine-circ-sine bends to a circle, and we don't take
% into account the losses from mode matching

% for BWG
Len.linearBWG.straight = 11.457+32.320+9.651+12.351; %from the 2D model

total_loss.linear.BWG = ...
    param.loss.R5*param.scale_factor.angle_90+... %bent section at R=5 um
    param.loss.R8*param.scale_factor.angle_135+... %bent section at R=8 um
    param.loss.R15*param.scale_factor.angle_45+... %bent section at R=15 um
    (Len.linearBWG.straight/10000)*param.prop_loss+... %straight section
    param.low_loss_crossing; %LLC contribution

% for the coupler
Len.linearCoupler.straight = 104.467;

total_loss.linear.coupler = ...
    (Len.linearCoupler.straight/10000)*param.prop_loss;%straight section

disp(total_loss.linear.BWG);
disp(total_loss.linear.coupler);

%% U-Turn Coupler
% Lengths in um
% We approximate the sine-circ-sine bends to a circle, and we don't take
% into account the losses from mode matching

% for the BWG
Len.uturnBWG.straight = 9.283+2*38.570+2*5; %from the 2D model

total_loss.uturn.BWG = ...
    ... bent sections at 5 um, 3 at 90deg and 1 at 180 deg
    param.loss.R5*...
    (3*param.scale_factor.angle_90+param.scale_factor.angle_180)+... 
    param.loss.R10*param.scale_factor.angle_90+... %bent section at R=10 um
    (Len.uturnBWG.straight/10000)*param.prop_loss+... %straight section
    param.low_loss_crossing; %LLC contribution


% for the coupler
Len.uturnCoupler.straight = 60;

total_loss.uturn.coupler=(Len.uturnCoupler.straight/10000)*param.prop_loss+...
    param.loss.R5*param.scale_factor.angle_180;


disp(total_loss.uturn.BWG);
disp(total_loss.uturn.coupler);
