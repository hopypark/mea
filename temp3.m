clear
clc
electsNames = {'electrode11';'electrode12';'electrode13';'electrode21';'electrode22';'electrode23';'electrode31';'electrode32';'electrode33'};
FILTER_ORDER = 6;
SAMPLING_FREQ = 12500; % fs
LOWER_BOUND_BPF = 10;
UPPER_BOUND_BPF = 2500;

[files,path] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\mat\','MultiSelect','off');

elects = load([path files],'Electrodes');
enames = fieldnames(elects.Electrodes);
Attn = zeros(8,5);
for i=1:size(enames,1)
    try
        inData = double(elects.Electrodes.(electsNames{i,1}).Data);
        d1 = designfilt('bandpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency1',LOWER_BOUND_BPF,'HalfPowerFrequency2',UPPER_BOUND_BPF,'SampleRate',SAMPLING_FREQ,'DesignMethod','butter');
            %d1 = designfilt('lowpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency',2500,'SampleRate', SAMPLING_FREQ, 'DesignMethod','butter');
        outData = filtfilt(d1, inData);

        [pks,locs, width, proms]=findpeaks(outData);
        [r,c]=find(pks > std(outData) * 4.5);

            %figure;plot(elecData);hold on;plot(locs(r,1), pks(r,1),'r*');
            %npks(iCol,iFile) = length(r);
            binData = zeros(length(outData),1);
            binData(locs(r,1),1)=1;

        
        [Attn(i,1), Attn(i,2), Attn(i,3), Attn(i,4), Attn(i,5)] = AttnEn(binData);
    catch ME
        fprintf('%s is empty. %s\n',electsNames{i,1}, ME.message);
        continue;
    end
end



            
       