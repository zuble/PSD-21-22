function [Speed] = wind( Wspeed, T );
% Usage:  [Speed] = wind( Wspeed, temperature )
%
% Calculates the wind speed based on the phase difference
% of the signals arriving to two oposite receivers and the air
% temperature equal to 20º C. The argument T is the air temperature
% used to simulate the signals arriving to the receivers. The distance
% between the transmitter and the receivers is set to 7 cm. 
% this value cannot be changed as it is embedded in some constants
% throughout the code.
%         Arguments are: 
%            Wspeed:      wind speed component along sensors
%            T:           air temperature to compute the sound speed
%         Return values:
%            Speed:       wind speed computed for T = 20 degrees
%---------------------------------------------------------------------

% Set to 1 to enable plotting and printing some intermediate results:
disp = 1;

% Sound speed for temperature T:
sound_speed = 331.3 + (0.6 * T);  % m/s

% Distance between TX and RX (TX at center)
% *** DO NOT CHANGE THIS ***
D = 0.07;

% Frequency and period of TX signal, Hz:
Fx = 15000;  % USE THIS FOR THE LAB CLASS on Monday, 14h
Fx = 18000;  % USE THIS FOR THE LAB CLASS on Monday, 16h
Fx = 21000;  % USE THIS FOR THE LAB CLASS on Tuesday, 14h
Ttx = 1/Fx;  % period of transmitted signal, seconds

% Sampling frequency:
Fs = 100000;

% Plot length, # of samples:
Nplot = 40;

% Time vector (10 ms)
t=0:1/Fs:0.01;

%---------------------------------------------------------------------
% The transmitter placed at mid distance between the two receivers
% tramsitts a continuous sine wave of frequency Fx.


%---------------------------------------------------------------------
% Compute the true phase difference, assuming TX has phase 0. 
% Assume the phase difference never wraps 1/2 of the period or 180 dgr.
% Calculate the phase in degrees:
phaseuw = mod( D / (sound_speed-Wspeed), Ttx ) / Ttx * 360;       % Upwind
phasedw = mod( D / (sound_speed+Wspeed), Ttx ) / Ttx * 360 - 360; % Downwind


% The signal received will have some attenuation but the phase difference
% between them should not be sensible to that:
attuw = 0.8;
attdw = 0.9;

%---------------------------------------------------------------------
% The signals received at the upwind and downwind receivers:
% simulates twop oposite outputs of module 'rxreceiver' (eg. rx1 and rx3)
rxuw = attuw * sin(2*pi*Fx*t - phaseuw * pi / 180);
rxdw = attdw * sin(2*pi*Fx*t - phasedw * pi / 180);

if ( disp )
    figure(1);
    plot( t(1:Nplot), rxuw(1:Nplot), '.-');
    hold on;
    plot( t(1:Nplot), rxdw(1:Nplot), '.-');
    grid on;
    hold off;
    xlabel('Time (us)');
    ylabel('Amplitude (normalized to [-1,+1])');
end

% Quantize to Nbitsrx:
Nbitsrx = 12;
rxuw = round( rxuw * 2^(Nbitsrx-1) ) / 2^(Nbitsrx-1);
rxdw = round( rxdw * 2^(Nbitsrx-1) ) / 2^(Nbitsrx-1);


%---------------------------------------------------------------------
% Calculate the imaginary component of each received signal using a Hilbert
% FIR filter of order 8, with the coefficients quantized to 8 fraccional bits.
% This simulates the output of modules 'realtocpx' that output the real and
% imaginary components of the complex representation of the received
% signals.
Hfo = 8;
grd = Hfo/2 ;
NbitsHF = 8;
d = designfilt('hilbertfir','FilterOrder', Hfo, 'TransitionWidth',0.1*Fs,'SampleRate',Fs); 
Htf = round(d.Coefficients * 2^(NbitsHF-1)) / 2^(NbitsHF-1);

if ( disp)
    figure(2);
    freqz( Htf );
end

rxuwim = conv( rxuw, Htf );
rxdwim = conv( rxdw, Htf );

% Received signals in complex form:
cpxrxuw = rxuw + rxuwim(grd+1:end-grd).*j;
cpxrxdw = rxdw + rxdwim(grd+1:end-grd).*j;

if ( disp )
    figure(3);
    plot( abs ( cpxrxuw(1:Nplot) ), '.-' );
    grid on;
    ylabel('Amplitude of signal upwind');
end

%---------------------------------------------------------------------
% Calculate the phase difference in degrees and quantize to 6 fraccional
% bits. This simulates modules 'phasecalc' and 'phasediff'
phasediffcpx = ( angle( cpxrxdw ) - angle( cpxrxuw ) ) * 180 / pi;

% Quantize to Nbitsph fractional bits (8 integer bits required for the range -64,+63):
Nbitsph = 6;
phasediffcpx = round( phasediffcpx * 2^( Nbitsph-1 ) ) / 2^( Nbitsph-1 );

% Wrap angle to [-180, +180]
for i=1:length( phasediffcpx )
if ( phasediffcpx(i) > 180 )
    phasediffcpx(i) = phasediffcpx(i) - 360;
else
    if ( phasediffcpx(i) < -180 )
        phasediffcpx(i) = phasediffcpx(i) + 360;
    end
end
end

if ( disp )
  figure(4);
  plot( phasediffcpx(2*Hfo:2*Hfo+8*round(Fs/Fx)-1), '.-' );
  grid on;
  ylabel('Phase difference (dgr)');
end


%---------------------------------------------------------------------
% Average the phase difference along 8 times the factor Fs/Fx, convert to
% time (us) and convert the time difference to the wind speed using a
% linear approximation that considers the air temperature equal to 20ºC
% This code simulates the module 'phase2speed'
Phase = mean( phasediffcpx(2*Hfo:2*Hfo+8*round(Fs/Fx)-1) );

% Delta time between the two sensors:
delta_t = (Phase/360) * (1/Fx); % thi sis: phase_in_dgr * (PERIOD / 360)

% delta time in micro-seconds:
delta_t_us = delta_t * 1e6;

% Quantize to Nbitsdt:
Nbitsdt = 12;
delta_t_us = round( delta_t_us * 2^(Nbitsdt-1) ) / 2^(Nbitsdt-1);

% To calculate the wind speed we need to solve the following 
% equation in order to wind_speed:
%
% delta_t = D / ( sound_speed - wind_speed ) - D / ( sound_speed + wind_speed )
% 
% Solution is:
% wind_speed = [ 2*D - 2*sqrt( D^2 + (delta_t * sound_speed)^2 ) ] / ( -2*delta_t )
%
% Considering a fixed value for the temperature equal to 20 degrees this
% can be approximated by a lLinear approximation with delta time in us:
% wind_speed = 0.842 * (delta_t_us);

% Numer of fractional bits to represent the slope of the linear approximation:
Nbits_slope = 10;
Speed = ( round( 0.842 * 2^(Nbits_slope-1) ) * delta_t_us ) / 2^(Nbits_slope-1);

if ( disp )
  fprintf('angle( uw ) - angle( dw ) = %10.8f,   Speed = %10.8f\n', Phase, Speed );
end


return;
