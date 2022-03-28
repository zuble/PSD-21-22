clear all
format long

% Uncomment the following like to run this script in Octave:
pkg load signal

% The following hex files can be read by the Verilog testbench with 
% the Verilog system task $readmemh()

%% define the parameters:
%
% Output file with the sine wave for the input frequency:
outputhexfile = '../simdata/DDSout.hex';

% Lookup-table for the DDS
DDSLUTfile    = '../simdata/DDSLUT.hex';

% Duration of the output test signal (seconds):
duration = 0.1;  

% Sampling frequency (Hz):
Fs = 192000;

% Output frequency (Hz):
Fout = 38000;

% Number of bits per sample in lookup-table
Nbits_sine_LUT = 8;

% Number of samples in the lookup-table:
% This should be an integer power of 2
Nsamples_LUT   = 64;

% Number of bits of the fractional phase:
% note that the number of bits in the integer part of the
% phase is given by log2( NsamplesLUT )
Nfrac = 12; 

%% Build the lookup-table:memory
sine_LUT = round( sin( (0:Nsamples_LUT-1) / Nsamples_LUT * 2 * pi ) * (2^(Nbits_sine_LUT-1)-1) );

figure(1);
plot( sine_LUT ,'.-'); grid on;
thistitle = sprintf('Sin(x) lookup table: %1d samples, %1d bit per sample', Nsamples_LUT, Nbits_sine_LUT );
title(thistitle);
xlabel('Sample index');
ylabel('Amplitude');

%% Write hex file with the LUT data:
fpout = fopen( DDSLUTfile, 'w+');

for i=1:Nsamples_LUT
    if sine_LUT(i) < 0
        fprintf( fpout, '%04x\n', int16( 2^Nbits_sine_LUT + sine_LUT(i) ) );
    else
        fprintf( fpout, '%04x\n', int16( sine_LUT(i) ) );
    end
end

fclose( fpout );

%% Generate a test signal with Fout frequency:
% the fractional delta_phase is truncated to the number of fractional bits
% defined in Nfrac:
delta_phase = floor( (Fout * Nsamples_LUT / Fs ) * 2^Nfrac ) / 2^Nfrac;

fprintf('Delta phase to generate %1d Hz is %10.7f (binary: %s.%s)\n\n', ...
          Fout, delta_phase, ...
          dec2bin( floor( delta_phase ), log2(Nsamples_LUT) ), ...
          dec2bin( ( delta_phase - floor( delta_phase ) ) * 2^Nfrac, Nfrac ) );


%% Generate the output vector for the duration set:

% Time vector:
t = linspace(0, duration, floor(Fs*duration) );

% Number of samples:
Nsamples = length( t );

% output data vector:
output_sine_wave = zeros(1, Nsamples );

% Instantaneous phase:
phase = 0;

for i=1:Nsamples
    
    % wrap phase accumulator
    phase = mod( phase, Nsamples_LUT);
    
    % Use as the index for the LUT the integer part of the phase:
    % Note the "+ 1" because Matlab vectors start with index 1...
    LUT_index = floor(phase) + 1; 
    output_sine_wave(i) = sine_LUT( LUT_index );
    
    % Increment phase 
    phase = phase + delta_phase;
end

% Plot the first 10 periods of the output signal
figure(2);
plot( t(1: floor( 10 * Fs / Fout))*1000, output_sine_wave(1:floor( 10 * Fs / Fout)), '.-');
grid on;
thistitle = sprintf('The first 10 periods of the output sine wave');
title(thistitle);
xlabel('Time (ms)');
ylabel('Integer amplitude');

%% Plot the FFT of the output signal
figure(3);
NpointsFFT = min( 16384, Nsamples );
fftout = abs( fft( hamming(NpointsFFT)' .* output_sine_wave(1:NpointsFFT) ) );
fftout = fftout / max( fftout );

% Vector of frequencies:
freqs = (0:NpointsFFT-1) / NpointsFFT * Fs;
plot( freqs(1:NpointsFFT/2), 20*log10( fftout(1:NpointsFFT/2) ) );
axis( [ 0 freqs(end/2) -100 1] );
grid on;
thistitle = sprintf('Spectrum of %1d Hz sine wave', Fout );
title(thistitle);
xlabel('Frequency (Hz) - max is Fs/2');
ylabel('Normalized amplitude (dB)');

%% Create the output hex file for the verification:
% Write hex file with the LUT data, using 32-bit output samples
% truncate in the testbench for the appropriate bit width
fpout = fopen( outputhexfile, 'w+');

for i=1:Nsamples
    if output_sine_wave(i) < 0
        fprintf( fpout, '%08x\n', int32( 2^Nbits_sine_LUT + output_sine_wave(i) ) );
    else
        fprintf( fpout, '%08x\n', int32( output_sine_wave(i) ) );
    end
end

fclose( fpout );
