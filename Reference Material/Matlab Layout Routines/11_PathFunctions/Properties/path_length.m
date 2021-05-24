function length=path_length(path)
length=0;
for i=2:size(path,2)
    length=length+norm(path(:,i)-path(:,i-1));
end
end