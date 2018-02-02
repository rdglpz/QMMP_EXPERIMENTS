function [ allClasses , prototypes ] = learnPatternsWithKMeans( ql,training,n)
    totalDays = size(ql,2);
    %tau =  size(ql,1);
    tDays = floor(totalDays*training);
    [classes ,prototypes, sumdist] = kmeans( ql(:,1:tDays)',n,'distance','city','display','final','replicates',100);
    classesB = zeros(totalDays-tDays,1);
    size(classesB);
    for i=tDays+1:totalDays
        [a,b] = min(sum((repmat(ql(:,i),1,n)-prototypes').^2)); 
        classesB(i-tDays)=b;
    end
    allClasses = [classes ; classesB];
end

