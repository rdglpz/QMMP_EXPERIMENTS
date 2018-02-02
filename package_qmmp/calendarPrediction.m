function [ predictionMode ] = calendarPrediction( i,nForecast,holidays,sun )
    predictionMode=zeros(nForecast,1);
    cont=0;
    for j=i+1:i+2
        cont=cont+1;
        dayNumber = j;
        day = mod(dayNumber,7);
        if ~isempty(find(holidays==dayNumber, 1)) || day==1 || day==0
            if sun==1
                predictionMode(cont)=1;
            else
                predictionMode(cont)=2;
            end
        else
            if sun==1
                predictionMode(cont)=2;
            else
                predictionMode(cont)=1;
            end
        end
    end


end

