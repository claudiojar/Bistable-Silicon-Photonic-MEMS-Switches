function curve_out=rotate_angle_CCW(curve_in,angle)
s=sin(angle);
c=cos(angle);
R=[c -s;s c];
curve_out=R*curve_in;
end 