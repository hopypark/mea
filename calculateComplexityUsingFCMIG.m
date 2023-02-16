%
% 1. load a raw data
% 2. normalization - standardization scaler
% 3. calculate the MED(Minimal Embedding Dimension) of 1's raw electrode waveform using f_fnn.m
% 4. export results to a csv file for 1 plate
%
clc
clearvars

FILTER_ORDER = 6;
SAMPLING_FREQ = 12500; % fs
LOWER_BOUND_BPF = 10;
UPPER_BOUND_BPF = 2500;

% variables about f_fnn
%%
% MAXIMUM_DIM = 10;
% TIME_DELAY = 2;
% R_THRESHOLD = 15; % 10 --> 15. updated 2022.12.16
% A_THRESHOLD = 2;
% % constant variable
% max_dimension = MAXIMUM_DIM;
% tau=TIME_DELAY;
% rtol = R_THRESHOLD;
% atol = A_THRESHOLD;

% variables about electrode data
%% 1s block

% SHIFT_DATA_LENGTH = 25; % 12.5kHz --> 500Hz down sampling
% BLOCK_LENGTH = 30;
% SAMPLE_NUMBER_SECOND = SAMPLING_FREQ;
% NUMBER_WELLS = 96;
NUMBER_ELECTRODES = 8;
% 
% nRows = 0; % number of blocks when time is 1 sec
% nData = SAMPLE_NUMBER_SECOND; % number of data when sampling time is 1 sec
% nCols = NUMBER_ELECTRODES;
% %
% shiftdata = SHIFT_DATA_LENGTH;
% shiftblock = BLOCK_LENGTH;
% 
% numTotalShiftBlock = 0;%20; nRows / shift_block_length
% numCurrShiftBlock = 0;
% numWells = NUMBER_WELLS;

%

electsNames = {'electrode11';'electrode12';'electrode13';'electrode21';'electrode22';'electrode23';'electrode31';'electrode33'};
electsNames9 = {'electrode11';'electrode12';'electrode13';'electrode21';'electrode22';'electrode23';'electrode31';'electrode32';'electrode33'};
numElects = size(electsNames,1);
wellsname = '';

[file,path] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\mat\','MultiSelect','off');
% [r, filesLen] = size(files); % # number of selected files
% disp([num2str(filesLen) ' files selected.'])

%
% global variables for FNN and wellnames
% - dynamic array
wellnames=[];%cell(numTotalShiftBlock * numWells,1);

tic


    elects = load([path file],'Electrodes');
    wellsname = file(1,24:26);

    enames = fieldnames(elects.Electrodes);
    if size(enames,1) ~=  NUMBER_ELECTRODES
        numElects = size(enames,1);
        electsNames = electsNames9;
        nCols = size(enames,1);
        if ~compareCellStrings(electsNames9, enames)
            disp('Two cell array is not equal.')
%             break;
        end        
    else
        if ~compareCellStrings(electsNames, enames)
            disp('Two cell array is not equal.')
%             break;
        end        
    end

    fc = zeros(8,1);
    mig = zeros(8,1);
    npks = zeros(8,1);
%     eidx = 1;
    tic
    for iCol = 1:numElects
        try
            inData = double(elects.Electrodes.(electsNames{iCol,1}).Data);

            fprintf('filtering.........................................................');
            d1 = designfilt('bandpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency1',LOWER_BOUND_BPF,'HalfPowerFrequency2',UPPER_BOUND_BPF,'SampleRate',SAMPLING_FREQ,'DesignMethod','butter');
            %d1 = designfilt('lowpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency',2500,'SampleRate', SAMPLING_FREQ, 'DesignMethod','butter');
            outData = filtfilt(d1, inData);
            %d1 = designfilt('highpassiir','FilterOrder',FILTER_ORDER,'HalfPowerFrequency',10,'SampleRate', SAMPLING_FREQ, 'DesignMethod','butter');
            %outData = filtfilt(d1, outData);

            fprintf('end.\n');

            [pks,locs, width, proms]=findpeaks(outData);
            
            [r,c]=find(pks > std(outData) * 4.5);

            %figure;plot(elecData);hold on;plot(locs(r,1), pks(r,1),'r*');
            npks(iCol,1) = length(r);
            binData = zeros(length(outData),1);
            binData(locs(r,1),1)=1;
            [fc(iCol,1), mig(iCol,1)] = fc_2017(binData,3,1,2);
            %eidx = eidx + 1;
        catch ME
            fprintf('%s is empty. %s\n',electsNames{iCol,1}, ME.message);
            continue;
        end

    end % electrodes
    toc
    % add to global variable
%     fnn = [fnn; fnn1]; 
%     wellnames = [wellnames; wellname]; 
%     clear elects  fnn1 wellsname;
% end

% %
% % make a table using wellnames and f_fnn results
% %
% tableValue = table;
% 
% tableValue.wellname = wellnames;
% % for i=1:numElects
% %     eval(sprintf('tableValue.%s = fnn(:,%d);',electsNames{i,1},i));
% % end
%     for i=1:numElects
%         if ~isempty(idxEmptyElectrode) && ~isempty(find(idxEmptyElectrode == i,1))  
%             continue;
%         end
%         eval(sprintf('tableValue.%s = fnn(:,%d);',electsNames{i,1},i));
%     end
% 
% % write a table to csv file
% writetable(tableValue,[path files{1,1}(1,1:22) '.f_fnn.csv'],'Delimiter',',','QuoteStrings',false)
% toc

