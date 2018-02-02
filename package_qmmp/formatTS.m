function [ X, Yo ] = formatTS(ts,m,tau,h)
    nInputs = (m-1)*tau+1;
    nOutputs = h; 
    ip = []; op = [];
    Y = ts;
    for i=nInputs: length(Y)-(nOutputs)
        ip = [ip  ts(i-(m-1)*tau:tau:i)];
        op = [op  ts(i+1:i+h) ];
    end
    X = ip;
    Yo = op;
 %  
end

