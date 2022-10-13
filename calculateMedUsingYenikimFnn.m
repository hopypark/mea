clc
clearvars

max_dimension = 10;
tau=2;
rtol = 10;
atol = 2;


elects = load('D:\002.matlab\yenikim\data\plate1_2016.07.12(000).A01.mat','Electrodes');

electsNames = fieldnames(elects.Electrodes);
numElects = size(electsNames);
% 
% % 0.2s block
% nRows = 3000; % number of blocks when time is 0.2 sec
% nData = 2500; % number of data when time is 0.2 sec
% nCols = 8;
% 
% fnn1=zeros(nRows, nCols);
% fnn2=zeros(nRows, nCols);
% tic
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

%% 1s block
nRows = 600; % number of blocks when time is 1 sec
nData = 12500; % number of data when time is 1 sec
nCols = 8;
%
shiftdata = 25;
shiftblock = 30;

numTotalShiftBlock = 20;
numCurrShiftBlock = 0;

fnn1=zeros(nRows/shiftblock, nCols);
fnn2=zeros(nRows/shiftblock, nCols);

tic
for iCol = 1:numElects
    disp(['name: ' electsNames{iCol,1}])
    elecData = double(elects.Electrodes.(electsNames{iCol,1}).Data);

    for iRow = 1:shiftblock:nRows % downsampling - 30초 shift => 600개 중 20개 계산
        numCurrShiftBlock = numCurrShiftBlock + 1;
        data=elecData((iRow - 1) * nData + 1 :shiftdata:iRow * nData, 1 );
        standard = (data - mean(data))./std(data); %// Standardization normalization
        [val, ed1] = min(f_fnn(standard, tau, max_dimension, rtol, atol));            
        fnn1(iRow, iCol) = ed1;        
        [fnnPerc, embTimes] = mdFnn(standard, tau);
        [val, ed2] = min(fnnPerc);
        fnn2(iRow, iCol) = ed2;        
       % displog = sprintf('%03d/%04d..............%06.2f%% Completed.', iRow, nRows, iRow/nRows*100);
%         displog = sprintf('%03d/%04d..............%05.2f%% Completed(f_fNN = %2d, mdFnn = %2d)', iRow, nRows, iRow/nRows*100, ed1, ed2);
        displog = sprintf('%02d/%02d..............%06.2f%% Completed(f_fNN = %2d, mdFnn = %2d)', numCurrShiftBlock, numTotalShiftBlock, numCurrShiftBlock/numTotalShiftBlock*100, ed1, ed2);
        disp(displog)        
    end
    numCurrShiftBlock = 0;
end
toc



