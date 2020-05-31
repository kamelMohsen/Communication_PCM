function [outputSignal,type,amplitude] = Encoder(newQuantizedSignal,numberOfBits,fs)


	fprintf('<strong>Entering Encoder inputs</strong>\n');
	%% Entering type--types 1)polar, 2)unipolar, 3)manchester
	disp('types: 1)polar, 2)unipolar, 3)manchester')
	type=input('Enter the encoding type: ');

	amplitude=input('Enter encoding amplitude: ');


	%This is what the 'main' will do
	%compare sample number with map to determine the needed bits
	%let's say that the bits are 0100 0101 1100 1010
	%Now we need to implement three algorithms for encoding signals
	%First Unipolar NRZ, Second Polar NRZ, and finally Manchester
	%Now let's start with unipolar nrz 0 is __ and 1 is -, pretty standard
	%Polar NRZ is 1 is -- and 0 is __ which is negative not
	%Manchester is 0 is 1 -_ and 0 is _-

	%first let's find an amplitude let's say 5, now we find output how to calculate the bit rate
	N = length(newQuantizedSignal)*numberOfBits;
	bitRate =fs*numberOfBits; %bit rate
	bitDuration = 1/bitRate;


    number = fliplr(de2bi(newQuantizedSignal, numberOfBits + 1));
    
	string = mat2str(number);

	newString = '';
	for i = 1:length(string)
	  if string(i) ~= ' ' && string(i) ~= '[' &&  string(i) ~= ']' && string(i) ~= ';'
		newString = strcat(newString, string(i));
	  end
	end

	array = ''; %let's start with unipolar
	output = 0;
	counter = 1;
	figure('Name', 'Encoder');
	if (type == 1) % polar
	  for i = 1:length(newString)
		if newString(i) == '0'
		  output = [output -amplitude];
		  counter = counter + 1;
		elseif newString(i) == '1'

		  output = [output amplitude];
		  counter = counter + 1;
		end
      end
	  
		
	  time = 0:bitDuration:bitDuration*length(output(2:end))-bitDuration;
      stairs(time,output(2:end),'g');
	elseif(type == 2) %unipolar
	  for i = 1:length(newString)
		  if newString(i) == '0'
			output = [output 0];
			counter = counter + 1;
		  elseif newString(i) == '1'

			output = [output amplitude];
			counter = counter + 1;
		  end
      end
        time = 0:bitDuration:bitDuration*length(output(2:end))-bitDuration;
		stairs(time, output(2:end),'g');
		
	elseif(type == 3)  %Manchester
		  for i = 1:length(newString)
		  if newString(i) == '0'
			output = [output -amplitude amplitude];
			counter = counter + 1;
		  elseif newString(i) == '1'

			output = [output amplitude -amplitude];
			counter = counter + 1;
		  end
          end
        time = 0:bitDuration:bitDuration*length(output(2:end))-bitDuration;
        stairs(time, output(2:end),'g');
		
    end

    outputSignal = output(2:end); 


	ylim([-2*amplitude 2*amplitude]);
	grid on;
	%Unipolar NRZ, first let's find an amplitude let's say 5, 
	%, if we find a zero , we
	%broadcast zero for a bit duration, if we find 1 we broadcast the amplitude
	%for a bit duration
	%now we can join the entire string, if we find a zero we add
end