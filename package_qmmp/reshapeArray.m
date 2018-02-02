function [ rs ] = reshapeArray( A,a )
    A=A(1:floor(length(A)/a)*a);
    l = length(A)/a;
    rs=reshape(A,a,l)';
    
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

