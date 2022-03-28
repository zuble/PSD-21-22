LUTcalib = zeros(16,2);
endereco_sup = 16;
endereco_inf = 1;
midpoint = 0;
flag = 0;
x=0.1
for c = 1:8
   LUTcalib(9-c,1) = sin(-pi*c/180);
   LUTcalib(c+8,1) = sin(pi*c/180);
end

for c = 1:4
    midpoint = floor((endereco_sup + endereco_inf)/2)
    if(LUTcalib(midpoint, 1) < x)
        endereco_inf = midpoint 
    elseif(LUTcalib(midpoint, 1) > x)
        endereco_sup = midpoint
    else
        flag = 1;
        break; 
    end

end
%if(flag == 1)
    %valor que se encontra em midpoint é o correto
    y = LUTcalib(midpoint, 2)
%else
