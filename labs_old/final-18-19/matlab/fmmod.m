clear all

% Uncomment the following like to run this script in Octave:
pkg load signal

samplefilename = '../audio/Song.wav';
%samplefilename = '../audio/VIOLIN_and_GUITAR.wav';
%samplefilename = '../audio/VIOLIN.wav';
duration = 10;  % duration in seconds for processing input signal
ifactor = 4;    % interpolation factor for FM stereo mixer
Fs1 = 48000;    % Input audio sampling frequency:
Fs2 = ifactor * Fs1; % upsampled frequency
Nbitsin = 18;   % Number of bits of input signal

%---------------------------------------------
% Gains:
Ks = 1.0;     % left + right
Kd = 1.0;     % left - right
Kp = 0.2;   % 19 kHz pilot
Kf = 4.0;     % modulation factor
Wcstep = 1;     % DDS step for final central frequency

%---------------------------------------------
%% Load input audio sample and plot the FFTs
fprintf('Loading audio file ''%s''\n', samplefilename );
[xin , Fsin] = audioread( samplefilename );

% Use only a subpart of the input signal:
if ( duration * Fsin < length( xin ) )
  xin = xin(1:duration*Fsin,:);
end

sizex = size(xin);
nsamplesin = length( xin );

fprintf('Read %d samples (%4.1f secs), %1d channels, input sampling frequency is %d Hz\n', ...
                                        length(xin), length(xin)/ Fsin, sizex(2), Fsin );
fprintf('   Max amplitude is %4.1f%% of the 18 bit dynamic range\n', ...
                                        (100 * max ( max( abs( xin ) ) ) ) );
if ( sizex(2) ~= 2 )
    fprintf('File format error: input signal is mono, exiting.\n');
    return;
end

fprintf('Normalizing input amplitude.\n');
maxx = max( max( abs( xin ) ) );
xin = xin / maxx;


%% FFT of the left and right channels:
%fftleft  = 20*log10( abs ( fft( xin(1:2^NbitsFFT,1) ) ) );
%fftright = 20*log10( abs ( fft( xin(1:2^NbitsFFT,2) ) ) );
%% Frequency vector:
%f = linspace( 0, Fsin/2, 2^(NbitsFFT-1) );
%figure( 1 );
%subplot( 2, 1, 1 );
%plot( f, fftleft(1:end/2) );
%title('Spectrum of input signal');
%xlabel('Frequency ( Hz)');
%ylabel('Amplitude left (dB)');
%grid on;
%subplot( 2, 1, 2 );
%plot( f, fftright(1:end/2) );
%xlabel('Frequency ( Hz)');
%ylabel('Amplitude right (dB)');
%grid on;
%%-----------------------------------------------


%------------------------------------------------
%% Input audio file may have a sample rate different from 48 kHz.
% Resample to Fs1 (set to 48 kHz)
fprintf('Resampling input file from %1d Hz to %2d Hz...\n', Fsin, Fs1);

% Force 1st sample to be zero. This is convenient for the linear
% interpolation process (TBBE)
xin(1,:) = 0;

% Input audio stream will be samples at Fs1 = 48 kHz:
xin48k = resample( xin, Fs1, Fsin );


%------------------------------------------------
%% Convert to integer with Nbitsin bits
% these integer data samples vectors will be used 
% to create the input data for the testbench
xin48k = int32( xin48k * (2^(Nbitsin-1)-1) );


%------------------------------------------------
%% Sum and difference of the Left and Right channels:
% divide by 2 to scale down to the 18-bit range:
lpr = [0 ; floor( ( xin48k(:,1) + xin48k(:,2) ) / 2 ) ];
lmr = [0 ; floor( ( xin48k(:,1) - xin48k(:,2) ) / 2 ) ];

%% Multiply by the gains and saturate to the max/min of the
% dynamic range:
lpr = floor( lpr *  Ks );
lmr = floor( lmr *  Kd );
lpr = min( lpr, 2^(Nbitsin-1)-1 );
lpr = max( lpr, -2^(Nbitsin-1)-1 );
lmr = min( lmr, 2^(Nbitsin-1)-1 );
lmr = max( lmr, -2^(Nbitsin-1)-1 );

% Check if there was saturation:
if ( max( lpr ) == 2^(Nbitsin-1)-1 || min( lpr ) == -2^(Nbitsin-1)-1 )
  fprintf('*** Warning: saturation detected in the L+R channel\n');
end
% Check if there was saturation:
if ( max( lmr ) == 2^(Nbitsin-1)-1 || min( lmr ) == -2^(Nbitsin-1)-1 )
  fprintf('*** Warning: saturation detected in the L-R channel\n');
end


%------------------------------------------------
%% Upsample to 192 kHz (Fs2):
fprintf('Upsampling %1dX to %d kHz, using linear interpolation...\n', ifactor, Fs2);

lpr_d = diff( [0 lpr(1:end-1)'] );
lpr_int( 2 : ifactor : (length(lpr)-1)* ifactor ) = lpr_d;
lpr_int = int32( conv( double(lpr_int), ones(1, ifactor) ) );
lpr_int = floor( cumsum( lpr_int )' / ifactor );

lmr_d = diff( [0 lmr(1:end-1)'] );
lmr_int( 2 : ifactor : (length(lmr)-1)* ifactor ) = lmr_d;
lmr_int = int32( conv( double(lmr_int), ones(1, ifactor) ) );
lmr_int = floor( cumsum( lmr_int )' / ifactor );

%% In Matlab there is the function resample
%lpr_int = int32( floor( resample( double(lpr), Fs2, Fs1 ) ) );
%lmr_int = int32( floor( resample( double(lmr), Fs2, Fs1 ) ) );

% Number of 192 KHz samples:
Nsamples_in = length( lpr_int );

figure(2);
subplot(2,1,1);
plot( lpr_int(1:400), '.-');
hold on;

title('Input signal before and after linear interpolation');
plot( 1 : ifactor : length( lpr(1:100) )* ifactor , lpr(1:100) , '.-' );
xlabel('Sample index (L+R)');
grid on;
hold off;

subplot(2,1,2);
plot( lmr_int(1:400), '.-');
hold on;
plot( 1 : ifactor : length( lmr(1:100) )* ifactor , lmr(1:100) , '.-' );
xlabel('Sample index (L-R)');
grid on;
hold off;



%------------------------------------------------
%% Generate the two sine waves (19kHz and 38 kHz)
% To generate these waveforms we use a discrete 
% model implementing the same process as a digital DDS:

% Parameters to the DDS are:
% Number of bits per sample in lookup-table
Nbits_sine_LUT = 8;
% Number of samples for the lookup-table:
Nsamples_LUT   = 128;
% Number of bits for the fractional phase:
Nfrac = 6; 

% Build the lookup-table:
sine_LUT = round( sin( (0:Nsamples_LUT-1) / Nsamples_LUT * 2 * pi ) * (2^(Nbits_sine_LUT-1)-1) );

figure(3);
plot( sine_LUT ,'.-'); grid on;
title('Lookup table for the 19 kHz / 38 kHz tone generator');
xlabel('Sample index');
ylabel('Amplitude');

% Extend the LUT to fit the whole duration of the input signal:
% the expression ceil(38000 * Nsamples_LUT / Fs2 ) gives the 
% increase in length needed to have a sine LUT long enough for the 
% phase increment given by (38000 * Nsamples_LUT / Fs2)
full_LUT = zeros( 1, Nsamples_in * ceil( 38000 * Nsamples_LUT / Fs2 ) );
full_LUT(1 : Nsamples_LUT : Nsamples_in * ceil( 38000 * Nsamples_LUT / Fs2 ) ) = 1;
full_LUT = floor( conv( full_LUT, sine_LUT ) );

% compute the phase vector to generate the 19 kHz signal:
% with a sampling frequency of 192 kHz and a 128-sample LUT,
% we need a phase increment for each sampling period equal to:
%           19000 * 128 / 192000 = 12.6(6)
% Considering Nfrac bits to represent the fractional part of the phase,
% the instantaneous fixed-point phase is computed as:
%   delta_phase  = floor( 12.6(6) * 2^Nfrac ) / 2^Nfrac
%   phase        = ACCUM ( delta_phase )
% The index to the sine look-up table is the integer part of the 
% fractional phase:
%   index to LUT = floor( phase );
%

delta_phase = floor( (19000 * Nsamples_LUT / Fs2 ) * 2^Nfrac ) / 2^Nfrac;

fprintf('Phase increment for generating 19 kHz is %5.6f\n', delta_phase );
phase = floor( cumsum( ones(1,  Nsamples_in ) * delta_phase ) );

% Now, the 19 kHz cosine vector is formed by the samples of the full LUT
% whose index are the integer phase values:
pilot19k = zeros(1, Nsamples_in );
for i = 1 :  Nsamples_in
    pilot19k(i) = full_LUT( phase(i) );
end

figure(4)
subplot(2,1,1);
fft_pilot19k = abs( fft ( pilot19k(1:8192) ) ) ;
plot( (1:8192/1) / 8192 * 192000,fft_pilot19k(1:end/1), '.-'); grid on;
ylabel('Amplitude');
xlabel('Frequency (Hz)');
title('Spectrum of 19 kHz sine wave');

% use the same LUT to generate the 38 kHz sine wave:
% as the frequency is exacly the double, the phase increment will double
% and the phse vector will also double:
delta_phase = floor( (38000 * Nsamples_LUT / Fs2 ) * 2^Nfrac ) / 2^Nfrac;
phase = floor( cumsum( ones(1,  Nsamples_in ) * delta_phase ) );

fprintf('Phase increment for generating 38 kHz is %5.6f\n', delta_phase );

carrier38k = zeros(1, Nsamples_in );
for i = 1 : Nsamples_in
    carrier38k(i) = full_LUT( phase(i) );
end

subplot(2,1,2);
fft_carrier38k = abs( fft ( carrier38k(1:8192) ) ) ;
plot( (1:8192/1) / 8192 * 192000, fft_carrier38k(1:end/1), '.-'); grid on;
ylabel('Amplitude');
xlabel('Frequency (Hz)');
title('Spectrum of 38 kHz sine wave');


%% Modulate the L-R component to 38 kHz
% and adjust scale to keep in the 18 bit range:
% The carrier has Nbits_sine_LUT bits, the lmr_int has 18 bits
% the product has (18 + Nbits_sine_LUT )
% we need to shift-right by (Nbits_sine_LUT-1)
lmr_int_38k = int32( floor ( (double(lmr_int) .* double(carrier38k') ) / 2^(Nbits_sine_LUT-1) ) );

nsamples = length( lpr_int );

% Signal fmstereo will fit in 20 bits, assuming Kp < 1
% lpr_int = 18 bits, 
% pilot19k <= 18 bits
% lmr_int = 18 bits

% Add components:
fmstereo = lpr_int + int32( floor( Kp*pilot19k'*2^(Nbitsin - Nbits_sine_LUT - 1 ) ) ) + lmr_int_38k;

% Multiply the fmstereo signal by the gain Kf:
% assume Kf < 1
fmstereo_Kf = floor( fmstereo * Kf );


% Sampling frequency of the carrier:
Fcs = Fs2;


% time vector for generating the carrier signal:
t = (0:Nsamples_in-1)';
t = t * 1/Fs2;
tc_max = t( end );
tc = (0:1/Fcs:tc_max)';

fmstereo_Kf = fmstereo_Kf(1: length( tc ) );


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

phs = zeros(1, length( fmstereo_Kf ) );
phc = zeros(1, length( fmstereo_Kf ) );

for i=1:length(fmstereo_Kf)
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
end

fmstereo_mod_I1 = fmstereo_mod_I1 /(2^(nbits-1)-1);
fmstereo_mod_Q1 = fmstereo_mod_Q1 /(2^(nbits-1)-1);

%---------------------------
%npoints = 10000;
%figure(1); plot( sinelut, '.-'); grid on;
%figure(5); plot( fmstereo_Kf(1:npoints), '.-' ); grid on;
%figure(6); plot( phs(1:npoints), '.-' ); grid on;
%figure(7); plot( fmstereo_mod_I1(1:npoints), '.-' ); grid on;
%---------------------------

fprintf('Writing...\n');
audiowrite('../audio/FMsample.wav', [fmstereo_mod_Q1', fmstereo_mod_I1'  ], Fcs );

figure(10);
fftout = 20*log10( abs( fft( double(fmstereo_Kf) ) ) );
plot( (1:length(fmstereo_Kf)/2)*Fs2/length(fmstereo_Kf ), fftout( 1:length(fmstereo_Kf)/2 ) );
grid on;
title('Spectrum of FM MPX signal');

