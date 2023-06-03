addpath('./');

verbose = false;

[x_guitar, Fs_guitar] = audioread('guitar1.wav');
[x_vocals, Fs_vocals] = audioread('vocals.wav');

%  +-----------------------------------------------------+
%% | nonlinear                                           |
%  +-----------------------------------------------------+

parameters = [
    5  5; 
    30 30; 
    50 50; 
    15 25;
];

% for vocals
figure('Name', 'vocals-nonlinear');
for parameter_index = 1:size(parameters,1)
    gn = parameters(parameter_index,1);
    gp = parameters(parameter_index,2);
    y_vocals = nonlinear(x_vocals,Fs_vocals,gn,gp,0.3);
    audiowrite(sprintf('results/nonlinear-vocals-%d-%d.wav',gn,gp), y_vocals, Fs_vocals);
    subplot(2, 2, parameter_index);
    specgram(y_vocals);
    title(sprintf('gn=%d gp=%d',gn,gp));
    colorbar; 
    if (verbose)
        disp(sprintf('nonlinear-vocals-%d-%d saved successfully and now playing.',gn,gp));
        soundsc(y_vocals, Fs_vocals);
    end
end

% for guitar
figure('Name', 'guitar-nonlinear');
for parameter_index = 1:size(parameters,1)
    gn = parameters(parameter_index,1);
    gp = parameters(parameter_index,2);
    y_guitar = nonlinear(x_guitar,Fs_guitar,gn,gp,0.3);
    audiowrite(sprintf('results/nonlinear-guitar-%d-%d.wav',gn,gp), y_guitar, Fs_guitar);
    subplot(2, 2, parameter_index);
    specgram(y_vocals);
    title(sprintf('gn=%d gp=%d',gn,gp));
    colorbar;
    if (verbose)
        disp(sprintf('nonlinear-guitar-%d-%d saved successfully and now playing.',gn,gp));
        soundsc(y_guitar, Fs_guitar);
    end
end


%  +-----------------------------------------------------+
%% | rotary                                              |
%  +-----------------------------------------------------+

parameters = [
    800 500 80 50 1.06 0.88;
    650 400 65 40 0.9  0.5;
];

% for vocals
figure('Name', 'vocals-rotary');
for parameter_index = 1:size(parameters,1)
    M1 = parameters(parameter_index,1);
    M2 = parameters(parameter_index,2);
    depth1 = parameters(parameter_index,3);
    depth2 = parameters(parameter_index,4);
    f1 = parameters(parameter_index,5);
    f2 = parameters(parameter_index,6);
    [y_vocals_l,y_vocals_r] = rotary(x_vocals,M1,M2,depth1,depth2,f1,f2,Fs_vocals);
    audio_stereo = [y_vocals_l', y_vocals_r'];
    audiowrite(sprintf('results/rotary-vocals-%d.wav',parameter_index), audio_stereo, Fs_vocals);
    subplot(2, 2, parameter_index);
    % specgram(audio_stereo);
    title(parameter_index);
    colorbar; 
    disp(sprintf('rotary-vocals-%d saved successfully and now playing.',parameter_index));
    % if (verbose)
        % sound(y_vocals_l, Fs_vocals);
    % end
end

% % for guitar
% figure('Name', 'Guitar-nonlinear');
% for parameter_index = 1:size(parameters,1)
%     gn = parameters(parameter_index,1);
%     gp = parameters(parameter_index,2);
%     y_guitar = nonlinear(x_guitar,Fs_guitar,gn,gp);
%     audiowrite(sprintf('results/nonlinear-guitar-%d-%d.wav',gn,gp), y_guitar, Fs_guitar);
%     subplot(2, 2, parameter_index);
%     specgram(y_vocals);
%     title(sprintf('gn=%d gp=%d',gn,gp));
%     colorbar;
%     disp(sprintf('nonlinear-guitar-%d-%d saved successfully and now playing.',gn,gp));
%     if (verbose)
%         soundsc(y_guitar, Fs_guitar);
%     end
% end




%  +-----------------------------------------------------+
%% | Schroeder Reverberator                              |
%  +-----------------------------------------------------+

% vocals
figure('Name', 'vocals-reverb');
% type 1
y_reverb_vocals_type_1 = reverb_schroeder(x_vocals,1,0.3);
audiowrite('results/reverb-vocals-type1.wav', y_reverb_vocals_type_1, Fs_vocals);
subplot(1, 2, 1);
specgram(y_reverb_vocals_type_1);
title("type 1");
colorbar; 
if (verbose)
    disp('reverb-vocals-type1 saved successfully and now playing.');
    soundsc(y_reverb_vocals_type_1, Fs_vocals);
end

% type 2
y_reverb_vocals_type_2 = reverb_schroeder(x_vocals,2,0.3);
audiowrite('results/reverb-vocals-type2.wav', y_reverb_vocals_type_1, Fs_vocals);
subplot(1, 2, 2);
specgram(y_reverb_vocals_type_2);
title("type 2");
colorbar; 
if (verbose)
    disp('reverb-vocals-type2 saved successfully and now playing.');
    soundsc(y_reverb_vocals_type_2, Fs_vocals);
end

% guitar
figure('Name', 'guitar-reverb');
% type 1
y_reverb_guitar_type_1 = reverb_schroeder(x_guitar,1,0.3);
audiowrite('results/reverb-guitar-type1.wav', y_reverb_guitar_type_1, Fs_guitar);
subplot(1, 2, 1);
specgram(y_reverb_guitar_type_1);
title("type 1");
colorbar; 
if (verbose)
    disp('reverb-guitar-type1 saved successfully and now playing.');
    soundsc(y_reverb_guitar_type_1, Fs_guitar);
end

% type 2
y_reverb_guitar_type_2 = reverb_schroeder(x_guitar,2,0.3);
audiowrite('results/reverb-guitar-type2.wav', y_reverb_guitar_type_2, Fs_guitar);
subplot(1, 2, 2);
specgram(y_reverb_guitar_type_2);
title("type 2");
colorbar; 
if (verbose)
    disp('reverb-guitar-type2 saved successfully and now playing.');
    soundsc(y_reverb_guitar_type_2, Fs_guitar);
end


%  +-----------------------------------------------------+
%% | Bonus combining all filters                         |
%  +-----------------------------------------------------+

% nonlinear -> rotary -> reverb



% reverb -> nonlinear -> rotary


pause;