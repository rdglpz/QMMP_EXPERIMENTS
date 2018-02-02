function [ A] = getIndependentProbabilities( day2Predict,hour2Predict,bTable)

 %   pNN1  = sum( (bTable(bTable(:,1)==hour2Predict , 2)-bTable(bTable(:,1)==hour2Predict , 7)).^2)/size(bTable(:,1),1);
  %  pkNN1 = sum((bTable(bTable(:,1)==hour2Predict , 3)-bTable(bTable(:,1)==hour2Predict , 7)).^2)/size(bTable(:,1),1);
   % pCal1 = sum((bTable(bTable(:,1)==hour2Predict , 5)-bTable(bTable(:,1)==hour2Predict , 7)).^2)/size(bTable(:,1),1);
    
 %   pNN2  = sum((bTable(bTable(:,1)==hour2Predict , 2)-bTable(bTable(:,1)==hour2Predict , 8)).^2)/size(bTable(:,1),1);
  %  pkNN2 = sum((bTable(bTable(:,1)==hour2Predict , 4)-bTable(bTable(:,1)==hour2Predict , 8)).^2)/size(bTable(:,1),1);
   % pCal2 = sum((bTable(bTable(:,1)==hour2Predict , 6)-bTable(bTable(:,1)==hour2Predict , 8)).^2)/size(bTable(:,1),1);
    
  %  A = [ pNN1 pkNN1 pCal1 pNN2 pkNN2 pCal2 ] ;
    
    
    dyIx=1;
    hrIx=2;
    nnIx=3;
    knn1=4;
    knn2=5;
    cal1=6;
    cal2=7;
    pred1=8;
    pred2=9;
  %  total = length(bTable(bTable(:,hrIx)==hour2Predict,nnIx)==bTable(bTable(:,hrIx)==hour2Predict,pred1));
  %  total = length(bTable((bTable(:,hrIx)==hour2Predict) & (bTable(:,1)==day2predict)  ,:));
 %   tempTab = bTable((bTable(:,hrIx)==hour2Predict) & (bTable(:,dyIx)==day2Predict)   ,:);
     tempTab = bTable((bTable(:,hrIx)==hour2Predict)   ,:);
    
   % pNN1 =  sum(bTable(bTable(:,hrIx)==hour2Predict,nnIx)==bTable(bTable(:,hrIx)==hour2Predict,pred1))/total;
   % pkNN1 = sum(bTable(bTable(:,hrIx)==hour2Predict,knn1)==bTable(bTable(:,hrIx)==hour2Predict,pred1))/total;
   % pCal1 = sum(bTable(bTable(:,hrIx)==hour2Predict,cal1)==bTable(bTable(:,hrIx)==hour2Predict,pred1))/total;
    
    pNN1 = sum(tempTab(:,nnIx)==tempTab(:,pred1))/length(tempTab);
    pkNN1 =sum(tempTab(:,knn1)==tempTab(:,pred1))/length(tempTab);
    pCal1 = sum(tempTab(:,cal1)==tempTab(:,pred1))/length(tempTab);
    
    
  %  total = length(bTable(bTable(:,hrIx)==hour2Predict,nnIx)==bTable(bTable(:,hrIx)==hour2Predict,pred1));
   
    
    %pNN2 =  sum(bTable(bTable(:,hrIx)==hour2Predict,nnIx)==bTable(bTable(:,hrIx)==hour2Predict,pred2))/total;
    %pkNN2 = sum(bTable(bTable(:,hrIx)==hour2Predict,knn2)==bTable(bTable(:,hrIx)==hour2Predict,pred2))/total;
    %pCal2 = sum(bTable(bTable(:,hrIx)==hour2Predict,cal2)==bTable(bTable(:,hrIx)==hour2Predict,pred2))/total;
    
    
      pNN2 = sum(tempTab(:,nnIx)==tempTab(:,pred2))/length(tempTab);
    pkNN2 =sum(tempTab(:,knn2)==tempTab(:,pred2))/length(tempTab);
    pCal2 = sum(tempTab(:,cal2)==tempTab(:,pred2))/length(tempTab);
    
  %  pNN2  = sum((bTable(bTable(:,hrIx)==hour2Predict , nnIx)-bTable(bTable(:,hrIx)==hour2Predict , pred2)).^2)/size(bTable(:,hrIx),1);
  %  pkNN2 = sum((bTable(bTable(:,hrIx)==hour2Predict , knn2)-bTable(bTable(:,hrIx)==hour2Predict , pred2)).^2)/size(bTable(:,hrIx),1);
  %  pCal2 = sum((bTable(bTable(:,hrIx)==hour2Predict , cal2)-bTable(bTable(:,hrIx)==hour2Predict , pred2)).^2)/size(bTable(:,hrIx),1);
    
    A = [ pNN1 pkNN1 pCal1 pNN2 pkNN2 pCal2 ] ;

end


 %pNN1  = sum((bTable(find( (bTable(:,1)==hour2Predict) && (bTable(:,9)==dayn)  ),[2])-bTable(  (find(bTable(:,1)==hour2Predict) && (bTable(:,9)==dayn) ),[7])).^2)/size(bTable(:,1),1);
  %  pkNN1 = sum((bTable(find( (bTable(:,1)==hour2Predict   && (bTable(:,9)==dayn) )),[3])-bTable(  find(bTable(:,1)==hour2Predict) && (bTable(:,9)==dayn)   )).^2)/size(bTable(:,1),1);
   % pCal1 = sum((bTable(find( bTable(:,1)==hour2Predict ),[5])-bTable(find(bTable(:,1)==hour2Predict) && (bTable(:,9)==dayn)  ),[7])).^2)/size(bTable(:,1),1);
    
   % pNN2  = sum((bTable(find(bTable(:,1)==hour2Predict ),[2])-bTable(find(bTable(:,1)==hour2Predict ),[8])).^2)/size(bTable(:,1),1);
   % pkNN2 = sum((bTable(find(bTable(:,1)==hour2Predict ),[4])-bTable(find(bTable(:,1)==hour2Predict ),[8])).^2)/size(bTable(:,1),1);
   % pCal2 = sum((bTable(find(bTable(:,1)==hour2Predict ),[6])-bTable(find(bTable(:,1)==hour2Predict ),[8])).^2)/size(bTable(:,1),1);
    
    %A = [ pNN1 pkNN1 pCal1 pNN2 pkNN2 pCal2 ] ;
