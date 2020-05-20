function [quantizedSignal,type,bits,levels,mu] = Quantizer(sampledSignal,t)


fprintf('<strong>Entering Quantizer inputs</strong>\n');

%% Entering type--types 0)uniform, 1)non-uniform
disp('types: 0)uniform, 1)non-uniform')
type=input('Enter the quantization type: ');
while type ~= 0 && type ~= 1
	type=input('Wrong entry please Re-enter the quantization type: ')
end

%% Entering number of quantization levels
levels=input('Enter the number of quatization levels: ');

%% Entering the mu of the compander 
mu=input('Enter the mu of compander: '); 

mp=input('Enter mp value: ');

%% Deciding which signal to use 0)uniform , 1)non-uniform
if type == 0
    signal=sampledSignal;
else
    %%signal=(log(1+mu*abs(sampledSignal))/log(1+mu))*mp.*sign(sampledSignal);
	signal=mp*(log(1+mu*abs(sampledSignal)/mp)/log(1+mu)).*sign(sampledSignal);
end


bits=log2(levels);
delta=2*mp/levels;
sideLevels=levels/2;
tempSignal=zeros(1,length(signal));

    for i=1:length(signal)
        for k=0:1:(sideLevels-1)
            if (((k*delta)<=abs(signal(i)))&&(abs(signal(i))<=((k+1)*delta)))   %
                if(signal(i)>0)
                    tempSignal(i)=(0.5+k)*delta;
                elseif(signal(i)<0)
                    tempSignal(i)=(-0.5-k)*delta;
                else %signal equal zero
                    tempSignal(i)=(0.5+k)*delta;
                end
            end
        end
    end

figure('Name', 'Quantizer');
stem(t,sampledSignal,'m');
hold on
stem(t,tempSignal,'b','filled');
grid on
legend('sampled signal','quantized signal')
xlabel('t');
ylabel('Amplitude')
title('quantizer output');


fixed=(tempSignal+(delta/2)+((sideLevels-1)*delta))/delta;
fixed=round(fixed);
quantizedSignal= de2bi(fixed,bits,2,'left-msb');
quantizedSignal=quantizedSignal';
quantizedSignal=quantizedSignal(1:end);  
 

end 
