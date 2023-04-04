addpath('./');

function thetaWrapped = wrapToPi(theta)
% WRAPTOPI Wrap angle in radians to [-pi pi]
thetaWrapped = mod(theta + pi, 2*pi) - pi;
end


[x, Fs] = audioread('piano.wav');
frame = 512;
ovrlp = 0.25;
X = frame_wind(x, frame, ovrlp);
%% a -----------------------------------------------------------------------------------------------
% calculating fast fourier transform with fft()
fft_var = fft(X);
% array containg the magnitude of every fft
XFmag = abs(fft_var);
% array containg the phase of every fft
XFphase = angle(fft_var);
%% b -----------------------------------------------------------------------------------------------
% double loop that subtracts every element with the right element (exception for k=1)
for f = 1:size(XFmag)(1)
    for k = 2:size(XFmag)(2)
        dE(f,k) = XFmag(f,k) - XFmag(f,k-1);
    end
end
% init DE an array with zero
DE = zeros(1,size(dE)(2));
% looping and adding every row
for f = 1:size(dE)(1)
    for k = 1:size(dE)(2)
        DE(k) += dE(f,k);
    end
end
% plotting time
subplot(2,2,1);
plot(DE);
title('DE');
%% c -----------------------------------------------------------------------------------------------
% looping and calculating dPhase
for f = 1:size(XFphase)(1)
    for k = 3:size(XFphase)(2)
        dPhase(f,k) = wrapToPi(XFphase(f,k)-wrapToPi(2*XFphase(f,k-1)-XFphase(f,k-2)));
    end
end
% init DPhase an array with zero
DPhase = zeros(1,size(dPhase)(2));
for f = 1:size(dPhase)(1)
    for k = 1:size(dPhase)(2)
        DPhase(k) +=  abs(dPhase(f,k))**2;
    end
end
% plotting time
subplot(2,2,2);
plot(DPhase);
title('DPhase');
%% d -----------------------------------------------------------------------------------------------
for f = 1:size(XFphase)(1)
    for k = 3:size(XFphase)(2)
        dPhase(f,k) = wrapToPi(2*XFphase(f,k-1)-XFphase(f,k-2));
    end
end
for f = 1:size(XFmag)(1)
    for k = 2:size(XFmag)(2)
        dC(f,k) = XFmag(f,k)-XFmag(f,k-1)*exp(j*dPhase(f,k));
    end
end
DC = zeros(1,size(dC)(2));
for f = 1:size(dC)(1)
    for k = 1:size(dC)(2)
        DC(k) +=  abs(dC(f,k))**2;
    end
end
% plotting time
subplot(2,2,3);
plot(DC);
title('DC');

pause;

