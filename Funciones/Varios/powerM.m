function [v1 lambda k] = powerM(A)
s = size(A,1);
v = randn(s,1);
v = v/norm(v);
flag = 1;
k = 0;
while flag
    v1 = A*v;
    lambda = norm(v1);
    v1 = v1 / lambda;
    k = k+1; 
    dif = norm(v-v1);
    if dif < 0.0001
        flag = 0;
    else
        v = v1;
    end
end