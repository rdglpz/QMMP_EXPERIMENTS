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


nf = length(file);
tr= 0.7;

for (f in 1:nf){
	print(c(f,": ARIMA STRUCTURE for", file[f]));
	 y = scan(paste(folder,file[f],sep=""));
	 MAX = max(y);
	MIN= min(y);
	y = (y-MIN)/(MAX-MIN);
	eps = 0;
	yTS= y[1:floor(length(y)*tr)]+eps;
	fit<-auto.arima(yTS, max.p=24, max.q=24, D=3 ,max.P = 48, max.Q = 48, max.d=3, stationary=FALSE, seasonal=TRUE, seasonal.test=c("ocsb","ch"));
	print(fit);
	
}




