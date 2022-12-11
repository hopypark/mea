
%
% Summarize results of f_fnn of yeni's algorithm about a plate for several days(for 8 day).
% - for 8 day: 
%    # 2016.07.12, 2016.07.15, 2016.07.19, 2016.07.22
%    # 2016.07.23, 2016.07.26, 2016.07,28, 2016.08.02
%

clear
clc
disp('#######################################################################')
disp('#                                                                     #')
disp('#  Running...summarizeEachPlateForSeveralDays.m                       #')
disp('#                                                                     #')
disp('#######################################################################')

baseDirectory = 'D:\999.Yeni.Kim\HomeTeam\LOG-G3.Autism-Risp+IGF-1';

NUMBER_WELLS = 96;
COLS_WELL = 12;
ROWS_WELL = 8;
NUMBER_BLOCKS_OF_WELL = 20; % number of blocks per well
LOWER_BOUND_OF_BLOCK = 3;
UPPER_BOUND_OF_BLOCK = 18;
%
MODE_VALUE = 1; MEAN_VALUE = 2; MIN_VALUE = 3;

[cellFiles, strDirPath] = uigetfile({'*.csv'}, 'Select One or More Files', baseDirectory,'MultiSelect','On');
if ~iscell(cellFiles)
    disp('Invalid file selection.')
    return;
end
filesLen = size(cellFiles, 2);

msg=sprintf('\n%d file(.csv) selected in the \''%s\'' directory.\n\n', filesLen, strDirPath);
disp(msg)

finalResult = zeros(filesLen, ROWS_WELL, COLS_WELL, 2); % 3rd parameter: 1-mode(최빈값),2-mean(평균)
%finalResult2 = zeros(filesLen, NUMBER_WELLS); % 

for ifile = 1:filesLen
    tmpName = cellFiles{1,ifile};
    T = readtable([strDirPath '\' tmpName]);
    numberElects = size(T,2); % == 9 (wellname + 8 electrodes)
    numberResults = size(T,1); % == 1920
    % check results array size(1920 x 9)
    if numberElects ~=9 || numberResults ~=1920
        emsg=sprintf('[Error] %s size is (%d, %d). Skip this file.\n', tmpName, numberResults,numberElects);
        disp(emsg)        
        continue;
    end

    msg=sprintf('%s size is (%d, %d)...OK', tmpName, numberResults,numberElects);
    disp(msg)
    % convert table to matrix
    M = [T.electrode11, T.electrode12, T.electrode13, T.electrode21, T.electrode22, T.electrode23, T.electrode31, T.electrode33];
    % per file
    colidx = 0;
    rowidx = 1;
    for iwell = 1: NUMBER_WELLS
        % result per well
        wellResult = M((iwell-1)*NUMBER_BLOCKS_OF_WELL+1:iwell*NUMBER_BLOCKS_OF_WELL, :);
%        for iblock = 1: NUMBER_BLOCKS_OF_WELL
        blockResult = wellResult(LOWER_BOUND_OF_BLOCK:UPPER_BOUND_OF_BLOCK, :);
        % col index
        if mod(iwell,COLS_WELL) == 0 
            colidx = 12;            
        else 
            colidx = mod(iwell,COLS_WELL);
        end
        cmsg=sprintf('%3d is row=%2d, col=%2d', iwell, rowidx, colidx);
        disp(cmsg)
        finalResult(ifile, rowidx, colidx, MODE_VALUE) = mode(blockResult,'all');
        finalResult(ifile, rowidx, colidx, MEAN_VALUE) = mean(blockResult,'all');
        finalResult(ifile, rowidx, colidx, MIN_VALUE) = min(blockResult,[],'all');
%        end % for iblock
        if colidx == 12
            rowidx = rowidx + 1;
        end
    end % for iwell

end %  for ifiles

%
