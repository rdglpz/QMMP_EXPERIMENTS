function [ a ] = normalizeWDD( a )
%normalize data from 0 to 1
    range = max(a) - min(a);
    a = (a - min(a)) / range;
end

