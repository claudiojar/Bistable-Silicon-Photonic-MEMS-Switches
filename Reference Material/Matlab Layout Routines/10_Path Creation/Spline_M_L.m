clear all
close all

MoverL=0.0;%0.442

% t=0:0.0001:1.0;
% s=1.0-t;
% B=[t.*t.*t + 3.*t.*t.*s.*MoverL; s.*s.*s + 3.*s.*s.*t.* MoverL];

figure;
plot([0 2],[0 2]);
hold on
axis equal
for t_alpha=[0.001 0.002 0.005 0.01 0.02:0.02:0.5]
B_alpha=[t_alpha^3 + 3*t_alpha^2*(1-t_alpha)*MoverL; (1-t_alpha)^3 + 3*(1-t_alpha)^2*t_alpha*MoverL];
Bprime_alpha=[3*t_alpha^2 + (6*t_alpha*(1-t_alpha)-3*t_alpha^2)*MoverL;-3*(1-t_alpha)^2 - (6*(1-t_alpha)*t_alpha-3*(1-t_alpha)^2)* MoverL];
Bprime_alpha=[3*t_alpha^2 + (6*t_alpha-9*t_alpha^2)*MoverL;-3*(1-t_alpha)^2+(-6*(1-t_alpha)+9*(1-t_alpha)^2)* MoverL];
Bsecond_alpha=[6*t_alpha+MoverL*(6-18*t_alpha); 6*(1-t_alpha)+ MoverL*(6-18*(1-t_alpha))];

R_alpha=norm(Bprime_alpha)^3/(Bprime_alpha(1)*Bsecond_alpha(2)-Bprime_alpha(2)*Bsecond_alpha(1));
R_vec_alpha=R_alpha*rot_90_CCW(Bprime_alpha)/norm(Bprime_alpha);
C_alpha=B_alpha+R_vec_alpha;

scatter(C_alpha(1),C_alpha(2),'r');
hold on
scatter(B_alpha(1),B_alpha(2),'b');
axis equal
end


