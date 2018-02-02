function [ bestMA,errorMA ] = getBestMA(C,ql,ts,ranges)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    errorMA=zeros(1,max(ranges));
      ix=1;
      bestMA=1;
      besetMAVal=999;
    for m=ranges
      
        for i=floor(length(C)*ts):floor(length(C))-1
            PP = C(i+1);
            oneClass = ql(:,C(1:i)==PP);
           % size(oneClass)
            
            predictionPattern = mean(oneClass(:,end-m:end)')/sum(mean(oneClass(:,end-m:end)'));
            errorMA(ix)=errorMA(ix)+MAE(ql(:,i+1),predictionPattern');
          
            
        
        end
        if  errorMA(ix)<besetMAVal
            bestMA=m;
            besetMAVal = errorMA(ix);
        end
        ix=ix+1;
    end


end

