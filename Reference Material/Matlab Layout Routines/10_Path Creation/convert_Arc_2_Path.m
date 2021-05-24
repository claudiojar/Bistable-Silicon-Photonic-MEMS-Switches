function arc_path=convert_Arc_2_Path(arc_center,arc_angle,radius,NSegments)

% arc_center is given as a column vector;
% arc_angle is defined as a vector of initial and final angle, 
% such that initial < final
% NSegments is the number of segments into which the arc is decomposed

circ=@(r,theta,c) [r*cos(theta);r*sin(theta)]+c;
% theta has to be provided as a row vector;
% then angle_vec is calculated as a row vector
angle_vec=arc_angle(1):(arc_angle(2)-arc_angle(1))/NSegments:arc_angle(2);
if angle_vec(end)~=arc_angle(2)
    angle_vec=[angle_vec arc_angle(2)];
end
arc_path=circ(radius,angle_vec,arc_center);

end