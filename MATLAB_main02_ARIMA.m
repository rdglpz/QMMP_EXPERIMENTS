clear all;

addpath('package_qmmp/');

FILE{1}.F =  'demands2012/p10007.txt';
FILE{2}.F =  'demands2012/p10015.txt';
FILE{3}.F =  'demands2012/p10017.txt';
FILE{4}.F =  'demands2012/p10026.txt';
FILE{5}.F =  'demands2012/p10095.txt';
FILE{6}.F =  'demands2012/p10109.txt';
FILE{7}.F =  'demands2012/p10025.txt';

FILE{1}.M = arima('D',1, 'MALags',[1] ,'SMALags',[],'ARLags',[1]);
FILE{2}.M = arima('D',1, 'MALags',[1] ,'SMALags',[],'ARLags',[1]);
FILE{3}.M = arima('D',0, 'MALags',[1 2] ,'SMALags',[],'ARLags',[1 2]);
FILE{4}.M = arima('D',1, 'MALags',[1 2 3 4],'SMALags',[],'ARLags',[1 2]);
FILE{5}.M = arima('D',1, 'MALags',[],'SMALags',[],'ARLags',[1 2]);
FILE{6}.M = arima('D',1, 'MALags',[1 2 3 4 5],'SMALags',[],'ARLags',[1 2 3 4]);
%FILE{6}.M = arima('D',1, 'MA',{-0.4081,  -0.5666,  -0.8692,  0.5631,  0.3246} ,'SMALags',[],'AR',{0.6533,  0.1670,  0.6415,  -0.7236});
FILE{7}.M = arima('D',1, 'MALAGS',[1 2] ,'SMALags',[],'ARLAGS',[1]);
%FILE{7}.M = arima('D',1, 'MA',{0.0097,  0.0047} ,'SMALags',[],'AR',{0.0157,  -0.6745,  0.5177});



TSPercentage = 0.7;
h =24;
tau =24;

tsn = length(FILE);
for fix = 1:tsn
    residuals = [];
    E = [];
    fileName = FILE{fix}.F;
    TS = normalizeWDD(readTS(fileName));
    lastTRData = floor(length(TS)*TSPercentage);
    [EstMdl,EstParamCov] = estimate(FILE{fix}.M, TS(1:lastTRData));
    for d = lastTRData: (length(TS)-h)
%        sprintf( '%d / %d ', d,(N-h) )
        y=TS(d+1:d+h);
        [yHat,YMSE] = forecast(EstMdl,h,'Y0',TS(d-55:d));
        E = [E errors(yHat,y)];
        residuals = [residuals y-yHat];
    end
    FILE{fix}.err=mean(E')';
    FILE{fix}.res= residuals;

end

fprintf("-----ARIMA Results-----\n");
metric = ["MAE", "RMSE", "MAPE"];
for errorMetric = 1:length(metric)
    fprintf('\n %s \n',metric(errorMetric));
    fprintf("Sector \t \t \t \t \t # \t  ARIMA \n");
    for i=1:tsn
        sctr = FILE{i}.F;
        er = FILE{i}.err(errorMetric);
        fprintf('%s \t %d \t %f \t \n',sctr,i,er);
    end
end

fprintf("\n Variance \n")
fprintf("Sector \t \t \t \t \t # \t ARIMA \n")
for i=1:tsn
    sctr = FILE{i}.F;
    e1 = var(FILE{i}.res(:));
    fprintf('%s \t %d \t %f \n',sctr,i,e1);
end



