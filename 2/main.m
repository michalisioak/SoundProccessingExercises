addpath("./")
addpath("./mfcc-octave")

% A
[x, Fs] = audioread('voice.wav');
X = frame_wind(x, 256, 0.25);
[a_voice,g_voice] =lpc_new(X,30);

% B
[x, Fs] = audioread('piano_samples.wav');
X = frame_wind(x, 256, 0.25);
coeffs = mfcc(X)