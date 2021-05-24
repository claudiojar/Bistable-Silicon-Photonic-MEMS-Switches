function fullpath=Create_WavyWG_45spl(L,N,r,d,spl_ang,tol_rad)

OptPathArcNSegments=round(pi*0.25*sqrt(r/2/tol_rad));

fulpath=[];
for i=1:N
    if i==1
        [Spl,X_lim,Ext,c,splLen]=spline_45(r,spl_ang,tol_rad,d,0.0,0.0,1.0);
        Spl=fliplr(Spl);
        Spl(1,:)=-Spl(1,:);
        fullpath=Spl;
    elseif i==N
        [Spl,X_lim,Ext,c,splLen]=spline_45(r,spl_ang,tol_rad,d,X_0,0.0,1.0);
        if mod(i,2)==0
            Spl(2,:)=-Spl(2,:);
        end
        fullpath=[fullpath Spl(:,2:end)];
    else
        [Spl,X_lim,Ext,c,splLen]=spline_45(r,spl_ang,tol_rad,d,X_0,0.0,0.0);
        if mod(i,2)==0
            Spl(2,:)=-Spl(2,:);
        end
        fullpath=[fullpath Spl(:,2:end)];
    end
    X_0=fullpath(1,end);
end

phi=@(r,d)(d-r)./r/sqrt(2)+1;
phi=@(r,d) phi_45spl(r,d,spl_ang,tol_rad);
a=@(phi) 1/192./phi;
b=@(phi) a(phi)/36./phi;
x_star_fun=@(phi) sqrt(2*a(phi)./(3*b(phi)));
glue_poly=@(x,phi) a(phi).*x.^4 - b(phi).*x.^6;

x_polyleft=fullpath(1,1)-r*x_star_fun(phi(r,d)):pi/2*r/OptPathArcNSegments:fullpath(1,1);
x_polyright=fullpath(1,end)+r*x_star_fun(phi(r,d)):-pi/2*r/OptPathArcNSegments:fullpath(1,end);
x_polyright=fliplr(x_polyright);

y_polyleft=r*glue_poly((x_polyleft-x_polyleft(1))/r,phi(r,d));
if fullpath(2,end)>0
    y_polyright=fliplr(y_polyleft);
else
    y_polyright=-fliplr(y_polyleft);
end

fullpath=[  [x_polyleft;y_polyleft] fullpath [x_polyright;y_polyright] ];
xmin=fullpath(1,1);
xmax=fullpath(1,end);
xmed=(xmin+xmax)/2;
fullpath(1,:)=fullpath(1,:)-xmed;
fullpath=[ [-L/2;0] fullpath [L/2;0]];


end