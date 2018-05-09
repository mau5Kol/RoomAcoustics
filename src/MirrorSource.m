function result = MirrorSource(src, wall)
%{
Input:
    src: point (1*2 float)
    wall: wall (1*4 float)
Output:
    result: mirror point (1*2 float)
%}

    wall_start = wall(1,1:2);
    wall_end = wall(1,3:4);
    wall_line = [wall_end(1) - wall_start(1), wall_end(2) - wall_start(2)];
    % get the normal
    normal = [wall_line(2), -wall_line(1)];
    % get the portion starting from the src point
    t = GetPortion(src, wall_start, wall_end, normal);
    
    t = t * 2;
    % t times 2 to get the image source
    imageSource_x = src(1) + t * normal(1);
    imageSource_y = src(2) + t * normal(2);
    
    result = [imageSource_x, imageSource_y];

end

function t = GetPortion(src, start, stop, normal)
    nominator = ((src(1) - start(1)) * (stop(2) - start(2))) - ((src(2) - start(2)) * (stop(1) - start(1)));
    denom = (normal(2) * (stop(1) - start(1))) - (normal(1) * (stop(2) - start(2)));
    t = nominator / denom;
end