clc 
clear

[signal,sampledSignal,peak,fs,fm,tSampled,t,numberOfCycles]= Sampler();
[quantizedsignal,quantizerType,bits,levels,mu, maxLevel]= Quantizer(sampledSignal,tSampled);
[encodedSignal,encoderType,encoderAmplitude]= Encoder (quantizedsignal,bits ,fs);
[decodedSignal]= Decoder(encodedSignal,peak,levels,encoderAmplitude,mu,encoderType,quantizerType,bits, maxLevel);
ReconstructionFilter(signal,decodedSignal,fs,t,sampledSignal,numberOfCycles,fm);

disp('Program Ended');
