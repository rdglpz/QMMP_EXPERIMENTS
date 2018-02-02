clear all;

addpath('package_qmmp/');

FILE{1}.F =  'demands2012/p10007.txt';
FILE{2}.F =  'demands2012/p10015.txt';
FILE{3}.F =  'demands2012/p10017.txt';
FILE{4}.F =  'demands2012/p10026.txt';
FILE{5}.F =  'demands2012/p10095.txt';
FILE{6}.F =  'demands2012/p10109.txt';
FILE{7}.F =  'demands2012/p10025.txt';

FILE{1}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[1 2 3 19]);
FILE{2}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[2 4]);
FILE{3}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[2 4]);
FILE{4}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[2 4]);
FILE{5}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[2 4]);
FILE{6}.M = arima('D',1, 'MALags',[1] ,'Seasonality',7,'SMALags',[7],'ARLags',[2 4]);
FILE{7}.M = arima('D',1, 'MALags',[2 3 4 5 6 7] ,'Seasonality',7,'SMALags',[1,2,3]);

catalanHolidays2012 = [6 97 100 122 149 255 268 286 306 341 343 361];

%wee need a function that evaluates how good is the accuracy of performanceKNN(C,m,tau,h,training)
%predictionkNN(currentVector,i,o,epsilon)

%training set
training = 0.7;

%prediction horizon daily scale
H = 2;

%
gamma = 24;

%epsilon Ranges of Eq ()
epsilonRanges = 0:0.1:1;


%m ranges of Eq ()
mRanges = 1:20;

%m' ranges of Eq. ()
mma = 1:20;

%number of clusters tested
ncmin = 2;
ncmax = 7;
repetitions = 100;
%allM = zeros(1,length(F));
%allMA = zeros(1,length(F));
%allEps = zeros(1,length(F));
%allErrs = zeros(1,length(F));
%allCalErrs = zeros(1,length(F));
%allErrNN = 0;
%allErrCal = 0; 
%allErrBay = 0;
%allRMSEkNN = 0;
%allRMSECal = 0;
%allRMSEBay = 0;
%ALLMAEERRS = [];

%number of time series tested
nts=length(FILE);
for fix = 1:7
    
    %RMSErrors =[];
    %MAErrors = [];
    
    allKindOfErrorsBayes =[];
    allKindOfErrorsCal =[];
    allKindOfErrorsKnn =[];
    allKindOfErrorsNaive =[];
    
    residualsBayes = [];
    residualsCal=[];
    residualsKnn=[];
    residualsNaive =[];
    
    TS = normalizeWDD(readTS(FILE{fix}.F));
    trainingDaysNumber = round((length(TS)/gamma)*training);
    
    [ql,qn]=decomposeTS(TS,gamma);
    [passed, sarimafcast] = validateSARIMA(qn,training,FILE{fix}.M);
    [EstMdl,EstParamCov] = estimate(FILE{fix}.M, qn(:,1:trainingDaysNumber)');
   
   [C1,MW,K,M ] = findK( ql(:,1:trainingDaysNumber)',ncmin,ncmax,repetitions );
   FILE{fix}.K = K;
    
    [C,P]=learnPatternsWithKMeans(ql,training,K);
    auxClasses = C;
    auxP = P;
    if sum(C==1)>sum(C==2)
        C(find(auxClasses==1))=2;
        C(find(auxClasses==2))=1;
        P(1,:)=auxP(2,:);
        P(2,:)=auxP(1,:);
    end
    [m,epsilon,fit] = findkNNparams(C,mRanges,1,epsilonRanges,H,training);
   % allM(fix)= m;
   % allEps(fix) = epsilon;
    FILE{fix}.m = m;
    FILE{fix}.eps = epsilon;
    
    [i,o]= formatTS(C,m,1,H);
    s=floor(size(i,2)*training*training);
    f=floor(size(i,2)*training);
    bTable = [];
  %  testError = 0;
    ma=getBestMA(C(1:trainingDaysNumber),ql(:,1:trainingDaysNumber),training,mma); %#ok<NBRAK>
    FILE{fix}.MA = ma;
    for d = m+H:f
        
        currentVector = i(:,d-m+1);
        realFutureModes =  C(d+1:d+H);
        [modePrediction] = predictionkNN( currentVector,i(:,1:d-m+1-H),o(:,1:d-m+1-H),epsilon );
        calP = calendarPrediction(d,H,catalanHolidays2012,C(1));
        %modePredictionCalendar = calendarPrediction(d,h,holidays,C(1))
        %%testError = testError + sum(realFutureModes~= modePrediction');   
        for j=0:gamma-1
            hour = d*gamma+j; 
            periodSection = mod(hour-1,gamma)+1;   
                lagV = TS(hour-gamma+1:hour);
                lagV = lagV/sum(lagV);
                k = nearestPattern(P,lagV,periodSection);      
                bTable = [bTable ;mod(d,7)+1 mod(hour,gamma)+1 k modePrediction calP' realFutureModes' ];
        end
    end

    for d = f+1: length(C)-H
        currentVector = i(:,d-m+1);
        realFutureModes =  C(d+1:d+H);
        [modePrediction] = predictionkNN( currentVector,i(:,1:d-m+1-H),o(:,1:d-m+1-H),epsilon );
        calP = calendarPrediction(d,H,catalanHolidays2012,C(1));
        [Y,YMSE] = forecast(EstMdl,H,'Y0',qn(d-55:d)');
        for j=0:gamma-1
            hour = d*gamma+j;
            realQL=TS(hour+1:hour+gamma);
            naivePred = TS(hour-gamma+1:hour);
            periodSection = mod(hour-1,gamma)+1;   
                lagV = TS(hour-gamma+1:hour);
                lagV = lagV/sum(lagV);
                
                qlR=ql(:,C(1:d)==1);
                P1=mean(qlR(:,end-ma:end)');
                
                qlR2=ql(:,C(1:d)==2);
                P2=mean(qlR2(:,end-ma:end)');
                
                PP=[P1;P2];
                
                k = nearestPattern(P,lagV,periodSection);
                kk = nearestPattern(PP,lagV,periodSection);
           %     bTable = [bTable ; mod(hour,tau)+1 k modePrediction calP' realFutureModes' ];
                A = getIndependentProbabilities(mod(d,7)+1,mod(hour,gamma)+1,bTable);
                [aa,bb]=max( A(1:3));
               %  sel =[sel bb];
                switch bb
                    case(1)
                        nextMode = kk;
                    %     fprintf('a \n');
                   
                    case(2)
                        nextMode = modePrediction(1);
                   %      fprintf('b \n');
                   
                    case(3)
                        nextMode = calP(1);
                     %    fprintf('c \n');
                     
                end
                 [aa,bb]=max( A(4:end));
            %     sel1 =[sel1 bb];
                switch bb
                    case(1)
                        nextMode2 = kk;
                        
                    case(2)
                        nextMode2 = modePrediction(2);
                       
                    case(3)
                        nextMode2 = calP(2);
                end
                

               
               % predictedQL = [P(nextMode,:)*Y(1) P(nextMode2,:)*Y(2)]; 
                predictedQL = [PP(nextMode,:)*Y(1) PP(nextMode2,:)*Y(2)];
                y= realQL;
                yHat = predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)';
                
                residualsBayes = [residualsBayes y-yHat];
                allKindOfErrorsBayes = [allKindOfErrorsBayes errors(y,yHat)];
                
                residualsNaive = [residualsNaive y-naivePred];
                allKindOfErrorsNaive = [allKindOfErrorsNaive errors(y,naivePred)];
                
              %%PROB
            %    MAEBAYES =[MAEBAYES MAE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
             %   RMSEBAYES = [RMSEBAYES RMSE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
               % MASEBAYES = [MASEBAYES MASE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)',naivePred)];
             %   MAPEBAYES = [MAPEBAYES MAPE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
              
                %%NAIVE
             %   MAENAIVE =[MAENAIVE MAE(realQL,naivePred)];
             %   RMSENAIVE = [RMSENAIVE RMSE(realQL,naivePred)];
             %   MAPENAIVE = [RMSENAIVE MAPE(realQL,naivePred)];
               
               
               % MSEBAYES = [MSEBAYES MSE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
                
                %%
                
                %predkNN
                predictedQL = [P( modePrediction(1),:)*Y(1) P( modePrediction(2),:)*Y(2)];
                yHat = predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)';
              %  predictedQL = [PP( modePrediction(1),:)*Y(1) PP( modePrediction(2),:)*Y(2)];         
               residualsKnn = [residualsKnn y-yHat];
              %  MAEKNN =  [MAEKNN   MAE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')]; 
              %   RMSEKNN = [RMSEKNN RMSE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
              %    MAPEKNN = [MAPEKNN MAPE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
              allKindOfErrorsKnn = [allKindOfErrorsKnn errors(y,yHat)];
               

                 predictedQL = [P( calP(1),:)*Y(1) P( calP(2),:)*Y(2)];
           %       predictedQL = [PP( calP(1),:)*Y(1) PP( calP(2),:)*Y(2)];
                  yHat = predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)';
                    residualsCal = [residualsCal y-yHat];
                     allKindOfErrorsCal = [allKindOfErrorsCal errors(y,yHat)];
              %   RMSECAL = [RMSECAL RMSE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
              %    MAPECAL = [MAPECAL MAPE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
              %     MAECAL =[MAECAL MAE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')]; 
              %      MSECAL = [MSECAL MSE(realQL,predictedQL(mod(hour,gamma)+1:mod(hour,gamma)+gamma)')];
             
                  %update probabilities     
                  bTable = [bTable ; mod(d,7)+1 mod(hour,gamma)+1 k modePrediction calP' realFutureModes' ];
            
              
        end
        
        
    end
    
    FILE{fix}.PerformanceBayes = mean(allKindOfErrorsBayes');
    FILE{fix}.PerformanceCal = mean(allKindOfErrorsCal');
    FILE{fix}.PerformanceKnn = mean(allKindOfErrorsKnn');
    FILE{fix}.PerformanceNaive = mean(allKindOfErrorsNaive');
    FILE{fix}.ResidualsBayes = residualsBayes;
    FILE{fix}.ResidualsCal = residualsCal;
    FILE{fix}.ResidualsKnn = residualsKnn;
    FILE{fix}.ResidualsNaive = residualsNaive;


  % ALLMAEERRS = [ALLMAEERRS; [mean(RMSEBAYES) mean(RMSECAL) mean(RMSEKNN) ]];
end



fprintf("-----Results-----\n");
metric = ["MAE", "RMSE", "MAPE"];
for errorMetric = 1:length(metric)
    fprintf('\n %s \n',metric(errorMetric));
    fprintf("Sector \t \t \t \t \t # \t \t QMMP+ \t \t Cal \t \t NN \t \t Naive\n");
    for i=1:nts
        sctr = FILE{i}.F;
        e1 = FILE{i}.PerformanceBayes(errorMetric);
        e2 = FILE{i}.PerformanceCal(errorMetric);
        e3 = FILE{i}.PerformanceKnn(errorMetric);
        e4 = FILE{i}.PerformanceNaive(errorMetric);
        fprintf('%s \t %d \t %f \t %f \t %f \t %f \t \n',sctr,i,e1,e2,e3,e4);
    end
end

fprintf("\n Variance \n")
fprintf("Sector \t \t \t \t \t # \t \t QMMP+ \t \t Cal \t \t NN \t \t Naive\n");
for i=1:nts
    sctr = FILE{i}.F;
    e1 = var(FILE{i}.ResidualsBayes(:));
    e2 = var(FILE{i}.ResidualsCal(:));
    e3 = var(FILE{i}.ResidualsKnn(:));
    e4 = var(FILE{i}.ResidualsNaive(:));
    fprintf('%s \t %d \t %f \t %f \t %f \t %f \t \n',sctr,i,e1,e2,e3,e4);
end

fprintf("\n Params \n")
fprintf("Sector \t \t \t \t \t \t m \t \t \t  \t epsilon \t ma \n")
for i=1:nts
    sctr = FILE{i}.F;
    fprintf('%s \t  \t %d  \t \t \t %2.1f \t \t %d \t \n',sctr,FILE{i}.m,FILE{i}.eps, FILE{i}.MA);
end
