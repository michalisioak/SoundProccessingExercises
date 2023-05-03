function [a,g]=lpc_new(s,p)
[autos ,lags] = xcorr(s);
autos = autos(find(lags==0):end); 
[a,g] = levinson(autos ,p);
g=sqrt(g);
a=a';