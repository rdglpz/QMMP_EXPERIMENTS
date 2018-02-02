function [k,dist] = nearestPattern(MW,lagV,hourOfTheDay)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    global ov;
    global ds;
    K=size(MW,1);
    tMag = sum(lagV);
    daySample = lagV/tMag;
    ds = daySample;
    observedVals = daySample(end-hourOfTheDay+1:end);
    nbDist = (MW(:,1:hourOfTheDay)'-repmat(observedVals,1,K)).^2;
    ov = observedVals;
   % ds = daySample;
    if hourOfTheDay==1
        [a,b]=min(nbDist);
    else
        [a,b]=min(sum(nbDist));
    end
   
    dist = a;
     k = b;
    
    
end

