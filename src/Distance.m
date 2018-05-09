function result = Distance(P, Q)
%{
Input:
    P, Q: the position of the two points
Output:
    result: distance between them
%}

    x = abs(Q(1) - P(1));
    y = abs(Q(2) - P(2));
    
    result = sqrt(y ^ 2 + x ^ 2);

end