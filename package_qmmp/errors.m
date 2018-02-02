function [ E ] = errors(y,yhat)
    ne = 3;
    E=zeros(ne,1);
    E(1)=MAE(y,yhat);
    E(2)=RMSE(y,yhat);
    E(3)=MAPE(y,yhat);


end

