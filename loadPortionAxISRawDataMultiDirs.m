clc
clearvars
%
% constant
ROW_NAME = {'A','B','C','D','E','F','G','H'};
NUMBER_WELLS_ROW = 8;
NUMBER_WELLS_COL = 12;
% example) A12 --> [ ROW_NAME{1,2} num2str(a) ]

% All data
% /////////////////////////////
% load a 4-dimensional cell arry which contains the raw data for each electrode in every well.
% (Well Rows) X (Well Columns) X (Electrode Columns) X (Electrode Rows)
% - Well Row(8):    A, B, ... ,H

numWellRows = NUMBER_WELLS_ROW;

% - Well Column(12): 1, 2, ... ,12
numWellCols = NUMBER_WELLS_COL;

%
% is it possible to recurrsively traverse all subdirectories?

% set the base directory.
selpath = uigetdir('C:\');

baseDirectory = selpath;%'D:\002.matlab\yenikim\data\';
subDirs = GetSubDirsFirstLevelOnly(baseDirectory);

numDirs = size(subDirs,2);
% numFilesInSubDir = zeros(numDirs,1);
disp(['There are ' num2str(numDirs) ' subdirecotries.'])

tic
for idx = 1:numDirs
    cd([baseDirectory '\' subDirs{1,idx}]);
    % checks that there is a 'mat' subdirectory.
    %      if exist('mat','dir') == 0 || exist('mat','dir') ~= 7 % 7 means directory
    %          disp(['Wrong subdirectory structure in the ' subDirs{1,idx}])
    %          continue;
    %      end

    % /////////////////
    % Check the number of .raw files in the current folder.
    % /////////////////
    %numDirs(idx,1) = size(dir(fullfile([baseDirectory subDirs{1,idx} '\mat\'], '*.mat')),1);
    %numDirs(idx,1) = size(dir(fullfile([pwd '\mat\'], '*.mat')),1);    
    % 임시 %filesLen = size(dir(fullfile(pwd,  '*.raw')),1); 
%     filelist = dir(fullfile( ,'*.raw'));
%     filesLen = size(filelist,1);
    [filesInDir, filesLen] = GetFilesInDir([baseDirectory '\' subDirs{1,idx}], '*.raw');
    msg=sprintf('%d files(.raw) in the %s', filesLen, [baseDirectory '\' subDirs{1,idx}]);
    disp(msg)
    %% //////////////////////////////////////////////////////////////////////////////
    %  get .raw file in the subfolder
    
    tic
    for ifile = 1:filesLen % multi-file selection

        % - one signal per electrode
        disp(['Loading...' filesInDir(ifile,1).name ' in ' subDirs{1,idx}])

        AllData = AxisFile([baseDirectory '\' subDirs{1,idx} '\' filesInDir(ifile,1).name]).DataSets.LoadData;
        %     AllData = AxisFile([path files]).DataSets.LoadData;
        disp('Loading Complete')

        % check row size
        if size(AllData, 1) ~= NUMBER_WELLS_ROW
            numWellRows = size(AllData, 1);
        end

        % check column size
        if size(AllData, 2) ~= NUMBER_WELLS_COL
            numWellCols = size(AllData, 2);
        end
        %

        [filepath, name, ext] = fileparts(filesInDir(ifile,1).name); % mulitfiles
        % convert filename upper case to lower case 
        name = lower(name); %

        %    [filepath, name, ext] = fileparts(files); % single file
        % %%
        % well.info=[];
        % for wrows = 1:numWellRows
        %     for wcols = 1:numWellCols
        %         %well.WellName = ROW_NAME{}
        %                 % (col=1, row=1)
        %                 electrode11.Row = 1;
        %                 electrode11.Column = 1;
        %                 electrode11.Data = AllData{wrows, wcols, 1, 1}.Data;
        %                 % (col=1, row=2)
        %                 electrode12.Row = 2;
        %                 electrode12.Column = 1;
        %                 electrode12.Data = AllData{wrows, wcols, 1, 2}.Data;
        %                 % (col=1, row=3)
        %                 electrode13.Row = 3;
        %                 electrode13.Column = 1;
        %                 electrode13.Data = AllData{wrows, wcols, 1, 3}.Data;
        %                 %
        %                 % (col=2, row=1)
        %                 electrode21.Row = 1;
        %                 electrode21.Column = 2;
        %                 electrode21.Data = AllData{wrows, wcols, 2, 1}.Data;
        %                 % (col=2, row=2)
        %                 electrode22.Row = 2;
        %                 electrode22.Column = 2;
        %                 electrode22.Data = AllData{wrows, wcols, 2, 2}.Data;
        %                 % (col=2, row=3)
        %                 electrode23.Row = 3;
        %                 electrode23.Column = 2;
        %                 electrode23.Data = AllData{wrows, wcols, 2, 3}.Data;
        %                 %
        %                 % (col=3, row=1)
        %                 electrode31.Row = 1;
        %                 electrode31.Column = 3;
        %                 electrode31.Data = AllData{wrows, wcols, 3, 1}.Data;
        % %                 % (col=3, row=2)
        % %                 electrode32.Row = 2;
        % %                 electrode32.Column = 3;
        % %                 electrode32.Data = AllData{wrows, wcols, 3, 2}.Data;
        %                 % (col=3, row=3)
        %                 electrode33.Row = 3;
        %                 electrode33.Column = 3;
        %                 electrode33.Data = AllData{wrows, wcols, 3, 3}.Data;
        %
        %                 well.Electrodes.electrode11 = electrode11;
        %                 well.Electrodes.electrode12 = electrode12;
        %                 well.Electrodes.electrode13 = electrode13;
        %
        %                 well.Electrodes.electrode21 = electrode21;
        %                 well.Electrodes.electrode22 = electrode22;
        %                 well.Electrodes.electrode23 = electrode23;
        %
        %                 well.Electrodes.electrode31 = electrode31;
        % % blank         well.Electrodes.electrode32 = electrode32;
        %                 well.Electrodes.electrode33 = electrode33;
        %
        %                 wellname=[ROW_NAME{1, AllData{wrows, wcols, 3, 3}.Channel.WellRow} sprintf('%02d',AllData{wrows, wcols, 3, 3}.Channel.WellColumn)];
        %
        %         well.WellName = wellname;
        %         tmpname = strrep(file, '.raw', ['.' wellname '.mat']);
        %         save(tmpname,'-struct', 'well');
        %     end
        % end
        %
        % % 2022.09.16 completed

        % ////////////////////////////////
        % type check of Wells & Electrodes . 2022.10.25~26
        %
        % well data extraction using cell's type check(empty cell)
        % ////////////////////////////////
        well.info=[];
        for wrows = 1:numWellRows
            for wcols = 1:numWellCols
                % fixing exception raised using unused well index.
                try
                    % making well name using row and column index of well.
                    wellname=[ROW_NAME{1, AllData{wrows, wcols, 3, 3}.Channel.WellRow} sprintf('%02d',AllData{wrows, wcols, 3, 3}.Channel.WellColumn)];
                catch ME
                    msg = sprintf('Exception: Using unused well index...%d,%d' , wrows, wcols);                disp(msg)
                    continue;
                end

                % extract electrodes data for a well
                for ecols = 1:3
                    for erows = 1:3
                        try
                            %e=AllData{wrows, wcols, ecols,erows}.Data;
                            %sprintf('%d, %d array is waveform.', ecols , erows)
                            %str = 'sprintf("electrode%d%d.row=AllData{%d, %d, %d, %d}.Data;",ecols,erows,wrows,wcols,ecols,erows)';
                            eval(sprintf("well.Electrodes.electrode%d%d.Row= %d;",ecols,erows, erows));
                            eval(sprintf("well.Electrodes.electrode%d%d.Column=%d;",ecols,erows,ecols));
                            eval(sprintf("well.Electrodes.electrode%d%d.Data=AllData{%d, %d, %d, %d}.Data;",ecols,erows,wrows,wcols,ecols,erows));
                        catch
                            msg=sprintf('Electrode - %d, %d in the well(%d, %d) is empty.', ecols, erows, wrows, wcols);
                            disp(msg)
                            continue;
                        end
                    end
                end % end of a well

                % making a filename
                well.WellName = wellname;
                tmpname = [name '.' wellname '.mat'];

                % if 'mat' subfolder is not exist, then make subfolder that name is 'mat'
                if not(exist([baseDirectory '\mat'], 'dir'))
                    mkdir([baseDirectory '\mat'])
                end

                
                if not(exist([baseDirectory '\mat\' name], 'dir'))
                    mkdir([baseDirectory '\mat\' name])
                end

                %
                % save a well data(data of 8-electrode) to .mat file
                save([baseDirectory '\mat\' name '\' tmpname],'-struct', 'well');
            end
        end
        % end

        emsg=sprintf('%03d/%03d files completed.\n',ifile,  filesLen);
        disp(emsg)
    end % for files
    toc

    disp([num2str(filesLen) ' files in the ' subDirs{1,idx} ' folder is finished.'])
    
    %% //////////////////////////////////////////////////////////////////////////////
    cd('..')
end
toc

% //////////////////////////////////////////////////////////////////////////////////
% 
% function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
%  :Get a list of all folders in the parentDir.
%  
%  return
%  - subDirsNames: return the folder names into a cell array
% //////////////////////////////////////////////////////////////////////////////////

function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
    % Get a list of all files and folders in this folder.
    files = dir(parentDir);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subDirs = files(dirFlags); % A structure with extra info.
    % Get only the folder names into a cell array.
    subDirsNames = {subDirs(3:end).name};
end

% //////////////////////////////////////////////////////////////////////////////////
% 
% function [filesInDir, numFiles] = GetFilesInDir(dir, filetype)
% 
% //////////////////////////////////////////////////////////////////////////////////
function [filesInDir, numFiles] = GetFilesInDir(currntDir, filetype)
    filesInDir = dir(fullfile(currntDir, filetype));
    numFiles = size(filesInDir,1);
    %msg=sprintf('%d files(.raw) in the %s', filesLen, [baseDirectory '\' subDirs{1,idx}]);
    %disp(msg)
end