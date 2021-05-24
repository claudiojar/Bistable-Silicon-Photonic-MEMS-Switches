function [SplRot,X,Extension,cRot,splLen]=spline_45(r,alpha,tol_rad,extra_straight,X_0,figON,half)

[SplUnrot,~,~,~,spline,c]=spline_param(r,alpha,tol_rad,figON,half);
SplRot=rot_angle_CCW(SplUnrot,1.25*pi);
cRot=rot_angle_CCW(c,1.25*pi);
if half==0.0
    %Correct for small slope
    slope=(SplRot(2,end)-SplRot(2,1))/(SplRot(1,end)-SplRot(1,1));
    SplRot(2,:)=SplRot(2,:)-slope*(SplRot(1,:)-SplRot(1,1));
    cRot(2,:)=cRot(2,1)-slope*(cRot(1,1)-SplRot(1,1));
end
zero=SplRot(:,1);
SplRot=SplRot-SplRot(:,1)+[extra_straight;extra_straight]/sqrt(2);
cRot=cRot-zero+[extra_straight;extra_straight]/sqrt(2);
SplRot=[[0;0] SplRot];
if extra_straight~=0.0 && half==0.0
    SplRot=[SplRot [SplRot(1,end)+extra_straight/sqrt(2);0]];
end
if X_0~=0.0
    SplRot(1,:)=SplRot(1,:)+X_0;
    cRot(1,:)=cRot(1,:)+X_0;
end
X=[SplRot(1,1) SplRot(1,end)];
Extension=X(2)-X(1);

splLen=path_length(spline);

end
