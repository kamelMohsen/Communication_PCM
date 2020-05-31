function [newQuantizedSignal,uni,bits,levelMap, myu, maxPeakLevel]=Quantizer(arrayOfSamples,timeOfSamples)


%Determine if uniform or non-uniform
uni = input('Please enter the quantization mode: 1) for uniform quantization, 2) for non uniform quantization \n');
%Receiving max peak level and number of levels from user
maxPeakLevel = input('Please enter the max peak level \n');
noOfLevels = input('Please enter the number of quantization levels \n');

if (uni == 1)
	myu=0;
elseif (uni == 2)
    myu = input('Please enter myu value:');
	for i = 1:length(arrayOfSamples)
	arrayOfSamples(i) = sign(arrayOfSamples(i)/maxPeakLevel)*log(1 + myu*abs(arrayOfSamples(i)/maxPeakLevel))/log(1+myu);
	end
end




%calculating number of levels based on the bits needed to get the number of
%levels set by the user

bits = 1;
%noOfLevels is 8

while(noOfLevels > 2^bits)
    bits = bits + 1;
end
noOfLevels = 2^bits;
delta = (2*maxPeakLevel)/noOfLevels;
%Create an array of levels

positiveLevels = [];
for i = 1:noOfLevels/2
    randomLevel = (delta/2) + (i - 1)*delta; 
    positiveLevels = [positiveLevels randomLevel];
end
negativeLevels = [];
for i = 1:noOfLevels/2 
    randomLevel = -(delta/2) - (i - 1)*delta; 
    negativeLevels = [negativeLevels randomLevel];
end
levels = [fliplr(negativeLevels) positiveLevels];

%Initialize the new signal array, and calculate the quantized signal
newQuantizedSignal = [];
newSignalCounter = 1;

for i = 1:length(arrayOfSamples) %loop over sampled signal

    if (arrayOfSamples(i)>= levels(length(levels))) %if the sample is more than the max peak level, set it to the max level
    
    newQuantizedSignal(newSignalCounter)= levels(length(levels));
    newSignalCounter = newSignalCounter + 1;
    continue;

    elseif(arrayOfSamples(i) <= levels(1)) %if the sample is less than the min peak level, set it to the min level
    newQuantizedSignal(newSignalCounter)= levels(1);
    newSignalCounter = newSignalCounter + 1;
    continue;
    end

    for j = 1:noOfLevels-1  %loop over levels
       %if the sample is between the current two levels
        if (arrayOfSamples(i)>levels(j) & arrayOfSamples(i) < levels(j+1)) 
           %if the sample is closer to the higher level, set it to the
           %higher level
           if(abs(arrayOfSamples(i)- levels(j)) >= abs(arrayOfSamples(i) - levels(j+1)))
               newQuantizedSignal(newSignalCounter) = levels(j+1);
                newSignalCounter =newSignalCounter + 1;
                break;
           %if the sample is closer to the lower level, set it to the
           %lower level
           else
                newQuantizedSignal(newSignalCounter) = levels(j);
                newSignalCounter = newSignalCounter + 1;
                break;
           end

       end
    end
end
arrayOfLevels = 1:noOfLevels;

binaryLevels = de2bi(arrayOfLevels);
binaryLevels =fliplr(binaryLevels);
string = mat2str(binaryLevels);
array = {};
counter = 2;



levelMap = containers.Map(arrayOfLevels, levels);

inverseLevelMap = containers.Map(levels, arrayOfLevels);
%output is newQuantizedSignal
%we need to convert the quantized signal into binary before passing it to
%the encoder 3alatool

convertedQuantizedSignal = [];
for i = 1:length(newQuantizedSignal)

    convertedQuantizedSignal = [convertedQuantizedSignal inverseLevelMap(newQuantizedSignal(i))];
end
newQuantizedSignal = convertedQuantizedSignal;
linda = linspace(0,length(newQuantizedSignal)-1, length(newQuantizedSignal));



figure('Name', 'Quantizer');
stem(timeOfSamples,arrayOfSamples,'m');
hold on
stem(timeOfSamples,newQuantizedSignal,'b','filled');
grid on
legend('sampled signal','quantized signal')
xlabel('t');
ylabel('Amplitude')
title('quantizer output');
