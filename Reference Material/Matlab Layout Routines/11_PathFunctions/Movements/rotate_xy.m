function rot_v=rotate_xy(v)

%rotates CCW a vector, 90 deg

rot_v(2,1)=v(1,1);
rot_v(1,1)=-v(2,1);

end