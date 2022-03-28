clear all

% Uncomment the following like to run this script in Octave:
pkg load signal

% Input hex file, 32 bit, two's complement, one data sample per line:
input_fmmpx_hex_file = '../simdata/fmstereo_mpx_golden.hex';

% Output audio file for playing in SDRSharp:
output_IQ_file       = '../IQ_files/FMsample_genbysim.wav';

%-----------------------------------------------------------------
% ************ DO NOT CHANGE ANYTHING BELOW THIS LINE ************
%
% Sampling frequency of the output carrier (DO NOT CHANGE)
Fcs = 192000;

Wcstep = 0;   % DDS step for final central frequency (KEEP THIS EQUAL TO ZERO)

%-----------------------------------------------------------------
% Read input file, convert to signed:
fprintf('---------------------------------------------------\n');
fprintf('Loading input file %s...\n', input_fmmpx_hex_file );

fpin = fopen( input_fmmpx_hex_file, 'r'); 
fmstereo_Kf = int64( fscanf(fpin, '%x') );
Nsamples_in = length( fmstereo_Kf );
for i=1:Nsamples_in
  if ( fmstereo_Kf(i) > 2^31-1 )
    fmstereo_Kf(i) = fmstereo_Kf(i) - 2^32;
  end
end 
fclose( fpin );

fprintf('Read %1d samples\n', Nsamples_in );

% time vector for generating the carrier signal:
t = (0:Nsamples_in-1)';
t = t * 1/Fcs;
tc_max = t( end );
tc = (0:1/Fcs:tc_max)';

% Adjust length of the input signal:
fmstereo_Kf = fmstereo_Kf(1: length( tc ) );

% Length adusted (???)
Nsamples_in = length( fmstereo_Kf );

fprintf('---------------------------------------------------\n');
fprintf('Generating the FM baseband signal...\n');
%% lookup table for the final FM modulator
% DDS parameters:
nsamples_LUT = 128;
nbits = 10;

% The phase step is Wcstep + ( fmstereo_Kf( i ) / 2^13 )
% where Wcstep is zero (for now) and DO NOT TOUCH THE '2^13'

% Time vector:
tx = 1:nsamples_LUT;
sinelut = round( sin( (tx-1)/ nsamples_LUT * 2 * pi ) * (2^(nbits-1)-1) );

% With a sine look-up table with 128 entires and a sampling frequency 
% of 192 kHz, the output frequency of the sinewave is:
%     192000 / 128 * phase_step = 1.5kHz * phase_step
% To achieve a maximum frequency deviation of 50 kHz, the maximum 
% phase step must be +-50k / 1.5k = +-33.3(3) (round down to 32, 6 bits signed)
% As our fmstereo_Kf signal will fit into 20 bits,
% the phase step must be the (integer) fmstereo_Kf signal divided by
% 2^(20-6) = 2^14

% For creating the IQ file required for SDRSharp with need to generate a
% sine and a cosine modulated by the same signal
phase_sin = 0;
phase_cos = nsamples_LUT/4;

phs = zeros(1, Nsamples_in );
phc = zeros(1, Nsamples_in );

for i=1:Nsamples_in
    % Adjust phase:
    phase_sin = mod( phase_sin, nsamples_LUT);
    phase_cos = mod( phase_cos, nsamples_LUT);
    
    phase_sin_index = floor(phase_sin);
    phase_cos_index = floor(phase_cos);
        
    fmstereo_mod_I1(i) = sinelut( phase_sin_index + 1 );
    fmstereo_mod_Q1(i) = sinelut( phase_cos_index + 1 );
    phase_sin = phase_sin  + Wcstep + ( fmstereo_Kf( i ) / 2^13);
    phs(i) = phase_sin_index;
    phase_cos = phase_cos  + Wcstep + ( fmstereo_Kf( i ) / 2^13 );
    phc(i) = phase_cos_index;
    if ( mod(i,48000 ) == 0 )
        fprintf('%d (%3d%%)...\n', i, int32(i*100/Nsamples_in) );
    end
end


fmstereo_mod_I1 = fmstereo_mod_I1 /(2^(nbits-1)-1);
fmstereo_mod_Q1 = fmstereo_mod_Q1 /(2^(nbits-1)-1);


fprintf('---------------------------------------------------\n');
fprintf('Writing IQ file %s...\n', output_IQ_file );
audiowrite(output_IQ_file, [fmstereo_mod_Q1', fmstereo_mod_I1'  ], Fcs );

figure(10);
fftout = abs( fft( double(fmstereo_Kf) ) );
fftout_dB = 20*log10( fftout / max( fftout ) );
plot( (1: floor(length(fmstereo_Kf)/2) )*Fcs/length(fmstereo_Kf )/1000, fftout_dB( 1: floor(length(fmstereo_Kf)/2) ) );
grid on;
va = axis;
va(3) = -80;
axis( va );
title('Spectrum of FM MPX signal');
xlabel('Frequency (kHz)');
ylabel('Amplitude (dB)');

