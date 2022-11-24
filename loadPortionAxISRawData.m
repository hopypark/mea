%
% created by KT Park
% date: 2022.09.08
%
% date: 2022.10.25 ~ 26
% - modified to be applicable to various file(.raw) size.
% 
clear;

[files, path] = uigetfile({'*.raw';'*.*'},'Select One or More Files','D:\002.matlab\yenikim\data','MultiSelect','On');

[r, filesLen] = size(files); % # number of selected files
disp([num2str(filesLen) ' files selected.'])

%disp([path file])
disp(['Change directory to ' path])
cd(path)

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
% /////////////////////////////

tic
for ifile = 1:filesLen % multi-file selection

    % - one signal per electrode
    disp(['Loading...' files{1,ifile}])

    AllData = AxisFile([path files{1,ifile}]).DataSets.LoadData;
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

     [filepath, name, ext] = fileparts(files{1,ifile}); % mulitfiles
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
            if not(exist(name, 'dir'))
                mkdir([name '\mat'])
            end
            %
            % save a well data(data of 8-electrode) to .mat file 
            save([name '\mat\' tmpname],'-struct', 'well');  
        end
    end
    % end

    emsg=sprintf('%03d/%03d files completed.\n',ifile,  filesLen);
    disp(emsg)
end % for files
toc