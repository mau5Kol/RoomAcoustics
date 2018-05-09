function [isIntersect, pos] = Intersect(R, T, P, Q)
%{
Input:
    R, T: first segment begin and end;
    P, Q: second segment begin and end;
Output:
    isIntersect: 0 is no, 1 is yes;
    pos: if intersect, the position; else, 0, 0;
%}

    % P-Q as wall
    wall = [Q(1) - P(1), Q(2) - P(2)];
    % T-R as line
    line = [R(1) - T(1), R(2) - T(2)];
    
    % find the t of the intersection point
    t = FindPoint(wall, line, T, P);
    
    % find the intersection point
    pos_x = T(1) + t * (R(1) - T(1));
    pos_y = T(2) + t * (R(2) - T(2));
    pos = [pos_x, pos_y];
    
    % get the ratio of the intersection point and the end point
    t1 = (pos(2) - P(2)) / (Q(2) - P(2));

    t2 = (pos(1) - P(1)) / (Q(1) - P(1));
    
    
    if (t >= 0 && t <= 1) && ((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1))
        isIntersect = 1;
    else 
        isIntersect = 0;
        pos = [0, 0];
    end
    

end

function t = FindPoint(wall, line, T, P)
    line_x = line(1);
    line_y = line(2);
    wall_x = wall(1);
    wall_y = wall(2);
    
    nominator = (wall_y * (T(1) - P(1))) - ((T(2) - P(2)) * wall_x);
    denom = line_y * wall_x - line_x * wall_y;
    
    t = nominator / denom;
end