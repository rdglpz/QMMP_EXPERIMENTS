function [ m,eps,fit] = findkNNparams( C,nix,tau,epsilonx,h,training)
    fit = zeros(length(nix),length(epsilonx));
    for ni = nix
        [i,o]= formatTS(C,ni,tau,h);
        s=floor(size(i,2)*training*training);
        f=floor(size(i,2)*training);
        ex=1;
        for epsilon=epsilonx
            error=0;
            for j = s: f
                currentVector = i(:,j);
                [modePrediction] = predictionkNN( currentVector,i(:,1:j-h),o(:,1:j-h),epsilon );
                error = error + sum(o(:,j)~= modePrediction');  
            end
             fit(ni,ex)=  error;
             ex=ex+1;
        end
    end
    [a ,b]= min(fit);
    [a2,bestEps]= min(a);
    
    [a3, m]= min(fit(:,bestEps));
    eps = bestEps*0.1-0.1;
end

