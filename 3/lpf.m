function y=lpf(x,Fs,Fc)
k = tan(pi*Fc/Fs);
under = 1+sqrt(2)*k+k**2;
bs = [k**2,2*k**2,k**2]/under;
as = [2*(k**2-1),(1-sqrt(2)+k**2)]/under;
y = filter(bs,as,x);
end
