function [M, A] = hwrec2pol( X, Y );
% Usage:  [ M, A ] = hwrec2pol( X, Y );
%         X, Y: rectangular coordinates, float
%         M, A: modulus and angle (degrees), float 
%--------------------------------------------
SERIAL_PORT = 'COM4';
BAUDRATE    = 115200;

xini = round( X * 2^16 )
yini = round( Y * 2^16 )

xb3 = uint8( bitshift( bitand(xini,hex2dec('ff000000')), -24) );
xb2 = uint8( bitshift( bitand(xini,hex2dec('00ff0000')), -16) );
xb1 = uint8( bitshift( bitand(xini,hex2dec('0000ff00')),  -8) );
xb0 = uint8( bitshift( bitand(xini,hex2dec('000000ff')),   0) );

yb3 = uint8( bitshift( bitand(yini,hex2dec('ff000000')), -24) );
yb2 = uint8( bitshift( bitand(yini,hex2dec('00ff0000')), -16) );
yb1 = uint8( bitshift( bitand(yini,hex2dec('0000ff00')),  -8) );
yb0 = uint8( bitshift( bitand(yini,hex2dec('000000ff')),   0) );

clear sp;
sp = serial(SERIAL_PORT,'BaudRate',BAUDRATE );
fopen( sp );

% write command into ioports address 0: operand X
ca = uint8( hex2dec('20')); 
fwrite( sp, ca );
fwrite( sp, xb3 );
fwrite( sp, xb2 );
fwrite( sp, xb1 );
fwrite( sp, xb0 );

% write command into ioports address 1: operand Y
ca = uint8( hex2dec('21')); 
fwrite( sp, ca );
fwrite( sp, yb3 );
fwrite( sp, yb2 );
fwrite( sp, yb1 );
fwrite( sp, yb0 );

% write command into ioports address f: assert start
ca = uint8( hex2dec('2f')); 
fwrite( sp, ca );
fwrite( sp, uint8(255) );
fwrite( sp, uint8(255) );
fwrite( sp, uint8(255) );
fwrite( sp, uint8(255) );

% read command from ioports address 0 (Modulus)
ca = uint8( hex2dec('30')); 
fwrite( sp, ca );
r3 = fread( sp,1 );
r2 = fread( sp,1 );
r1 = fread( sp,1 );
r0 = fread( sp,1 );
% Raw modulus, integer:
Mi     = bitshift(r3,24) + bitshift(r2,16) + bitshift(r1,8) + r0;

% read command from ioports address 1 (Angle)
ca = uint8( hex2dec('31')); 
fwrite( sp, ca );
r3 = fread( sp,1 );
r2 = fread( sp,1 );
r1 = fread( sp,1 );
r0 = fread( sp,1 );
% Raw angle, integer:
Ai     = bitshift(r3,24) + bitshift(r2,16) + bitshift(r1,8) + r0;
fclose( sp );

fprintf('X=%f, Y=%f   Expected: M=%f, A=%f, returned: M=%f, A=%f', ...
       X, Y, abs( X + Y*j), angle( X + Y*j ) * 180 / pi, ...
	   Mi / 2^16,  Ai / 2^24 );

return;