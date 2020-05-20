function  [out,type,encoderAmplitude]  =Encoder (quantizedsignal,bits,fs)


fprintf('<strong>Entering Encoder inputs</strong>\n');

%% Entering type--types 0)unipolar, 1)polar, 2)Manchester
disp('types: 0)unipolar, 1)polar, 2)Manchester')
type=input('Enter the encoding type: ');
while type ~= 0 && type ~= 1 && type~=2
	type=input('Wrong entry please Re-enter the encoding type: ');
end

encoderAmplitude=input('Enter encoding amplitude: ');

figure('Name', 'Encoder');
out= encoderAmplitude.*quantizedsignal;  
Rb=fs*bits;
bitsize=1/Rb;
t=0:bitsize:bitsize*length(quantizedsignal);
if type == 0
    out = encoderAmplitude*quantizedsignal;  
elseif type == 1
    out = encoderAmplitude*(quantizedsignal>0) + -encoderAmplitude*(quantizedsignal==0);
else
    j=1;
    Manchester= zeros(1,21);
    for i=1:length(quantizedsignal)
        Manchester([j j+1]) = [quantizedsignal(i) ~quantizedsignal(i)];
        j=j+2;
    end
    Manchester(Manchester==0)=-1;
    out=5*Manchester;
    out=[out 0];
    t_manchester=0:bitsize/2:(bitsize/2)*length(Manchester);
    stairs(t_manchester,out,'g');
end
if(type ~= 2)
 out_draw=[out 0];
 stairs(t,out_draw,'g');
end
xlim([0 bitsize*length(out)]);
ylim([-2*encoderAmplitude 2*encoderAmplitude]);
grid on;
end
