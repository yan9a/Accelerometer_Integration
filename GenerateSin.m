function S = GenerateSin(Peak,Freq,t)
%Generate sinusoidal signals from Peak and Frequency inputs

r=length(Peak);
c=length(t);
S=zeros(r,c);
for i=1:r
  S(i,:) = Peak(i)*sin(2*pi*Freq(i)*t);
end