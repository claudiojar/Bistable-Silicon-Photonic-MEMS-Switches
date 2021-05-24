function [s2_coord,path_2s_mod,DCDs_coord,DCurvDs]=CurvStudy(path)

path_diff=path(:,2:end)-path(:,1:end-1); %vector point to point: T precursor
path_1s_centers=(path(:,2:end)+path(:,1:end-1))/2; %centers of the T vectors
path_diff_mod=sqrt(path_diff(1,:).^2+path_diff(2,:).^2); %size of displacements
path_1s=path_diff(1,:)./path_diff_mod; %unitary direction vectors T
path_1s(2,:)=path_diff(2,:)./path_diff_mod; %unitary direction vectors T
path_1s_diff=path_1s(:,2:end)-path_1s(:,1:end-1); %change in unitary T vectors: N precursor
path_2s_centers=(path_1s_centers(:,2:end)+path_1s_centers(:,1:end-1))/2; %centers for the normal vectors
path_1s_diff_dsvec=path_1s_centers(:,2:end)-path_1s_centers(:,1:end-1); %vectorial diplacement between T vectors
path_1s_diff_ds=sqrt(path_1s_diff_dsvec(1,:).^2+path_1s_diff_dsvec(2,:).^2); %scalar diplacement between tangential vectors
path_2s=path_1s_diff(1,:)./path_1s_diff_ds; %derivative of unitary T vectors: N
path_2s(2,:)=path_1s_diff(2,:)./path_1s_diff_ds; %derivative of unitary T vectors: N
path_2s_mod=sqrt(path_2s(1,:).^2+path_2s(2,:).^2); %mod(N)
figure; plot3(path_2s_centers(1,:),path_2s_centers(2,:),path_2s_mod);
for i=1:size(path_2s_centers,2)
    s2_coord(i)=trapz(path_1s_diff_ds(1:i));
end
figure; plot(s2_coord,path_2s_mod);

DCurvDs=diff(path_2s_mod)./diff(s2_coord);
DCDs_coord=s2_coord(1:end-1)+diff(s2_coord)/2;
figure; plot(DCDs_coord,DCurvDs);