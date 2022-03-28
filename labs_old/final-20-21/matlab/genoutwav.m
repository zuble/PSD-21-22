lr = load('../simdata/audioout.dat');
Nbits = 18;
% Normalize to [-1, +1]:
lr(:,1) = lr(:,1) / (2^(Nbits-1)-1);
lr(:,2) = lr(:,2) / (2^(Nbits-1)-1);
audiowrite( '../audio/simaudioout.wav', lr, 48000 );