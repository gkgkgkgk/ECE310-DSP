clc;
clear;
close all;


load projIA;

play = false;
playNoise(speech, play, fs);
generateGraphNumDen(100,b, a, "N = 1");

y = filter(b, a, speech);
playNoise(y, play, fs); % there is no audible distortion with the all pass filter when N = 1

%% DF1
df1 = dfilt.df1(b, a);
df1_cascade = dfilt.cascade(repmat(df1, 1, 50));
generateGraph(5000, df1_cascade, 'DF1');

df1filt = filter(df1_cascade, speech);
playNoise(df1filt, play, fs);
%% DF1 SOS
df1sos = dfilt.cascade(repmat(sos(df1), 1, 50));
generateGraph(5000, df1sos, 'DF1 SOS');

df1sosfilt = filter(df1sos, speech);
playNoise(df1sosfilt, play, fs);
%% DF2 SOS
df2 = dfilt.df2(b, a);
df2sos = dfilt.cascade(repmat(sos(df2), 1, 50));
generateGraph(5000, df2sos, 'DF2 SOS');

df2sosfilt = filter(df2sos, speech);
playNoise(df2sosfilt, play, fs);
%% DF2 Transposed SOS
[sos, g] = tf2sos(b, a);
df2sost = dfilt.df2tsos(sos, g);
df2sost = dfilt.cascade(repmat(df2sost, 1, 50));
generateGraph(5000, df2sost, 'DF2 SOS Transpose');

df2sostfilt = filter(df2sost, speech);
playNoise(df2sostfilt, play, fs);

%%
function [] = generateGraphNumDen(samples, b, a, name)
    [ht, t] = impz(b, a, samples);
    [hf, w] = freqz(b, a, samples);
    [grpd, wgrp] = grpdelay(b, a, samples);

    figure();
    subplot(2, 2, 1);
    stem(t, ht);
    title("Impulse Response");

    subplot(2, 2, 2);
    plot(w, 20*log10(abs(hf)));
    title("Magnitude of Freq Response");

    subplot(2, 2, 3);
    plot(w, grpd);
    title("Group Delay");

    subplot(2, 2, 4);
    zplane(roots(b), roots(a))
    sgtitle(name) 
end

function [] = generateGraph(samples, filt, name)
    [ht, t] = impz(filt, samples);
    [hf, w] = freqz(filt, samples);
    [grpd, wgrp] = grpdelay(filt, samples);

    figure();
    subplot(2, 2, 1);
    stem(t, ht);
    title("Impulse Response");

    subplot(2, 2, 2);
    plot(w, 20*log10(abs(hf)));
    title("Magnitude of Freq Response");

    subplot(2, 2, 3);
    plot(w, grpd);
    title("Group Delay");

    subplot(2, 2, 4);
    [z,p] = filt.zpk;
    zplane(z, p)
    sgtitle(name) 
end

function [] = playNoise(y, play, fs)
    if play
        soundsc(y, fs); 
        pause(3);
    end
end

%% Summary
% This script implements an all pass filter and filters a sound file in
% order to test the "folk theorem" that all pass filters do not cause any
% type of audible distortion. First, the sound is passed through a
% first-order all pass filter. There is no audible distortion here, so we
% further the test by passing it to more all pass filters. For DF1, the
% Matlab dfilt.df1 function is used to create a DF1 implementation of the
% all pass filter. Additionally, it is cascaded 50 times. With this all
% pass filter, there is a lot of distortion, and while I can still hear the
% words in the speech file, it becomes very distorted. The same process is
% done for the remaining filters.

