function [finalMessage]=Decoder(signal,peak, levelMap,amplitude,myu, TypeOfEncoding,quantizerType, numberOfBits, maxLevel)
  
	  decodedMessage = [];
		if TypeOfEncoding == 1
			for i = 1:1:length(signal)
				if signal(i) == -amplitude
					decodedMessage = [decodedMessage 0];
				elseif signal(i) == amplitude
					decodedMessage = [decodedMessage 1];
				end
			end
		elseif TypeOfEncoding == 2
			for i = 1:1:length(signal)
				if signal(i) == 0
					decodedMessage = [decodedMessage 0];
				elseif signal(i) == amplitude
					decodedMessage = [decodedMessage 1];
				end
		end
		elseif TypeOfEncoding == 3
			for i = 1:2:length(signal)
				if signal(i) == -amplitude && signal(i + 1) == amplitude
				decodedMessage = [decodedMessage 0];
				elseif signal(i) == amplitude && signal(i + 1) == -amplitude
				decodedMessage = [decodedMessage 1];
				end
			end
		end


	quantizedMessage =  [];
	for i = 1:numberOfBits + 1:length(decodedMessage)
	   string = mat2str(decodedMessage(i:i+numberOfBits));
	   quantizedMessage = [quantizedMessage bi2de(fliplr(decodedMessage(i:i+numberOfBits)))];
	end


	finalMessage = [];


        for i = 1:length(quantizedMessage)
	  finalMessage = [finalMessage levelMap(quantizedMessage(i))];
	end
	
	if quantizerType ==2  && myu ~=0
    for i = 1:length(finalMessage)
    variable = (finalMessage(i) * log(1+myu))/maxLevel;
    finalMessage(i) = maxLevel* ((maxLevel/myu)* exp(abs(variable))-1) * -sign(finalMessage(i));
    end
	

end