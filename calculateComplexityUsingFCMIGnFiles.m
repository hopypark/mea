%
% export results to a csv file for 1 plate
%
clc
clearvars

FILTER_ORDER = 6;
SAMPLING_FREQ = 12500; % fs
LOWER_BOUND_BPF = 10;
UPPER_BOUND_BPF = 2500;

%% variables about f_fnn

%% 1s block

NUMBER_ELECTRODES = 8;
%

electsNames = {'electrode11';'electrode12';'electrode13';'electrode21';'electrode22';'electrode23';'electrode31';'electrode33'};
electsNames9 = {'electrode11';'electrode12';'electrode13';'electrode21';'electrode22';'electrode23';'electrode31';'electrode32';'electrode33'};
numElects = size(electsNames,1);
% wellsname = '';

[files,path] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\mat\','MultiSelect','on');
[r, filesLen] = size(files); % # number of selected files
disp([num2str(filesLen) ' files selected.'])

%
% global variables for FNN and wellnames
% - dynamic array
wellnames=[];%cell(numTotalShiftBlock * numWells,1);

tic
for iFile = 1:filesLen
    elects = load([path files{1,iFile}],'Electrodes');
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

    fc = zeros(8,96);
    mig = zeros(8,96);
    npks = zeros(8,96);
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
            
            [r,c]=find(pks > std(outData) * 5.5);

            %figure;plot(elecData);hold on;plot(locs(r,1), pks(r,1),'r*');
            npks(iCol,iFile) = length(r);
            binData = zeros(length(outData),1);
            binData(locs(r,1),1)=1;
            [fc(iCol,iFile), mig(iCol,iFile)] = fc_2017(binData,3,1,2);
            %eidx = eidx + 1;
        catch ME
            fprintf('%s is empty. %s\n',electsNames{iCol,1}, ME.message);
            continue;
        end

    end % electrodes
end % iFile
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

