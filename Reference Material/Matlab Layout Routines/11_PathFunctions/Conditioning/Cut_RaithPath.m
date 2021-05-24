function RaithPathVec=Cut_RaithPath(RaithPath,cut_N)

N=ceil(size(RaithPath.data.uv,2)/cut_N);
path=RaithPath.data.uv;
if N==1
    RaithPathVec=[RaithPath];
else
    for i=1:N
        pathaux=path(:,(i-1)*cut_N+1:end);
        if size(pathaux,2)>cut_N
            pathelem=pathaux(:,1:cut_N);
        else
            pathelem=pathaux;
        end
        if i>1
            pathelem=[(3*path(:,(i-1)*cut_N)+path(:,(i-1)*cut_N+1))/4 pathelem];
        end
        if i<N
            pathelem=[pathelem (   path(:,i*cut_N) + 3* path(:,i*cut_N+1)  )/4 ];
        end
        RaithPathVec(i)=Raith_element('path',RaithPath.data.layer,pathelem,RaithPath.data.w,RaithPath.data.DF);
    end
end

end