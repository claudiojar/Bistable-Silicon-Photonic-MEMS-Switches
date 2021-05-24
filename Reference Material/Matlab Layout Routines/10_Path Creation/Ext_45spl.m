function E=Ext_45spl(r,d,spl_ang,tol_rad)
    [~,~,E,~,~]=spline_45(r,spl_ang,tol_rad,d,0.0,0.0,0.0);
end