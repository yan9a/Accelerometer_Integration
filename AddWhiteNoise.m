function Sn = AddWhiteNoise(S,std_s)

% add normally distributed noise with standard deviation, std_s to
% the input signal, S

[n m]=size(S);
Sn=S + std_s .* randn(n,m);