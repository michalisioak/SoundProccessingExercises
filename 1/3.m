addpath('./');

function thetaWrapped = wrapToPi(theta)
% WRAPTOPI Wrap angle in radians to [-pi pi]
thetaWrapped = mod(theta + pi, 2*pi) - pi;
end


[x, Fs] = audioread('piano.wav');
frame = 512;
ovrlp = 0.25;
X = frame_wind(x, frame, ovrlp);

fft_var = fft(X);
XFmag = abs(fft_var);
XFphase = angle(fft_var);

for f = 1:size(XFmag)(1)
    for k = 2:size(XFmag)(2)
        dE(f,k) = XFmag(f,k) - XFmag(f,k-1);
    end
end
DE = zeros(1,size(dE)(2));
for f = 1:size(dE)(1)
    for k = 1:size(dE)(2)
        DE(k) += dE(f,k);
    end
end

for f = 1:size(XFphase)(1)
    for k = 3:size(XFphase)(2)
        dPhase(f,k) = wrapToPi(XFphase(f,k)-wrapToPi(2*XFphase(f,k-1)-XFphase(f,k-2)));
    end
end
DPhase = zeros(1,size(dPhase)(2));
for f = 1:size(dPhase)(1)
    for k = 1:size(dPhase)(2)
        DPhase(k) +=  abs(dPhase(f,k))**2;
    end
end

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

% comments for the above code are located at "2.m"

%% b -----------------------------------------------------------------------------------------------
function distance = findSecondPeakDistance(arr)
% find maximas
[pks,locs] =findpeaks(arr,"DoubleSided");
% sort maximas
sortedPks = sort(pks,'descend');
% find the index of the second peak (we get the second peak by getting the second element in sortedPks)
index1 = find(pks==sortedPks(1));
index2 = find(pks==sortedPks(2));
% find the true locations
location1 = locs(index1(1));
% index2 has two locations one behind the center and one after (because of symmetry)
location2 = locs(index2(2));
% we use the one after to skip abs()
distance = location2 - location1;
end


%% c -----------------------------------------------------------------------------------------------
function bpm = getBPMBy(arr,frame,ovrlp,Fs)
% frame_to_samples_const = (size(x)(1) ) / frame 
distance_in_samples = findSecondPeakDistance(arr) * frame * ovrlp;
secs = distance_in_samples / Fs;
bpm = 60/secs;
end

RDE = xcorr(DE);
subplot(1,3,1);
plot(RDE);
title('R_D_E(αυτοσυσχέτιση)');
bpm_by_energy = getBPMBy(RDE,frame,ovrlp,Fs)

%% d -----------------------------------------------------------------------------------------------
RDPhase = xcorr(DPhase);
subplot(1,3,2);
plot(RDPhase);
title('R_D_P_h_a_s_e(αυτοσυσχέτιση)');
bpm_by_phase = getBPMBy(RDPhase,frame,ovrlp,Fs)

RDC= xcorr(DC);
subplot(1,3,3);
plot(RDC);
title('R_D_C(αυτοσυσχέτιση)');
bpm_by_complex = getBPMBy(RDC,frame,ovrlp,Fs)

% piano.wav
% original: 80 bpm
% detected with DE: 80.645     (0.80625% error)
% detected with DPhase: 2500   (3025% error)
% detected with DC: 81.522     (1.9025% error)
% 
% We can not use DPhase because it is hard to find the second peak (see figure 1)
% the graph is smooth and it changes only the slope

%% e -----------------------------------------------------------------------------------------------

% insomnia.wav
% original: 129
% detected: 63
% 
% bpm_by_energy = 31.780       (305.91567% error)
% bpm_by_phase = 1875          (93.12% error)
% bpm_by_complex = 63.559      (102.961028% error)
% 
% expected these results because there is too much noise

% seven_nation_army.wav
% original: 124 
% detected: 125
% 
% bpm_by_energy = 125         (0.806451613% error)
% bpm_by_phase = 1875         (93.3333333% error)
% bpm_by_complex = 125        (0.806451613% error)

pause;