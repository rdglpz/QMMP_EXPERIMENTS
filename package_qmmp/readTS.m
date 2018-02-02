function [ mvData ] = readTS( str )
%Read Water Demand Data 
    fid = fopen(str);
    mvData=fscanf(fid, '%f', [1 inf])';
    fclose(fid);
end

