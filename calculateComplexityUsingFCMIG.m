%
% 1. load a raw data
% 2. normalization - standardization scaler
% 3. calculate the MED(Minimal Embedding Dimension) of 1's raw electrode waveform using f_fnn.m
% 4. export results to a csv file for 1 plate
%
clc
clearvars

% variables about f_fnn
%%
MAXIMUM_DIM = 10;
TIME_DELAY = 2;
R_THRESHOLD = 15; % 10 --> 15. updated 2022.12.16
A_THRESHOLD = 2;
% constant variable
max_dimension = MAXIMUM_DIM;
tau=TIME_DELAY;
rtol = R_THRESHOLD;
atol = A_THRESHOLD;

% variables about electrode data
%% 1s block
SAMPLING_FREQ = 12500; % fs
SHIFT_DATA_LENGTH = 25; % 12.5kHz --> 500Hz down sampling
BLOCK_LENGTH = 30;
SAMPLE_NUMBER_SECOND = SAMPLING_FREQ;
NUMBER_WELLS = 96;
NUMBER_ELECTRODES = 8;

nRows = 0; % number of blocks when time is 1 sec
nData = SAMPLE_NUMBER_SECOND; % number of data when sampling time is 1 sec
nCols = NUMBER_ELECTRODES;
%
shiftdata = SHIFT_DATA_LENGTH;
shiftblock = BLOCK_LENGTH;

numTotalShiftBlock = 0;%20; nRows / shift_block_length
numCurrShiftBlock = 0;
numWells = NUMBER_WELLS;

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
fnn=[];%zeros(numTotalShiftBlock * numWells, nCols);
wellnames=[];%cell(numTotalShiftBlock * numWells,1);

tic

% for ifile = 1:filesLen

%     elects = load([path file{1,ifile}],'Electrodes');
%     wname = files{1,ifile}(1,24:26); % A01, A02, ..., A12, B01, ..., B12, ... , H12

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
    % 

    %
    % % 0.2s block
    % nRows = 3000; % number of blocks when time is 0.2 sec
    % nData = 2500; % number of data when time is 0.2 sec
    % nCols = 8;
    %
    % fnn1=zeros(nRows, nCols);
    % fnn2=zeros(nRows, nCols);
    %
    % for iCol = 1:numElects
    %     disp(['name: ' electsNames{iCol,1}])
    %     elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);
    %
    %     for iRow = 1:1%nRows
    %         data=elecData((iRow - 1) * nData + 1 : iRow * nData, 1 );
    %         standard = (data - mean(data))./std(data); %// Standardization normalization
    %         [val, ed1] = min(f_fnn(standard, tau, max_dimension, rtol, atol));
    %         fnn1(iRow, iCol) = ed1;
    %         [fnnPerc, embTimes] = mdFnn(standard, tau);
    %         [val, ed2] = min(fnnPerc);
    %         fnn2(iRow, iCol) = ed2;
    %        % displog = sprintf('%03d/%04d..............%06.2f%% Completed.', iRow, nRows, iRow/nRows*100);
    %         displog = sprintf('%03d/%04d..............%05.2f%% Completed(f_fNN = %2d, mdFnn = %2d)', iRow, nRows, iRow/nRows*100, ed1, ed2);
    %         disp(displog)
    %     end
    %     %displog = sprintf('%d/%d..............%05.2f%% Completed.', iCol, nCols, iCol/nCols*100)
    % end
    % toc

    %     %% 1s block
    %     nRows = 600; % number of blocks when time is 1 sec
    %     nData = 12500; % number of data when time is 1 sec
    %     nCols = 8;
    %     %
    %     shiftdata = 25;
    %     shiftblock = 30;
    %
    %     numTotalShiftBlock = 20;
    %     numCurrShiftBlock = 0;

%     displog = sprintf('%s - %02d/%02d..............%06.2f%% Started.', files{1,ifile}, ifile, filesLen , ifile/filesLen*100);
%     disp(displog)

    %nRows = ceil(size(elects.Electrodes.(electsNames{1,1}).Data, 1) / SAMPLE_NUMBER_SECOND); % return # of 1s block
    nRows = round(size(elects.Electrodes.(electsNames{1,1}).Data, 1) / SAMPLE_NUMBER_SECOND); % return # of 1s block
    %numTotalShiftBlock = round(nRows/shiftblock); % 20(10 minutes data) or 30(15 minutes data )
    %
    % block unit variables
    fnn1=[];%zeros(numTotalShiftBlock, nCols);
    wellname=[];%cell(numTotalShiftBlock,1);
    idxEmptyElectrode = []; 
    fc = zeros(8,1);
    mig = zeros(8,1);
%     eidx = 1;
    tic
    for iCol = 1:numElects
        try
            elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);

            [pks,locs, width, proms]=findpeaks(elecData);
            [r,c]=find(pks > std(elecData) * 5);

            %figure;plot(elecData);hold on;plot(locs(r,1), pks(r,1),'r*');

            binData = zeros(length(elecData),1);
            binData(locs(r,1),1)=1;
            [fc(iCol,1), mig(iCol,1)] = fc_2017(binData,3,1,2);
            %eidx = eidx + 1;
        catch
            fprintf('%s is empty.\n',electsNames{iCol,1});
            continue;
        end
%         disp(['electrode name: ' electsNames{iCol,1}])
% %         elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);
%             try
%                 elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);
%             catch
%                 sprintf('%s is empty.',electsNames{iCol,1});
% %                 electsNames = setdiff(electsNames,electsNames(iCol,1)); % remove a empty cell 
% %                 numElects = numElects - 1; 
%                 idxEmptyElectrode = [idxEmptyElectrode iCol];
%                 continue;    
%             end
% 
%         %         nRows = size(elecData, 1) / SAMPLE_NUMBER_SECOND; % return # of 1s block
%         for iRow = 1:shiftblock:nRows % downsampling - 30초 shift => 600개 중 20개 계산
%             numCurrShiftBlock = numCurrShiftBlock + 1;
%             data=elecData((iRow - 1) * nData + 1 :shiftdata:iRow * nData, 1 );
%             standard = (data - mean(data))./std(data); %// Standardization normalization
%             [val, ed1] = min(f_fnn(standard, tau, max_dimension, rtol, atol));
%             %idx = numTotalShiftBlock * (ifile - 1) + numCurrShiftBlock;
%             fnn1(numCurrShiftBlock, iCol) = ed1;
%             
%             wellname{numCurrShiftBlock, 1} = sprintf([wname '-%02d'],numCurrShiftBlock);
%         end
%         numCurrShiftBlock = 0;

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

