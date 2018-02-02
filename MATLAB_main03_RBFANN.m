clear all;

addpath('package_qmmp/');


FILE{1}.F =  'demands2012/p10007.txt';
FILE{2}.F =  'demands2012/p10015.txt';
FILE{3}.F =  'demands2012/p10017.txt';
FILE{4}.F =  'demands2012/p10026.txt';
FILE{5}.F =  'demands2012/p10095.txt';
FILE{6}.F =  'demands2012/p10109.txt';
FILE{7}.F =  'demands2012/p10025.txt';


nts=length(FILE);
for i = 1:nts
    FILE{i}.m = 24;
    FILE{i}.tau = 1;
end


TSPercentage = 0.7;
h=24;
N=92;


for fix = 1:nts
    residuals = [];
    E = [];
    m=FILE{fix}.m;
    tau=FILE{fix}.tau;
    fileName = strcat(FILE{fix}.F);
    TS=normalizeWDD(readTS(fileName));
    [i , o] = formatTS( TS,m,tau,h);
    iTr = 1:floor(length(i)*TSPercentage);
    oTr = 1:floor(length(o)*TSPercentage);
    netS = newrb(i(:,iTr),o(:,iTr),0,1,N);
    for ix=floor(length(i)*TSPercentage)+1: length(i)
        ip = i(:,ix);
        yHat = netS(ip);
        y = o(:,ix);   
        E = [E errors(yHat,y)];
        residuals = [residuals y-yHat];
    end
    FILE{fix}.err=mean(E')';
    FILE{fix}.res= residuals;
end


fprintf("-----Results-----\n");
metric = ["MAE", "RMSE", "MAPE"];
for errorMetric = 1:length(metric)
    fprintf('\n %s \n',metric(errorMetric));
    fprintf("Sector \t \t \t \t \t # \t  ANN \n")
    for i=1:nts
        sctr = FILE{i}.F;
        e1 = FILE{i}.err(errorMetric);
        fprintf('%s \t %d \t %f \t \n',sctr,i,e1);
    end
end


fprintf("\n Variance \n")
fprintf("Sector \t \t \t \t \t # \t ANN \n")
for i=1:nts
    sctr = FILE{i}.F;
    e1 = var(FILE{i}.res(:));
    fprintf('%s \t %d \t %f \n',sctr,i,e1);
end












