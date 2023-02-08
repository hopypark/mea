% run1

clear
clc


ROW_WELLNAME = {'A','B','C','D','E','F','G','H'};
% run1
DATE_TO_DAY_TICK = 1:15;
DATE_TO_DAY = {'1','4','8','11','12','15','17','22','24','29','31','36','38','43','47'};
% run2
% DATE_TO_DAY_TICK = 1:16;
% DATE_TO_DAY = {'1','2','3','8','10','15','17','22','24','29','31','33','36','38','40','43'};

% NUMBER_OF_ELECTRODS = 9;
% NUMBER_OF_GROUPWELLS_PER_PLATE = 24;
% NUMBER_OF_GROUP_WELLS = NUMBER_OF_GROUPWELLS_PER_PLATE * 2;
% 
% attnEnAutism = ones(NUMBER_OF_ELECTRODS * NUMBER_OF_GROUPWELLS_PER_PLATE,15); % 9 - #electrode, 15 - # day
% attnEnControl = ones(NUMBER_OF_ELECTRODS * NUMBER_OF_GROUPWELLS_PER_PLATE,15); % 9 - #electrode, 15 - # day

% run1
attnEnAutism1 = zeros(9,15); % 9 - #electrode, 15 - # day
attnEnControl1 = zeros(9,15); % 9 - #electrode, 15 - # day
attnEnAutism3 = zeros(9,15); % 9 - #electrode, 15 - # day
attnEnControl3 = zeros(9,15); % 9 - #electrode, 15 - # day
% run2
% attnEnAutism1 = zeros(9,16); % 9 - #electrode, 15 - # day
% attnEnControl1 = zeros(9,16); % 9 - #electrode, 15 - # day
% attnEnAutism3 = zeros(9,16); % 9 - #electrode, 15 - # day
% attnEnControl3 = zeros(9,16); % 9 - #electrode, 15 - # day

% Plate1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run1
[files1,path1] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run1_spk\plate1','MultiSelect','On');
% run2
% [files1,path1] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run2_spk\plate2','MultiSelect','On');

if ~iscell(files1)
    file = files1;
    files1=cell(1,1);
    files1{1,1} = file;
end

% Plate3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run1
[files2,path2] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run1_spk\plate3','MultiSelect','On');
% run2
% [files2,path2] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run2_spk\plate4','MultiSelect','On');

if ~iscell(files2)
    file = files2;
    files2=cell(1,1);
    files2{1,1} = file;
end

% Plate1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nloop=1:length(files1) % file loop
    load([path1 files1{1, nloop}]);
    % Autism
    for nwr = 1:4
        for nwc = 1:6  % for H2O or DMSO
%         for nwc = 7:12  % for IGF or RSP           
%             eval(sprintf('attnEnAutism(((nwr-1)*6+(nwc-1)*9+1):((nwr-1)*6+(nwc)*9), %d)=attnEntAvgValue.well%s%02d;',nloop, ROW_WELLNAME{1,nwr},nwc));            
            eval(sprintf('attnEnAutism1(:, %d)=attnEnAutism1(:, %d)+attnEntAvgValue.well%s%02d;',nloop, nloop, ROW_WELLNAME{1,nwr},nwc));            
        end
    end
%     
    % Control
    for nwr = 5:8
        for nwc = 1:6  % for H2O or DMSO
%         for nwc = 7:12  % for IGF or RSP
%             eval(sprintf('attnEnControl(((nwr-1)*6+(nwc-1)*9+1):((nwr-1)*6+(nwc)*9), %d)=attnEntAvgValue.well%s%02d;',nloop, ROW_WELLNAME{1,nwr},nwc));            
              eval(sprintf('attnEnControl1(:, %d)=attnEnControl1(:, %d)+attnEntAvgValue.well%s%02d;',nloop, nloop, ROW_WELLNAME{1,nwr},nwc));            
        end
    end
end

% Plate3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nloop=1:length(files2) % file loop
    load([path2 files2{1, nloop}]);
    % Autism
    for nwr = 1:4
        for nwc = 1:6  % for H2O or DMSO
%         for nwc = 7:12  % for IGF or RSP 
            eval(sprintf('attnEnAutism3(:, %d)=attnEnAutism3(:, %d)+attnEntAvgValue.well%s%02d;',nloop, nloop, ROW_WELLNAME{1,nwr},nwc));            
        end
    end
    
    % Control
    for nwr = 5:8
        for nwc = 1:6  % for H2O or DMSO
%         for nwc = 7:12  % for IGF or RSP  
            eval(sprintf('attnEnControl3(:, %d)=attnEnControl3(:, %d)+attnEntAvgValue.well%s%02d;',nloop, nloop, ROW_WELLNAME{1,nwr},nwc));            
        end
    end
end

% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plate1: Control & Autism
figure;plot(((sum(attnEnAutism1,1))./8)./24,'ro-');
hold on;
plot(((sum(attnEnControl1,1))./8)./24,'bo-');
title('Mean-AttnEn of Plate1');
legend({'Autism','Control'})
xticks(DATE_TO_DAY_TICK);
xticklabels(DATE_TO_DAY);
% xlim([0 16]); %run1
xlim([0 17]);  % run2
xlabel('Days');ylabel('mean AttnEn')

% Plate3: Control & Autism
figure;plot(((sum(attnEnAutism3,1))./8)./24,'ro-');
hold on;
plot(((sum(attnEnControl3,1))./8)./24,'bo-');
title('Mean-AttnEn of Plate3');
legend({'Autism','Control'})
xticks(DATE_TO_DAY_TICK);
xticklabels(DATE_TO_DAY);
% xlim([0 16]); %run1
xlim([0 17]);  % run2
xlabel('Days');ylabel('mean AttnEn')


% Plate1 + Plate3: Control & Autism
figure;plot(((sum(attnEnAutism1+attnEnAutism3,1))./8)./48,'ro-');
hold on;
plot(((sum(attnEnAutism1+attnEnControl3,1))./8)./48,'bo-');
title('Mean-AttnEn of Plate1 & Plate3');
legend({'Autism','Control'})
xticks(DATE_TO_DAY_TICK);
xticklabels(DATE_TO_DAY);
% xlim([0 16]); %run1
xlim([0 17]);  % run2
xlabel('Days');ylabel('mean AttnEn')