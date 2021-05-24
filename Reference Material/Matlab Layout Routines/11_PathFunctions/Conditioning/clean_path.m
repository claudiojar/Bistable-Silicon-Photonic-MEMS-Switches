function cleanpath=clean_path(path)

Nv=size(path,2);
N_rep=0;
iv=2;
pathnorep(1:2,1)=path(:,1);
while iv<=Nv
    if path(:,iv)==path(:,iv-1)
        N_rep=N_rep+1;
    end
    pathnorep(1:2,iv-N_rep)=path(:,iv);
    iv=iv+1;
end

Nvnorep=size(pathnorep,2);
N_par=0;
iv=2;
cleanpath(1:2,1:2)=pathnorep(:,1:2);
while iv<=Nvnorep-1
    
    e_in=pathnorep(:,iv)-pathnorep(:,iv-1);
    e_in=e_in/norm(e_in);
    e_out=pathnorep(:,iv+1)-pathnorep(:,iv);
    e_out=e_out/norm(e_out);
    
    if e_out==e_in
        N_par=N_par+1;
    end
    
    iv=iv+1;
    cleanpath(1:2,iv-N_par)=pathnorep(:,iv);

end

%cleanpath=pathnorep;

end
