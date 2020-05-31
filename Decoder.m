function [decoded]=Decoder(signal,peak,levels,encoderAmplitude,mu,encoderType,quantizerType)



step=(2*encoderAmplitude)/levels; 
bits=log2(levels);

signal=signal./encoderAmplitude;


c=1;
decoded=zeros(0,1);

if (encoderType==1)
   for i=1:1:length(signal)
       if(signal(i)==-1)
           signal(i)=0;
       end
   end
end

count=1;
Temp=zeros(0,1);
if (encoderType==2)
   for i=1:2:(length(signal))
       if(signal(i)==1 && signal(i+1)==-1)
           Temp(count)=1;
           count=count+1;
       elseif(signal(i)==-1 && signal(i+1)==1)
           Temp(count)=0;
           count=count+1;
       end
   end
    signal=Temp;
end

for i=1:bits:length(signal)
    period=signal(i:times(c,bits));
    pAmp=bi2de(period,2,'left-msb');
    Amp=(pAmp*step)-((2^(bits-1)-1)*step)-(step/2);
    decoded(c)=Amp;
    c=c+1;
   
end
 
if(quantizerType == 1)
    Amp=decoded.*log(1+mu)./peak;
    decoded=(peak/mu)*(exp(abs(Amp))-1).*sign(Amp);
end

end
