function [ prediction] = predictionkNN( currentVector,i,o,epsilon )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    n=size(i,2);
    ni = size(i,1);
    distances = sum(repmat(currentVector,1,n)~=i)/ni;
    ix=find(distances<epsilon);
    if length(ix)==0
        [v,ix]=min(distances);
        ix = [ix ix];
    end
    if length(ix)==1
        ix = [ix ix];
    end
    prediction = mode(o(:,ix)');
end

