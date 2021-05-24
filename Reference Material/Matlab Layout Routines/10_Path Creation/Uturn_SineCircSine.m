function path_rot=Uturn_SineCircSine(r,tol_rad,origin,or_pos)

N=ceil(pi/4*sqrt(r/(2*tol_rad)))+1; %This formula is for a tolerance of tol_rad and for a circular arc of angle pi/2
x_sine=linspace(-pi/2,0,N);
y_sine=cos(x_sine);
Theta_Circle=linspace(pi/2,0,N);
x=[x_sine*r r*cos(Theta_Circle(2:end-1)) fliplr(y_sine)*r];
y=[y_sine*r r*sin(Theta_Circle(2:end-1)) fliplr(x_sine)*r];
path=[x;y];
path_rot=rotate_angle_CCW(path,pi/4);
if or_pos=='i'
    path_rot=path_rot-path_rot(:,1)+origin;
elseif or_pos=='o'
    path_rot=path_rot-path_rot(:,end)+origin;
end

end

