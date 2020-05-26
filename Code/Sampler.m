function [signal,sampledSignal,peak,fs,f,tSampled,tOriginal,numberOfCycles] = Sampler()


%%%%%%%%%%%%%%%%%%%%%%%%%%%Entering Inputs%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('<strong>Entering Sampler inputs</strong>\n');

%% Entering the signal as an equation but has to enter it in matlab format 
%% and use f for Fm and use for t equation's time  
disp('The signal function should be in matlab format.');
disp('i.e: 5*cos(2*pi*f*t)');
inputFunction=input('Enter the signal function m(t): ','s');

%% Enterig the signal frequency Fm
f=input('Enter the signal frequncy: ');

%% Entering the sampling Frequency
fs=input('Enter the sampling frequncy: ');

%% Entering the number of cycles 
numberOfCycles=10;


%% Calculating original signal
Timestep=1/(numberOfCycles*fs);
t=0:Timestep:numberOfCycles*1/f;
tOriginal = t;
catched = 1;
while catched == 1
	try
		signal=eval(inputFunction);
		catched = 0;
	catch
		inputFunction=input('WRONG function format please renter it: ','s');
	end
end

peak=max(signal);

%% Plotting original signal
figure('Name', 'Sampler');
plot(t,signal,'LineWidth',1, 'Color', 'k', 'DisplayName', 'Signal');
hold on; 

%% Calculating sampled signal
t=0:1/fs:numberOfCycles*1/f;
tSampled = t;
sampledSignal = eval(inputFunction);

%% plotig the sampled signal and adding info
stem(tSampled,sampledSignal,'o','filled', 'LineWidth',1.5, 'Color', 'm', 'DisplayName', 'Sampled signal'); 
caption = strcat('Sampling of: ',inputFunction);
title(caption); 
xlabel('Time(s)'); 
ylabel('Amplitude');
legend('Signal','Sampled signal'); 
legend('show')
grid


end

