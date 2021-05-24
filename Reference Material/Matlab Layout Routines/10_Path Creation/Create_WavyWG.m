function X=Create_WavyWG(L,N,r,H,extra)
Straight=(L-N*(2*r+extra))/2;
X=[0;0];
X=[X [Straight; 0]];
for i=1:N
    X=[X [X(1,end);(-1)^(i-1)*(H/2)]];
    X=[X [X(1,end)+2*r+extra;X(2,end)]];
end
X=[X [X(1,end); 0]];
X=[X [L; 0]];
end