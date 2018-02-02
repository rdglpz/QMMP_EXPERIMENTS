#! /usr/bin/Rscript
#library(R.matlab)
# http://robjhyndman.com/hyndsight/forecast4/

library(forecast)

folder = "C:/Users/rdglp.DESKTOP-9U5VJV3/Dropbox/PrSelQuadMod_Energies_journal/suplementary_material/MetaModelPrediction/QMMPP_MATLAB_EXPERIMENTS/demands2012/";
file = 0; 
file[1] = "p10007.txt";
file[2] = "p10015.txt";
file[3] = "p10017.txt";
file[4] = "p10026.txt";
file[5] = "p10095.txt";
file[6] = "p10109.txt";
file[7] = "p10025.txt";

allRes = 0;

nf = length(file);
tr= 0.7;
start=1;
horizon = 24;
H=24;
eps = 0.000000000000000001;
MAE = 0;
MSE = 0;
RMSE = 0;
MAPE = 0;
VAR = 0;
unstability = 0;

ALLMAERESULTS = 0;
ALLRMSERESULTS = 0;
ALLMAPERESULTS = 0;
ALLMSERESULTS = 0;
ALLVARRESULTS = 0;


for (f in 1:7){
    unstability[f] = "Stable";
    MSERESULTS = 0;
    MAERESULTS = 0;
    MAPERESULTS = 0;
    RMSERESULTS = 0;
    PREDICTION = 0;
    residuals = c();
    y = scan(paste(folder,file[f],sep=""));
    MAX = max(y);
    MIN = min(y);
    y = (y-MIN)/(MAX-MIN);
    yTS = y[1:floor(length(y)*tr)]+eps;
    yVS = y[floor(length(y)*tr+1):length(y)]+ eps;
    fullTS = c( yTS, yVS);
    finish = round(length(yTS));
    fit <- dshw(c(yTS),period1=24, period2=24*7,h=horizon,alpha=NULL, beta=NULL, gamma=NULL, omega=NULL, phi=NULL,lambda=NULL, armethod=TRUE);
    model <- fit$model;
    observation = c( yTS, yVS);
    yhat = mean(observation);
    lb = floor(length(observation)*tr);
    ub = floor(length(observation));
    errorIX = 0;
    for (j in lb: (ub-horizon)){
        #errorIX = j-lb+1;
        recentObservations = observation[(j-24*7*2):j];
        A = observation[(j+1):(j+H)];
        AP <- dshw(recentObservations, period1=24, period2=24*7,h=horizon, alpha=model$alpha, beta=model$beta, 	gamma=model$gamma,omega=model$omega, phi=model$phi, lambda=model$lambda,armethod=TRUE)$mean
        #tmp=c(AP-A);
        #residuals =rbind(residuals, tmp);
        #DSHW is unstable for some input data, we discard absolute errors greater than 100
	  tol = mean(abs((A+0.00000001)-(AP+0.000000001))/abs(A+0.00000001))*100;
	  tol =  max(abs(A-AP));
        if (tol < 7e+12 ){
		errorIX = errorIX + 1;
		print(max(abs(AP-A)));
        	residuals =c(residuals, (AP-A));
        	n = 100/length(A);
        	e = n*(sum(abs((A-AP)/yhat)));
        	MAERESULTS[errorIX] = mean(abs(A - AP));
        	MSERESULTS[errorIX] = mean((A - AP)^2);
        	RMSERESULTS[errorIX] = sqrt(mean((A - AP)^2));
        	MAPERESULTS[errorIX] = mean(abs((A+0.00000001)-(AP+0.000000001))/abs(A+0.00000001))*100;
        	e=sqrt(sum((A - AP)^2)/length(A)); 
        }else{
		unstability[f] = "Unstable";
		AC = A;
	  }
	allRes[f] = sort(residuals);
    }
  
    MAE[f] = mean(MAERESULTS);
    RMSE[f] = mean(RMSERESULTS);
    MAPE[f] = mean(MAPERESULTS);
    VAR[f] = var(as.vector(residuals));
    MSE[f] = mean(MSERESULTS);
    ALLMAERESULTS[f] = list(MAERESULTS);
    ALLRMSERESULTS[f] = list(RMSERESULTS);
    ALLMAPERESULTS[f] =  list(MAPERESULTS);
    ALLVARRESULTS[f] = list(var(as.vector(residuals)));
    ALLMSERESULTS[f] = list(ALLMSERESULTS);
	
}

print("MAE");
for (f in 1:nf){
	print(c(file[f],MAE[f],unstability[f]));
}

print("RMSE")
for (f in 1:nf){
	print(c(file[f],RMSE[f],unstability[f]));
}

print("MAPE")
for (f in 1:nf){
	print(c(file[f],MAPE[f],unstability[f]));
}

print("Variance")
for (f in 1:nf){
	print(c(file[f],VAR[f],unstability[f]));
}

