function [Output_PathElements]=convert_OrtogonalPath_2_GDSRoundedPathElements(RightAnglePath,PathLayerStruct,RoundingRadius,ArcNSeg)

[rpathstr,rpath]=round_edges_orthogonal_path(RightAnglePath,RoundingRadius,ArcNSeg);
%create the elements
for e=1:numel(PathLayerStruct.layers)
    layer=PathLayerStruct.layers(e);
    width=PathLayerStruct.widths(e);
    %Create the straight paths
    for s=1:numel(rpathstr.straight_path)
        path=rpathstr.straight_path(s).Coord;
        Output_PathElements(e).Segments(s)=Raith_element('path',layer,path,width,layer/8*1.5);
    end
    %Create the arcs
    for i_arc=1:size(rpathstr.arc_center,2)
        uv_c=rpathstr.arc_center(:,i_arc)';
        theta=rpathstr.arc_angle(:,i_arc)'*180/pi;
        Output_PathElements(e).Arcs(i_arc)=Raith_element('arc',layer,uv_c,RoundingRadius,theta,0.0,width,ArcNSeg,layer/8*1.5);
    end
    Output_PathElements(e).SinglePath=Raith_element('path',layer,rpath,width,layer/8*1.5);
end

end
