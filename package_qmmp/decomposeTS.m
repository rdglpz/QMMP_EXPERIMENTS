function [ ql , qn] = decomposeTS( TS, tau)
%learnPatterns Learns unitary patterns of the time series using k means
    dailyPatterns = reshapeArray(TS,tau)';
    qn = sum(dailyPatterns);
    ql =zeros(tau,floor(length(TS)/tau ));
    for i=1:size(dailyPatterns,2)
        ql(:,i) = (dailyPatterns(:,i)'/qn(i));
    end
end

