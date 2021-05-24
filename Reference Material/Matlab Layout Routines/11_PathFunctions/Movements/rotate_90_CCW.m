function curve_out=rotate_90_CCW(curve_in)
curve_out(1,:)=-curve_in(2,:);
curve_out(2,:)=curve_in(1,:);
end 