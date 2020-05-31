function ReconstructionFilter(inputSignal,decodedSignal,fs,t,sampledSignal,numberOfCycles,fm)

decodedSignal=rot90(decodedSignal);

Time = 0:1/10000*fs:numberOfCycles*1/fm;

index = 1; 
for StepTime = 0:1/10000*fs:1 
    signal(index) = 0;
    for T = 0:size(decodedSignal) - 1 
        ConvPart = decodedSignal(T+1)* sinc(fs*StepTime-(T));
        signal(index) = signal(index) + ConvPart;
    end
    index=index+1;
end

figure('Name', 'Reconstructed Signal');
plot(Time,signal,'color','r')
hold on
plot(t,inputSignal,'color','b');
title('Reconstructed Signal');
legend('Reconstructed Signal','Original Signal'); 
grid;
xlabel('Time');
ylabel('Amplitude');

figure('Name', 'FT of Input, Sampled, and Reconstructed Signal');
subplot(3,1,1);
L1 = length(abs(fft(inputSignal)));
f1 = -L1/2:1:(L1/2)-1;
plot(f1,abs((fft(inputSignal))));
title('Input Signal');
xlabel('Frequency Hz'); 
subplot(3,1,2);
L2 = length(abs(fft(sampledSignal)));
f2 = -L2/2:1:(L2/2)-1; 
plot(f2,abs(fft(sampledSignal)));
title('Sampled Signal');
xlabel('Frequency Hz'); 
subplot(3,1,3); 
L3 = length(abs(fft(signal))); 
f3 = -L3/2:1:(L3/2)-1;
plot(f3,abs(fft(signal)));
title('Reconstructed Signal');
xlabel('Frequency Hz'); 
	
end

