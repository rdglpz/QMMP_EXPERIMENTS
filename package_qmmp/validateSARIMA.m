function [passed, offlinePrediction] = validateSARIMA(qn,training,model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    nForecast =2;
    [EstMdl,EstParamCov] = estimate(model,qn');
    h=1;
    errPredCons = [];
    Y=qn;
    for i = 50:length(Y)*training-2
        % display(floor(length(TS)*0.8-i));
        [YY,YMSE] = forecast(EstMdl,1,'Y0',Y(i-49:i)');
        errPredCons=[errPredCons YY(1)-Y(i+1)];
    end
    passed = lbqtest(errPredCons);
  %  parcorr(errPredCons)
    N = length(qn);
    start=floor(N*training)+1;
  %  finish = floor(N*training)+floor(N*validation)+1;
  
    offlinePrediction= zeros(2,length(Y)-nForecast-start);
    for i= start:length(Y)-nForecast
        [YY,YMSE] = forecast(EstMdl,2,'Y0',Y(i-49:i)');
        offlinePrediction(1,i-start+1) = YY(1);
        offlinePrediction(2,i-start+1) = YY(2);  
    end


end

