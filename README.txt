**README**

Supplementary files of the manuscript "Multi-model Prediction for Demand Forecast in Water
Distribution Networks".

This folder contains the codes in MATLAB and R that generate the results presented in tables 1 to 5. for the manuscript.
The folder demands2012 contains the water demand time series.
The folder package_qmmp contains all the codes in .m required by the MATLAB main files.
The "MATLAB_main01_QMM.m", "MATLAB_main02_ARIMA.m" and "MATLAB_main03_RBFANN.m" codes have been tested in MATLAB2017b 64-bit (win64).

a) The "MATLAB_main01_QMMMP.m" generates:

1. The m', m and epsilon columns of Table 1. SARIMA coefficients for each time series.
2. The QMMP+, Cal, NN and Naive columns of Table 2 to 4 reporting MAE, RMSE and MAPE.
3. The mean of the individual variances (Table 5) of QMMP+, Cal, NN and Naive .


b) The "MATLAB_main02_ARIMA.m" generates:

1. The ARIMA column results of Tables 2 to 4 reporting MAE, RMSE and MAPE.
2. The mean of the individual variances (Table 5) of ARIMA.


c) The "MATLAB_main03_RBFANN.m" generates:

1. The RBFANN column results of Tables 2 to 4 reporting MAE, RMSE and MAPE.
3. The mean of the individual variances (Table 5) of RBFANN.


The "R_main01_ DSHW.R" and "Autoarima.R" codes have been tested in R version 3.4.3

d) The "R_main01_ DSHW.R" generates the results:

1. The DSHW column results of Tables 2 to 4 reporting MAE, RMSE and MAPE.
2. The mean of the individual variances (Table 5) of DSHW.


d) The "Autoarima.R" estimates the ARIMA coefficients used in "MATLAB_main02_ARIMA.m".


-Rodrigo Lopez-Farias
rodrigo.lopez@centromet.mx


