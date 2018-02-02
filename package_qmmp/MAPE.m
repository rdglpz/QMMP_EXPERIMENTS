function E = MAPE(a,b)
    constant = 0.01;
    a=a+constant;
    b=b+constant;
    E = mean(abs(a-b)./abs(a))*100;
end
