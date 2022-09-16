%
% created by KT Park
% date: 2022.09.08
%
clear;

[file, path] = uigetfile({'*.raw';'*.*'},'Select a File(s)','D:\002.matlab\yenikim\data');
%disp([path file])
disp(['Change directory to ' path])
cd(path)

% constant
ROW_NAME = {'A','B','C','D','E','F','G','H'};

% A12 --> [ ROW_NAME{1,2} num2str(a) ]

% All data
% load a 4-dimensional cell arry which contains the raw data for each electrode in every well.
% (Well Rows) X (Well Columns) X (Electrode Columns) X (Electrode Rows)
% - Well Row(8):    A, B, ... ,H
% - Well Column(12): 1, 2, ... ,12

% - one signal per electrode
disp(['Loading...' file])
AllData = AxisFile([path file]).DataSets.LoadData;
disp('Loading is Completed')
%%
well.info=[];
for wrows = 1 : 8
    for wcols = 1:12
        %well.WellName = ROW_NAME{}
                % (col=1, row=1)
                electrode11.Row = 1;
                electrode11.Column = 1;
                electrode11.Data = AllData{wrows, wcols, 1, 1}.Data;                
                % (col=1, row=2)
                electrode12.Row = 2;
                electrode12.Column = 1;
                electrode12.Data = AllData{wrows, wcols, 1, 2}.Data;         
                % (col=1, row=3)
                electrode13.Row = 3;
                electrode13.Column = 1;
                electrode13.Data = AllData{wrows, wcols, 1, 3}.Data;     
                %
                % (col=2, row=1)
                electrode21.Row = 1;
                electrode21.Column = 2;
                electrode21.Data = AllData{wrows, wcols, 2, 1}.Data;  
                % (col=2, row=2)
                electrode22.Row = 2;
                electrode22.Column = 2;
                electrode22.Data = AllData{wrows, wcols, 2, 2}.Data;
                % (col=2, row=3)
                electrode23.Row = 3;
                electrode23.Column = 2;
                electrode23.Data = AllData{wrows, wcols, 2, 3}.Data;                
                %
                % (col=3, row=1)
                electrode31.Row = 1;
                electrode31.Column = 3;
                electrode31.Data = AllData{wrows, wcols, 3, 1}.Data;  
%                 % (col=3, row=2)
%                 electrode32.Row = 2;
%                 electrode32.Column = 3;
%                 electrode32.Data = AllData{wrows, wcols, 3, 2}.Data;
                % (col=3, row=3)
                electrode33.Row = 3;
                electrode33.Column = 3;
                electrode33.Data = AllData{wrows, wcols, 3, 3}.Data;                 

                well.Electrodes.electrode11 = electrode11;
                well.Electrodes.electrode12 = electrode12;
                well.Electrodes.electrode13 = electrode13;

                well.Electrodes.electrode21 = electrode21;
                well.Electrodes.electrode22 = electrode22;
                well.Electrodes.electrode23 = electrode23;

                well.Electrodes.electrode31 = electrode31;
% blank         well.Electrodes.electrode32 = electrode32;
                well.Electrodes.electrode33 = electrode33;

                wellname=[ROW_NAME{1, AllData{wrows, wcols, 3, 3}.Channel.WellRow} sprintf('%02d',AllData{wrows, wcols, 3, 3}.Channel.WellColumn)];

        well.WellName = wellname;
        tmpname = strrep(file, '.raw', ['.' wellname '.mat']);
        save(tmpname,'-struct', 'well');
    end
end








