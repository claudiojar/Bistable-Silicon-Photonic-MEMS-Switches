function fi=phi_45spl(r,d,spl_ang,tol_rad)
    [~,~,~,c,~]=spline_45(r,spl_ang,tol_rad,d,0.0,0.0,0.0);
   	fi=c(2,1)./r+1; %fraction of the curvature radius that is above the horizontal axis at the gluing point
end
