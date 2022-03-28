clear all

% Uncomment the following like to run this script in Octave:
% pkg load signal


samplefilename = '../audio/VIOLIN.wav';
duration = 1;   % duration in seconds for processing input signal

% Set to N to print the first N intermediate results
% (see the end of the program)
PRINT_DEBUG = 5;

% The input hex files with the input stereo audio signal:
inputhexfile_left   = '../simdata/audioin_left.hex';
inputhexfile_right  = '../simdata/audioin_right.hex';
outputlefthexfile   = '../simdata/output_left_golden.hex';
outputrighthexfile  = '../simdata/output_right_golden.hex';


%-----------------------------------------------------------------
% ************ DO NOT CHANGE ANYTHING BELOW THIS LINE ************
%

% Design parameters:
Fs = 48000;     % Input audio sampling frequency:
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
% Resample to Fs (set to 48 kHz)
fprintf('Resampling input file from %1d Hz to %2d Hz...\n', Fsin, Fs);

% Force 1st sample to be zero. This is convenient for the linear
% interpolation process (TBBE)
xin(1,:) = 0;
xin(2,:) = 0;

% Input audio stream will be sampled at Fs1 = 48 kHz:
xin48k = resample( xin, Fs, Fsin );

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


% create the output signal: in this example the output is the average of the inputs (mono)
xsumout48k = floor( double( ( xin48k( :,1 ) + xin48k( :,2 ) ) ) / 2 );
xdifout48k = floor( double( ( xin48k( :,1 ) - xin48k( :,2 ) ) ) / 2 );
Noutputsamples = length( xin48k );
Nbitsout = Nbitsin;

%% Output the golden output data:
fpoutleft  = fopen( outputlefthexfile, 'w+');
fpoutright = fopen( outputrighthexfile, 'w+');

fprintf('Writing %1d samples, signed %2d bits, to output hex files %s, %s...\n', ...
                 Noutputsamples, Nbitsout, outputlefthexfile, outputrighthexfile );
for i=1:Noutputsamples
    if xsumout48k(i) < 0
        fprintf( fpoutright, '%05x\n', 2^Nbitsout + int64(xsumout48k(i)) );
    else
        fprintf( fpoutright, '%05x\n', int64(xsumout48k(i)) );
    end
    
    if xdifout48k(i) < 0
        fprintf( fpoutleft, '%05x\n', 2^Nbitsout + int64(xdifout48k(i)) );
    else
        fprintf( fpoutleft, '%05x\n', int64(xdifout48k(i)) );
    end
    
    
    if ( mod(i,48000 ) == 0 )
        fprintf('%d (%3d%%)...\n', i, int32(i*100/Noutputsamples) );
    end
end

fclose( fpoutright );
fclose( fpoutleft );

    



