function [fullpath,ArcsSegs]=Create_WavyWG45(L,N,r,d)

OptPathArcNSegments=round(pi*0.25*sqrt(r/0.01));

X=[0;r+d];
for i=2:N/2
    if mod(i,2)==1 %if odd
        X=[X [X(1,end);X(2,end)+2*(r+d)]];
    else %if even
        X=[X [X(1,end)+2*(r+d);X(2,end)]];
    end
end
if mod(i+1,2)==1
    X=[X [X(1,end);X(2,end)+(r+d)]];
else
    X=[X [X(1,end)+(r+d);X(2,end)]];
end

Xfull=[-fliplr(X) X];

[ArcsSegs,fullpath]=round_edges_orthogonal_path(Xfull,r,OptPathArcNSegments);

fullpath=rot_angle_CCW(fullpath,-pi/4);

%eliminate half an arc on each side:
i=1;
while abs(fullpath(2,i))<abs(fullpath(2,i+1))
    i=i+1;
end
fullpath=fullpath(:,i:end-(i-1));

phi=@(r,d)(d-r)./r/sqrt(2)+1;
a=@(phi) 1/192./phi;
b=@(phi) a(phi)/36./phi;
x_star_fun=@(phi) sqrt(2*a(phi)./(3*b(phi)));
glue_poly=@(x,phi) a(phi).*x.^4 - b(phi).*x.^6;

x_polyleft=fullpath(1,1)-r*x_star_fun(phi(r,d)):pi/2*r/OptPathArcNSegments:fullpath(1,1);
x_polyright=-fliplr(x_polyleft);
if fullpath(2,1)>0
    y_polyleft=r*glue_poly((x_polyleft-x_polyleft(1))/r,phi(r,d));
else
    y_polyleft=-r*glue_poly((x_polyleft-x_polyleft(1))/r,phi(r,d));
end
y_polyright=-fliplr(y_polyleft);

fullpath=[ [-L/2;0] [x_polyleft;y_polyleft] fullpath [x_polyright;y_polyright] [L/2;0]];

end