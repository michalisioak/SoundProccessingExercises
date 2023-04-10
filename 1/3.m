addpath('./');

function thetaWrapped = wrapToPi(theta)
% WRAPTOPI Wrap angle in radians to [-pi pi]
thetaWrapped = mod(theta + pi, 2*pi) - pi;
end


[x, Fs] = audioread('seven_nation_army.wav');
frame = 512;
ovrlp = 0.25;
X = frame_wind(x, frame, ovrlp);

fft_var = fft(X);
XFmag = abs(fft_var);
XFphase = angle(fft_var);

dE = diff(XFmag, 1, 2); % Compute the differences between adjacent columns of XFmag
DE = sum(dE, 1); % Sum the differences over the first dimension of dE

dPhase = wrapToPi(XFphase(:,3:end) - wrapToPi(2*XFphase(:,2:end-1) - XFphase(:,1:end-2)));
DPhase = sum(abs(dPhase).^2, 1);

dC = (XFmag(:,2:end) - XFmag(:,1:end-1))(:,1:end-1) .* exp(j*dPhase); %(:,1:end-1) to make op1 compatible (op1 is 512x985, op2 is 512x984) //remove a column
DC = sum(abs(dC).^2, 1);

%% b -----------------------------------------------------------------------------------------------
function distance = findSecondPeakDistance(arr)
[pk,pk_index] = max(arr);
% remove everything left to the peak
arr(1:pk_index-1) = 0;
% put a threshold 70% second largest peak (not the first because it is too large)
[pks,locs] =findpeaks(arr,"DoubleSided");
sortedPks = sort(pks,'descend');
threshold = 0.7 * sortedPks(2);
% remove every peak below the threshold
filtered_peaks = pks;
filtered_peaks(filtered_peaks<threshold) = [];
% find the index of the second and first peak 
% (we get the peaks by getting the second and first element in filtered_peaks)
index1 = find(pks==filtered_peaks(1));
index2 = find(pks==filtered_peaks(2));
% find the true locations
location1 = locs(index1);
location2 = locs(index2);
% we removed everything left to [location1],so we dont need abs() 
distance = location2 - location1;
end


%% c -----------------------------------------------------------------------------------------------
function bpm = getBPMBy(arr,frame,ovrlp,Fs)
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
% detected: 127.12
% 
% bpm_by_energy = 127.12       (1.45736434% error)
% bpm_by_phase = 1875          (93.12% error)
% bpm_by_complex = 258.62      (100.48062% error)

% seven_nation_army.wav
% original: 124 
% detected: 125
% 
% bpm_by_energy = 125         (0.806451613% error)
% bpm_by_phase = 1875         (93.3333333% error)
% bpm_by_complex = 127.12     (2.51612903% error)

pause;