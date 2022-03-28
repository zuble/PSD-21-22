% Generate sine wave to hex file:
sinehexfile = '../simdata/sine.hex';
nsamples = 30;
periods = 2;
amp = 300;
x = int32( sin( (0:nsamples*periods) / nsamples * 2 * pi ) * amp );

plot(x,'.-');
grid on;

fpsine = fopen(sinehexfile,'w+');
for i=1:nsamples*periods+1
    if ( x(i) >=0 )
      fprintf(fpsine, '%05X\n', x(i) );
    else
      fprintf(fpsine, '%05X\n', int32( 2^18 + x(i) ) );    
    end
end

fprintf('Wrote %d samples.\n', nsamples*periods );