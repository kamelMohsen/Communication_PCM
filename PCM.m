clc
clear

[signal,sampledSignal,peak,fs,fm,tSampled,t,numberOfCycles]= Sampler();
[quantizedsignal,quantizerType,bits,levels,mu]= Quantizer(sampledSignal,tSampled);
[encodedSignal,encoderType,encoderAmplitude]= Encoder (quantizedsignal,bits,fs);
[decodedSignal]= Decoder(encodedSignal,peak,levels,encoderAmplitude,mu,encoderType,quantizerType,tSampled);
ReconstructionFilter(signal,decodedSignal,fs,t,sampledSignal,numberOfCycles,fm);