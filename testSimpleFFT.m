clear
clc

% which electrode?
electrodeId = input('which electrode? ','s');


[file,path] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\001.workspace\001.matlab\yenikim\testData\raw_mat\','MultiSelect','Off');

elects = load([path file],'Electrodes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% electData = eval(sprintf('elects.Electrodes.electrode%s.Data', electrodeId));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
electData11 = eval(sprintf('elects.Electrodes.electrode11.Data'));
electData12 = eval(sprintf('elects.Electrodes.electrode12.Data'));
electData13 = eval(sprintf('elects.Electrodes.electrode13.Data'));
electData21 = eval(sprintf('elects.Electrodes.electrode21.Data'));
electData22 = eval(sprintf('elects.Electrodes.electrode22.Data'));
electData23 = eval(sprintf('elects.Electrodes.electrode23.Data'));
electData31 = eval(sprintf('elects.Electrodes.electrode31.Data'));
electData33 = eval(sprintf('elects.Electrodes.electrode33.Data'));


meanData = (electData11+electData12+electData13+electData21+electData22+electData23+electData31+electData33)./8;

electData = (electData22 - meanData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FILTER_ORDER = 6;

SAMPLING_FREQ = 12500;
SIGNAL_DURATION = 600;
EMBED_MAXDIM = 10;
EMBED_DELAY = 2;
THREHOLD_RTOL = 15;
THREHOLD_ATOL = 2;

nfft = SAMPLING_FREQ * SIGNAL_DURATION;
freq = SAMPLING_FREQ*(0:(nfft/2)-1)/nfft;
t = 0:1/SAMPLING_FREQ:SIGNAL_DURATION-1/SAMPLING_FREQ; % time vector
inData = double(electData);
% before filtering
Y1 = fft(inData, nfft);
Mag1 = (abs(Y1(1:nfft/2)))/nfft/4; 


% band-pass 
%%%%%%%%%%
fprintf('filtering.........................................................');
d1 = designfilt('bandpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency1',10,'HalfPowerFrequency2',2500,'SampleRate',12500,'DesignMethod','butter');
%d1 = designfilt('lowpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency',2500,'SampleRate', SAMPLING_FREQ, 'DesignMethod','butter');
outData = filtfilt(d1, inData);
%d1 = designfilt('highpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency',10,'SampleRate', SAMPLING_FREQ, 'DesignMethod','butter');
%outData = filtfilt(d1, outData);

fprintf('end.\n');

%outData = filtfilt(b,inData);
%[outData, d] = bandpass(inData,[10 2500],SAMPLING_FREQ,'ImpulseResponse','auto');

% applying notch filter to outData
%%%%%%%%%%
%d2 = designfilt('bandstopiir','FilterOrder',20','HalfPowerFrequency1',59.5,'HalfPowerFrequency2',60.5,'SampleRate',SAMPLING_FREQ);
%outData = filtfilt(d2, outData);

% after filtering
Y2 = fft(outData, nfft);
Mag2 = (abs(Y2(1:nfft/2)))/nfft/4; 

fig1=figure('Position',[100, 100, 1200, 800]);
subplot(3,5,1:5);plot(t, inData);
title([strrep(file,'_','-') ', Electrode = ' electrodeId], 'FontSize',13);
ylabel('Amplitude[mV]');
subplot(3,5,6:10);plot(t, outData);
ylabel('Amplitude[mV]');xlabel('time[sec]');
title('BPF(10~2500 Hz, butterworth) filtered signal ', 'FontSize',13);

subplot(3,5, 11:12);plot(freq, Mag1);xlabel('Freq[Hz]');ylabel('Amplitude[mV]');title('Raw Signal');
subplot(3,5, 14:15);plot(freq, Mag2);xlabel('Freq[Hz]');ylabel('Amplitude[mV]');title('Filted Signal');

%saveas(fig1, sprintf('%s.t-s.e%s.png',strrep(file,'.mat',''), electrodeId));
%%

fprintf('calculating FNN...................................................');
% calculate the FNN 
% raw signal
runRData = reshape(inData, SAMPLING_FREQ, SIGNAL_DURATION);

% time interval 200~400 s 
%runRData = reshape(inData(200*SAMPLING_FREQ+1:400*SAMPLING_FREQ,1), SAMPLING_FREQ, SIGNAL_DURATION/3);
typeRSTD = std(runRData); % STD(Standard Deviation)

% filtered signal
runFData = reshape(outData, SAMPLING_FREQ, SIGNAL_DURATION);

% time interval 200~400s
%runFData = reshape(outData(200*SAMPLING_FREQ+1:400*SAMPLING_FREQ,1), SAMPLING_FREQ, SIGNAL_DURATION/3);

typeFSTD = std(runFData); % STD(Standard Deviation)

typeRStdFNN = f_fnn(typeRSTD,EMBED_DELAY,EMBED_MAXDIM,THREHOLD_RTOL,THREHOLD_ATOL);
typeFStdFNN = f_fnn(typeFSTD,EMBED_DELAY,EMBED_MAXDIM,THREHOLD_RTOL,THREHOLD_ATOL);
%typeAbsFNN = f_fnn(typeABS,EMBED_DELAY,EMBED_MAXDIM,THREHOLD_RTOL,THREHOLD_ATOL);
fprintf('end.\n');
%%
fprintf('drawing...........................................................');

fig2 = figure('Position',[100, 300, 1200, 600]);
% raw signal
subplot(2,3,1:2);plot(typeRSTD);title(['Raw-' strrep(file,'_','-') ', Electrode = ' electrodeId], 'FontSize',13);
xlabel('Sample');ylabel('Amplitude[mV]');
subplot(2,3,3);plot(1:10, typeRStdFNN,'b-o');title('Minimum Embedding Dimension using FNN');
xlabel('Dimension');ylabel('False NN[%]')
[r,c]=min(typeRStdFNN);
hold on;plot(c,r,'ro'); grid on;
text(6,90,sprintf('# MED = %d', c));
% filtered signal

subplot(2,3,4:5);plot(typeFSTD);title(['Filtered-' strrep(file,'_','-') ', Electrode = ' electrodeId], 'FontSize',13);
xlabel('Sample');ylabel('Amplitude[mV]');
subplot(2,3,6);plot(1:10, typeFStdFNN,'b-o');title('Minimum Embedding Dimension using FNN');
xlabel('Dimension');ylabel('False NN[%]')
[r,c]=min(typeFStdFNN);
hold on;plot(c,r,'ro');grid on;
text(6,90,sprintf('# MED = %d', c));
%subplot(1,2,2);plot(1:10, typeAbsFNN,'b-o');title('ABS')
fprintf('end.\n');
% save the figure
%saveas(fig2, sprintf('%s.fnn.e%s.png',strrep(file,'.mat',''), electrodeId));