function [Output,length,t_alpha,L,B,c,N_circ_in,N_circ_out]=spline_param(r,alpha,tol_rad,figON,half)

%r: min radius
%alpha: angle turned in spline
%tol_rad, used to calculate the size of segmentation in the circular section
%figON: display figure of the generated bend
%half: only generate 45deg of the spline bend.
N_circ_in=0.0;
N_circ_out=0.0;

sqrtta=sqrt(tan(alpha));
t_alpha=sqrtta/(1+sqrtta); %calculation of the parameter at which the spline reaches the angle/slope.
s_alpha=1.0-t_alpha;
root1=sqrt(t_alpha*t_alpha*t_alpha*t_alpha+s_alpha*s_alpha*s_alpha*s_alpha);
L=(2/3*r*t_alpha*s_alpha)/(root1)^3; %calculation of the spline L parameter that gives the right matching radius at t_alpha

N_arcpart=ceil((pi/2)/2*sqrt(r/(2*tol_rad))); 
ds_arc=(pi/2)*r/N_arcpart;  %Calculate the size of hypothetical arc straight elements that is optimal 
B1_alpha_mod=3*L*root1; %spline speed at the t_alpha point
dt_recommend=ds_arc/B1_alpha_mod; %dt = arc_element/speed.
N_spline=ceil(t_alpha/dt_recommend); %number of spline segments

N_arcpart=max([ceil((pi/2-2*alpha)/2*sqrt(r/(2*tol_rad))) 1]); %number of elements in the arc actual part

t_vec=0:t_alpha/N_spline:t_alpha;
if t_vec(end)~=t_alpha
    t_vec=[t_vec t_alpha];
end
B=L*[(1.0-t_vec).^3;t_vec.^3];
% B1=3*L*[-(1-t_vec).^2;t_vec.^2];
% B1alpha=[-(1-t)^2;t^2];
% B2=6*L*[(1-t_vec);t_vec];
% B1mod=sqrt(B1(1,:).^2+B1(2,:).^2);
% B2mod=sqrt(B2(1,:).^2+B2(2,:).^2);
% b1=[B1(1,:)./B1mod;B1(2,:)./B1mod];
% b2=[B2(1,:)./B2mod;B2(2,:)./B2mod];
% cosB=(diag(b1'*b2))';
% B2_perp=B2mod.*sqrt(1-cosB.^2);
% rad=B1mod.^2./B2_perp;
% Curv=1./rad;
% 
%figure; plot(B(1,:),B(2,:));
% hold on 

P_a=[L*s_alpha^3;L*t_alpha^3];
% P_b=P_a+B1alpha;
% scatter(L*s^3,L*t^3,'r');
% plot([P_a(1) P_b(1)],[P_a(2) P_b(2)],'r');
% scatter(L*t^3,L*s^3,'g');

c=P_a+r*[sin(alpha);cos(alpha)];
% scatter(c(1,1),c(2,1),'k');

if half==0.0
    circular_part=convert_Arc_2_Path(c,[-pi/2-alpha -pi+alpha],r,N_arcpart);
    % plot(circular_part(1,:),circular_part(2,:),'k');
    % axis equal
    % figure; plot(t_vec,rad);
    
    Output=B(:,1:end-1); %Store B in output withouth the last point
    if isempty(circular_part)
        N_circ_in=size(B,2);
        N_circ_out=N_circ_in;
        Output=[Output fliplr(flipud(B))]; %#ok<FLUDLR>
    else
        H=fliplr(flipud(B-B(:,end)))+circular_part(:,end); %#ok<FLUDLR>
        %take the spline WITH last point, refer it to its ending, exchange x and y coordinates
        %(mirror on y=x), change points order, and translate so that the connection
        %point matches the end of the arc
        N_circ_in=size(B,2);
        N_circ_out=N_circ_in+size(circular_part,2);
        Output=[Output circular_part H(:,2:end)];  %concatenate H without repeting its first point.
        %Output(1,end) should be equal to c(1,1)-c(2,1)
        %i.e. that leftmost x value of the curve is equal to C_x-C_y,
        %because the curve is laying on the horizontal axis exactly:
        %Output(2,1)==0 by construction
        if figON==1
            figure;
            plot(B(1,:)-Output(1,end),B(2,:),'r');
            hold on
            plot(circular_part(1,:)-Output(1,end),circular_part(2,:),'k');
            plot(H(1,:)-Output(1,end),H(2,:),'r');
            scatter(c(1,1)-Output(1,end),c(2,1),'k');
            scatter(circular_part(1,1)-Output(1,end),circular_part(2,1),'k');
            scatter(circular_part(1,end)-Output(1,end),circular_part(2,end),'k');
            axis equal
            axis square
        end
        Output=Output-[Output(1,end);0];
    end
else
    circular_part=convert_Arc_2_Path(c,[-pi/2-alpha -pi*0.75],r,N_arcpart/2);
    if isempty(circular_part)
        Output=B; 
        N_circ_in=size(Output,2);
        N_circ_out=N_circ_in;
    else
        Output=B(:,1:end-1); %Store B in output withouth the last point
        N_circ_in=size(B,2);
        N_circ_out=N_circ_in+size(circular_part,2)-1;
        Output=[Output circular_part];  %concatenate H without repeting its first point.
        % the curve is laying on the horizontal axis exactly:
        %Output(2,1)==0 by construction
        % but the center of the circle should be on the perfect diagonal
        % x==y, so we shift it:
        if figON==1
            figure;
            plot(B(1,:)-(c(1,1)-c(2,1)),B(2,:),'r');
            hold on
            plot(circular_part(1,:)-(c(1,1)-c(2,1)),circular_part(2,:),'k');
            scatter(c(1,1)-(c(1,1)-c(2,1)),c(2,1),'k');
            scatter(circular_part(1,1)-(c(1,1)-c(2,1)),circular_part(2,1),'k');
            scatter(circular_part(1,end)-(c(1,1)-c(2,1)),circular_part(2,end),'k');
            axis equal
            axis square
        end
        Output=Output-[(c(1,1)-c(2,1));0];
    end
end
c=[c(2,1);c(2,1)];
%figure; plot(Output(1,:),Output(2,:));
%axis equal

length=path_length(Output);

%curvature of the resulting path
%[s2_coord,Output_2s_mod]=CurvStudy(Output);

% Output_diff=Output(:,2:end)-Output(:,1:end-1); %vector point to point: T precursor
% Output_1s_centers=(Output(:,2:end)+Output(:,1:end-1))/2; %centers of the T vectors
% Output_diff_mod=sqrt(Output_diff(1,:).^2+Output_diff(2,:).^2); %size of displacements
% Output_1s=Output_diff(1,:)./Output_diff_mod; %unitary direction vectors T
% Output_1s(2,:)=Output_diff(2,:)./Output_diff_mod; %unitary direction vectors T
% Output_1s_diff=Output_1s(:,2:end)-Output_1s(:,1:end-1); %change in unitary T vectors: N precursor
% Output_2s_centers=(Output_1s_centers(:,2:end)+Output_1s_centers(:,1:end-1))/2; %centers for the normal vectors
% Output_1s_diff_dsvec=Output_1s_centers(:,2:end)-Output_1s_centers(:,1:end-1); %vectorial diplacement between T vectors
% Output_1s_diff_ds=sqrt(Output_1s_diff_dsvec(1,:).^2+Output_1s_diff_dsvec(2,:).^2); %scalar diplacement between tangential vectors
% Output_2s=Output_1s_diff(1,:)./Output_1s_diff_ds; %derivative of unitary T vectors: N
% Output_2s(2,:)=Output_1s_diff(2,:)./Output_1s_diff_ds; %derivative of unitary T vectors: N
% Output_2s_mod=sqrt(Output_2s(1,:).^2+Output_2s(2,:).^2); %mod(N)
% figure; plot3(Output_2s_centers(1,:),Output_2s_centers(2,:),Output_2s_mod);
% for i=1:size(Output_2s_centers,2)
%     s2_coord(i)=trapz(Output_1s_diff_ds(1:i));
% end
% figure; plot(s2_coord,Output_2s_mod);

% t_vec=0:t_alpha/N_spline:1.0;
% if t_vec(end)~=1.0
%     t_vec=[t_vec 1.0];
% end
% B=L*[(1.0-t_vec).^3;t_vec.^3];

end