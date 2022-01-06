%% Verification
y=srconvert([1 zeros(1,3000)]);
verify(y);

%% Audio file upsampling
x = audioread('Wagner.wav');
y = srconvert(x);
audiowrite('WagnerUp.wav', y, 24000);

%% Functions

% https://www.mathworks.com/help/signal/ref/designfilt.html
function f = lpf(wpass, wstop)
f = designfilt('lowpassfir','PassbandFrequency',wpass, ...
         'StopbandFrequency',wstop,'PassbandRipple',0.1, ...
         'StopbandAttenuation',75,'DesignMethod','kaiserwin');
end

function [out] = srconvert(in)
% takes signal with sampling rate of 11,025Hz and converts the sampling
% rate to 24KHz

[L, M] = rat(24000/11025);
wc = min(1/L, 1/M);
f = lpf(wc, 1.2*wc);

tic
s = upsample(in, L);
s = fftfilt(f, s);

out = M*downsample(s, M);
toc
end

%% Summarization
% This script uses a low pass filter to covert the sampling rate of an audio file
% using the simple implementation of upsampling, filtering, and then downsampling.
% Upsampling and downsampling factors are given by the ratio L/M, which represents the smallest integer ratio between the sampling rates.
% First, the input signal is upsampled by factor L.
% Then, the audio file is put through a low pass filter.
% The low pass filter is designed to get rid of artifacts from
% upsampling. The signal is now downsampled by M, so that the original
% speed of the audio signal is preserved, and scaled by M, so the original
% energy/amplitude of the signal is preserved. Finally, the signal is
% written to a new audio file with the new sampling rate of 24kHz.