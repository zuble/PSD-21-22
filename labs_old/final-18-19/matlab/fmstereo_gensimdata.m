clear all

% Uncomment the following like to run this script in Octave:
pkg load signal

%samplefilename = '../audio/COMERCIAL_FM_AUDIO.wav';
samplefilename = '../audio/VIOLIN_and_GUITAR.wav';
%samplefilename = '../audio/VIOLIN.wav';
duration = 0.5;   % duration in seconds for processing input signal

% Set to N to print the first N intermediate results
% (see the end of the program)
PRINT_DEBUG = 5;

%---------------------------------------------
% Gains:
Ks = bin2dec('0100')/2^3;     % left + right: 0100b = 0.100b = 0.5 decimal 
Kd = bin2dec('1000')/2^3;     % left - right: 1000b = 1.000b = 1.0 decimal 
Kp = bin2dec('0100')/2^3;     % 19 kHz pilot: 0100b = 0.100b = 0.5 decimal 
Kf = bin2dec('00100000')/2^4; % modulation factor: 00100000b = 0010.0000b = 2.0 decimal 

% The input hex files with the input stereo audio signal:
inputhexfile_left   = '../simdata/fmstereo_audioin_left.hex';
inputhexfile_right  = '../simdata/fmstereo_audioin_right.hex';

% The output file with the golden sim data before the final DDS:
outputhexfile = '../simdata/fmstereo_mpx_golden.hex';

%-----------------------------------------------------------------
% ************ DO NOT CHANGE ANYTHING BELOW THIS LINE ************
%

% Design parameters:
ifactor = 4;    % interpolation factor for FM stereo mixer
Fs1 = 48000;    % Input audio sampling frequency:
Fs2 = ifactor * Fs1; % upsampled frequency
Nbitsin = 18;   % Number of bits of input signal




%---------------------------------------------
%% Load input audio sample and plot the FFTs
fprintf('---------------------------------------------------\n');
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


fprintf('---------------------------------------------------\n');

%------------------------------------------------
%% Input audio file may have a sample rate different from 48 kHz.
% Resample to Fs1 (set to 48 kHz)
fprintf('Resampling input file from %1d Hz to %2d Hz...\n', Fsin, Fs1);

% Force 1st sample to be zero. This is convenient for the linear
% interpolation process (TBBE)
xin(1,:) = 0;
xin(2,:) = 0;

% Input audio stream will be sampled at Fs1 = 48 kHz:
xin48k = resample( xin, Fs1, Fsin );

fprintf('Normalizing input amplitude.\n');
maxx = max( max( abs( xin48k ) ) );
xin48k = xin48k / (maxx*1.05);  %% Reduce amplitude to 95% of max.


%------------------------------------------------
%% Convert to integer with Nbitsin bits
% these integer data samples vectors will be used 
% to create the input data for the testbench
xin48k = int32( xin48k * (2^(Nbitsin-1)-1) );

fprintf('---------------------------------------------------\n');

%------------------------------------------------
%% Print the hex input files for the left and right channels:
fprintf('Creating left input hex file %s...\n', inputhexfile_left );
fpleft = fopen(inputhexfile_left,'w+');
for i=1:length( xin48k )
    if ( xin48k(i,1) >=0 )
      fprintf(fpleft, '%05X\n', xin48k(i,1) );
    else
      fprintf(fpleft, '%05X\n', int32( 2^Nbitsin + xin48k(i,1) ) );    
    end
end
fclose( fpleft );
fprintf('Wrote %d samples.\n', length(xin48k) );

% print hex file for right channel:
fprintf('Creating right input hex file %s...\n', inputhexfile_right );
fpright = fopen(inputhexfile_right ,'w+');
for i=1:length( xin48k )
    if ( xin48k(i,2) >=0 )
      fprintf(fpright, '%05X\n', xin48k(i,2) );
    else
      fprintf(fpright, '%05X\n', int32( 2^Nbitsin + xin48k(i,2) ) );       
    end
end
fclose( fpright );
fprintf('Wrote %d samples.\n', length(xin48k) );

fprintf('---------------------------------------------------\n');

%------------------------------------------------
%% Sum and difference of the Left and Right channels:
% divide by 2 to scale down to the 18-bit range:
lpr = [ 0; floor( double( ( xin48k(:,1) + xin48k(:,2) ) ) / double( 2 ) ) ];
lmr = [ 0; floor( double( ( xin48k(:,1) - xin48k(:,2) ) ) / double( 2 ) ) ];

%% Multiply by the gains and saturate to the max/min of the
% dynamic range:
lprk = floor( double( lpr ) * double( Ks ) );
lmrk = floor( double( lmr ) * double( Kd ) );

lprk = min( lprk, 2^(Nbitsin-1)-1 );
lprk = max( lprk, -2^(Nbitsin-1)-1 );
lmrk = min( lmrk, 2^(Nbitsin-1)-1 );
lmrk = max( lmrk, -2^(Nbitsin-1)-1 );

% Check if there was saturation:
if ( max( lprk ) == 2^(Nbitsin-1)-1 || min( lprk ) == -2^(Nbitsin-1)-1 )
  fprintf('*** Warning: saturation detected in the L+R channel\n');
end
% Check if there was saturation:
if ( max( lmrk ) == 2^(Nbitsin-1)-1 || min( lmrk ) == -2^(Nbitsin-1)-1 )
  fprintf('*** Warning: saturation detected in the L-R channel\n');
end


%------------------------------------------------
%% Upsample to 192 kHz (Fs2):
fprintf('Upsampling %1dX to %d kHz, using linear interpolation...\n', ifactor, Fs2);


% lpr = [ 0 16 27 39 20];

lpr_d = [0 diff( [lprk(1:end)'] )];
lpr_inta( 1 : ifactor : (length(lpr))* ifactor ) = lpr_d;
lpr_intb = [0 int32( conv( double(lpr_inta), ones(1, ifactor) ) ) ];
lpr_int = floor( double( cumsum( lpr_intb )' ) / double( ifactor)  );
lpr_int = [ lpr_int( 2:end )' , 0 ]';



lmr_d = [0 diff( [lmrk(1:end)'] )];
lmr_inta( 1 : ifactor : (length(lmr))* ifactor ) = lmr_d;
lmr_intb = [0 int32( conv( double(lmr_inta), ones(1, ifactor) ) ) ];
lmr_int = floor( double( cumsum( lmr_intb )' ) / double( ifactor ) );
lmr_int = [lmr_int( 2:end )' , 0 ]';

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
Nsamples_LUT   = 64;
% Number of bits for the fractional phase:
Nfrac = 12; 

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

fprintf('---------------------------------------------------\n');

fprintf('Phase increment for generating 19 kHz is %5.6f\n', delta_phase );
phase = floor( cumsum( [0 ones(1,  Nsamples_in-1 )] * delta_phase ) );

% Now, the 19 kHz cosine vector is formed by the samples of the full LUT
% whose index are the integer phase values:
pilot19k = zeros(1, Nsamples_in );
for i = 1 :  Nsamples_in
    pilot19k(i) = full_LUT( phase(i)+1 );
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
% and the phase vector will also double:
delta_phase = floor( (38000 * Nsamples_LUT / Fs2 ) * 2^Nfrac ) / 2^Nfrac;
phase = floor( cumsum( [0 ones(1,  Nsamples_in-1 )] * delta_phase ) );

fprintf('Phase increment for generating 38 kHz is %5.6f\n', delta_phase );

fprintf('---------------------------------------------------\n');

carrier38k = zeros(1, Nsamples_in );
for i = 1 : Nsamples_in
    carrier38k(i) = full_LUT( phase(i)+1 );
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
% we need to shift-right by (Nbits_sine_LUT)
lmr_int_38k = int32( floor ( (double(lmr_int) .* double(carrier38k') ) / double( 2^(Nbits_sine_LUT) ) ) );

% Signal fmstereo will fit in 20 bits, assuming Kp < 1
% lpr_int = 18 bits, 
% pilot19k <= 18 bits
% lmr_int = 18 bits

% Add components; this will fit in 20 bits:
fmstereo = int32(lpr_int) + int32( floor( double(Kp*pilot19k') * double(2^(Nbitsin - Nbits_sine_LUT - 1 ) ) ) ) + lmr_int_38k;

pilot19k_k = int32( floor( double(Kp*pilot19k') * double(2^(Nbitsin - Nbits_sine_LUT - 1 ) ) ) );

% Multiply the fmstereo signal by the gain Kf and trunc to integer
fmstereo_Kf = int32( floor( double(fmstereo) * double(Kf) ) );

fmstereo_Kf = [ 0, fmstereo_Kf(1:end-1)' ]';

% max Kf = 1111.1111, fmstereo signal will fit in 25 bits:
Noutputsamples = length( fmstereo_Kf );
Nbits_FMMPX    = 32;


%% Output the golden data before the final DDS:
fpout = fopen( outputhexfile, 'w+');

fprintf('Writing %1d samples, signed %2d bits, to output hex file %s...\n', ...
                          Noutputsamples, Nbits_FMMPX, outputhexfile );
for i=1:Noutputsamples
    if fmstereo_Kf(i) < 0
        fprintf( fpout, '%08x\n', 2^Nbits_FMMPX + int64(fmstereo_Kf(i)) );
    else
        fprintf( fpout, '%08x\n', int64(fmstereo_Kf(i)) );
    end
    if ( mod(i,48000 ) == 0 )
        fprintf('%d (%3d%%)...\n', i, int32(i*100/Noutputsamples) );
    end
end

fclose( fpout );

    
%% Print debug data for the first NS=20 samples:

for i=0:PRINT_DEBUG*4-1
    if ( mod(i,4) == 0 )
        j = floor( i / 4 + 1 );

        fprintf('48K Cycle %3d: L+R=%6d  L-R=%6d  (L+R)*Ks=%6d  (L-R)*Kd=%6d\n', ...
	                            j, lpr(j), lmr(j), lprk(j), lmrk(j) );
    end
    ii = i + 1;
    fprintf('      192K Cycle %3d: L+R inter=%6d  L-R interp=%6d  19k=%6d  38k=%6d  Pilot=%6d  LmR38k=%6d  FM=%7d\n',...
	             ii, lpr_int(ii), lmr_int(ii), pilot19k(ii), carrier38k(ii), pilot19k_k(ii), lmr_int_38k(ii), fmstereo_Kf(ii) );
end





