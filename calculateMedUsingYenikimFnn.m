%
% 1. load a raw data
% 2. normalization - standardization scaler
% 3. calculate the MED(Minimal Embedding Dimension) of 1's raw electrode waveform using f_fnn.m
% 4. export results to a csv file for 1 plate
%
clc
clearvars

%
max_dimension = 10;
tau=2;
rtol = 10;
atol = 2;
%
    %% 1s block
    nRows = 600; % number of blocks when time is 1 sec
    nData = 12500; % number of data when time is 1 sec
    nCols = 8;
    %
    shiftdata = 25;
    shiftblock = 30;

    numTotalShiftBlock = 20;
    numCurrShiftBlock = 0;
    numWells = 96;

electsNames = {'electrode11';'electrode21';'electrode12';'electrode13';'electrode22';'electrode23';'electrode31';'electrode33'};
wellsname = '';

fnn1=zeros(numTotalShiftBlock * numWells, nCols);
%fnn2=zeros(nRows/shiftblock, nCols);
tmpnames=cell(numTotalShiftBlock * numWells,1);

[files,path] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\002.matlab\yenikim\data\','MultiSelect','On');
[r, filesLen] = size(files); % # number of selected files
disp([num2str(filesLen) ' files selected.'])
tic
for ifile = 1:filesLen

    elects = load([path files{1,ifile}],'Electrodes');
    wellsname = files{1,ifile}(1,24:26); % A01, A02, ..., A12, B01, ..., B12, ... , H12
%     elects = load([path files],'Electrodes');
%     wellsname = files(1,24:26);

    enames = fieldnames(elects.Electrodes);
    if ~compareCellStrings(electsNames, enames)
        disp('Two cell array is not equal.')
        break;
    end


    numElects = size(electsNames);
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


    displog = sprintf('%s - %02d/%02d..............%06.2f%% Completed.', files{1,ifile}, ifile, numWells , ifile/numWells*100);
    disp(displog)

    for iCol = 1:numElects
        disp(['electrode name: ' electsNames{iCol,1}])
        elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);
        
        for iRow = 1:shiftblock:nRows % downsampling - 30초 shift => 600개 중 20개 계산
            numCurrShiftBlock = numCurrShiftBlock + 1;
            data=elecData((iRow - 1) * nData + 1 :shiftdata:iRow * nData, 1 );
            standard = (data - mean(data))./std(data); %// Standardization normalization
            [val, ed1] = min(f_fnn(standard, tau, max_dimension, rtol, atol));
            idx = numTotalShiftBlock * (ifile - 1) + numCurrShiftBlock;
            fnn1(idx, iCol) = ed1;
            %         [fnnPerc, embTimes] = mdFnn(standard, tau);
            %         [val, ed2] = min(fnnPerc);
            %         fnn2(iRow, iCol) = ed2;
            % displog = sprintf('%03d/%04d..............%06.2f%% Completed.', iRow, nRows, iRow/nRows*100);
            %         displog = sprintf('%03d/%04d..............%05.2f%% Completed(f_fNN = %2d, mdFnn = %2d)', iRow, nRows, iRow/nRows*100, ed1, ed2);
%             displog = sprintf('[%04d] %02d/%02d..............%06.2f%% Completed(f_fNN = %2d)', idx,numCurrShiftBlock, numTotalShiftBlock, numCurrShiftBlock/numTotalShiftBlock*100, ed1);
%             disp(displog)
            tmpnames{idx, 1} = sprintf([wellsname '-%02d'],numCurrShiftBlock);
        end 
        numCurrShiftBlock = 0;
        
    end % electrodes
    % wells name
%     for i=1:20
%         tmpnames{iCol * numTotalShiftBlock + i, 1} = sprintf([wellsname '-%02d'],i);
%     end

end

tableValue = table;

tableValue.wellname = tmpnames;
tableValue.electrode11 = fnn1(:,1);
tableValue.electrode21 = fnn1(:,2);
tableValue.electrode12 = fnn1(:,3);
tableValue.electrode13 = fnn1(:,4);
tableValue.electrode22 = fnn1(:,5);
tableValue.electrode23 = fnn1(:,6);
tableValue.electrode31 = fnn1(:,7);
tableValue.electrode33 = fnn1(:,8);

writetable(tableValue,[path files{1,1}(1,1:22) '.f_fnn.csv'],'Delimiter',',','QuoteStrings',false)
toc



