function [ C,MW,K,M ] = findK( d,minK,maxK,replicates )
%findK Find the most suitable number of classes using silhuette index
    K=[];
    msi = -1;
    M=[];
    MW = [];
    for k=minK:maxK
        [classes ,mw, sumdist] = kmeans(d,k,'distance','city','display','final','replicates',replicates);
        [silhuetteIndex, b]= silhouette(  d, classes);
        M=[M mean(silhuetteIndex)];
        if mean(silhuetteIndex)>msi;
            msi = mean(silhuetteIndex);
            K=k;
            MW = mw;
            C = classes;
        end
    end
end

