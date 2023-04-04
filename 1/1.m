addpath('./');
% getting the audio
[x, Fs] = audioread('insomnia.wav');
% splitting the audio to frames
X = frame_wind(x, 80, 0.5);
% re-making the audio
y = frame_recon(X, 0.5);
% play the re-make
soundsc(x, Fs);

