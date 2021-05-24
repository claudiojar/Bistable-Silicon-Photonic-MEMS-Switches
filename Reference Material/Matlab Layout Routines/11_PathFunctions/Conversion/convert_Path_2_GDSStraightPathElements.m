function Output_PathElements=convert_Path_2_GDSStraightPathElements(StraightLinePath,PathLayerStruct)

for e=1:numel(PathLayerStruct.layers)
    
    if PathLayerStruct.offset(e)==0.0
        path=StraightLinePath;
    else
        path=offset_path(StraightLinePath,PathLayerStruct.offset(e));
    end
    layer=PathLayerStruct.layers(e);
    width=PathLayerStruct.widths(e);
    
    Output_PathElements(e)=Raith_element('path',layer,path,width,layer/8*1.5);
end

end