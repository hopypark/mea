% run1

clear
clc


ROW_WELLNAME = {'A','B','C','D','E','F','G','H'};
% run1
DATE_TO_DAY_TICK = 1:15;
DATE_TO_DAY = {'1','4','8','11','12','15','17','22','24','29','31','36','38','43','47'};

% NUMBER_OF_ELECTRODS = 9;
% NUMBER_OF_GROUPWELLS_PER_PLATE = 24;
% NUMBER_OF_GROUP_WELLS = NUMBER_OF_GROUPWELLS_PER_PLATE * 2;
% 
% attnEnAutism = ones(NUMBER_OF_ELECTRODS * NUMBER_OF_GROUPWELLS_PER_PLATE,15); % 9 - #electrode, 15 - # day
% attnEnControl = ones(NUMBER_OF_ELECTRODS * NUMBER_OF_GROUPWELLS_PER_PLATE,15); % 9 - #electrode, 15 - # day

% run1
attnEnAutism1 = zeros(8*48,15); % 8 - #electrode, 15 - # day, excluding e32
attnEnControl1 = zeros(8*48,15); % 8 - #electrode, 15 - # day, excluding e32
% attnEnAutism3 = zeros(9,15); % 9 - #electrode, 15 - # day
% attnEnControl3 = zeros(9,15); % 9 - #electrode, 15 - # day

% Plate1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run1
[files1,path1] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run1_spk\plate1','MultiSelect','On');

if ~iscell(files1)
    file = files1;
    files1=cell(1,1);
    files1{1,1} = file;
end

% Plate3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run1
[files2,path2] = uigetfile({'*.mat'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run1_spk\plate3','MultiSelect','On');

if ~iscell(files2)
    file = files2;
    files2=cell(1,1);
    files2{1,1} = file;
end

nNum = 1;
% Plate1 & Plate3  -> Autisum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plate1

for nloop=1:length(files1) % file loop
    load([path1 files1{1, nloop}]);
    % Autism
    for nwr = 1:4
%         for nwc = 1:6  % for H2O or DMSO
        for nwc = 7:12  % for IGF or RSP           
%             eval(sprintf('attnEnAutism(((nwr-1)*6+(nwc-1)*9+1):((nwr-1)*6+(nwc)*9), %d)=attnEntAvgValue.well%s%02d;',nloop, ROW_WELLNAME{1,nwr},nwc));            
            eval(sprintf('tempAttnEn=attnEntAvgValue.well%s%02d;', ROW_WELLNAME{1,nwr},nwc));            
            eval(sprintf('attnEnAutism1(%d:%d, %d)=tempAttnEn([1:7 9], 1);',(nNum-1)*8+1, nNum*8, nloop));            
            nNum = nNum + 1;
        end
    end
    nNum = 1;
end
% plate3
nNum = 25;
for nloop=1:length(files2) % file loop
    load([path2 files2{1, nloop}]);
    % Autism
    for nwr = 1:4
%         for nwc = 1:6  % for H2O or DMSO
        for nwc = 7:12  % for IGF or RSP 
            eval(sprintf('tempAttnEn=attnEntAvgValue.well%s%02d;', ROW_WELLNAME{1,nwr},nwc));            
%             eval(sprintf('attnEnAutism1(:, %d)=attnEnAutism1(:, %d)+tempAttnEn([1:7 9], 1);',nloop, nloop)); 
            eval(sprintf('attnEnAutism1(%d:%d, %d)=tempAttnEn([1:7 9], 1);',(nNum-1)*8+1, nNum*8, nloop));            
            nNum = nNum + 1;
        end
        
    end
    nNum = 25;
end

% Plate1 & Plate3  -> Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plate1
nNum = 1;
for nloop=1:length(files1) % file loop
    load([path1 files1{1, nloop}]);
    % Control
    for nwr = 5:8
%         for nwc = 1:6  % for H2O or DMSO
        for nwc = 7:12  % for IGF or RSP
            eval(sprintf('tempAttnEn=attnEntAvgValue.well%s%02d;', ROW_WELLNAME{1,nwr},nwc));
%             eval(sprintf('attnEnControl1(:, %d)=attnEnControl1(:, %d)+tempAttnEn([1:7 9], 1);',nloop, nloop));            
            eval(sprintf('attnEnControl1(%d:%d, %d)=tempAttnEn([1:7 9], 1);',(nNum-1)*8+1, nNum*8, nloop));            
        nNum = nNum + 1;            
        end
    end
    nNum = 1;
end
% plate3
nNum = 25;
for nloop=1:length(files2) % file loop
    load([path2 files2{1, nloop}]);
    % Control
    for nwr = 5:8
%         for nwc = 1:6  % for H2O or DMSO
        for nwc = 7:12  % for IGF or RSP  
            eval(sprintf('tempAttnEn=attnEntAvgValue.well%s%02d;', ROW_WELLNAME{1,nwr},nwc));
%             eval(sprintf('attnEnControl1(:, %d)=attnEnControl1(:, %d)+tempAttnEn([1:7 9], 1);',nloop, nloop));            
            eval(sprintf('attnEnControl1(%d:%d, %d)=tempAttnEn([1:7 9], 1);',(nNum-1)*8+1, nNum*8, nloop));            
            nNum = nNum + 1;
        end        
    end
    nNum = 25;
end


% plot
figure;
plot(mean(attnEnAutism1), 'ro-');
hold on;plot(mean(attnEnControl1), 'bs-'); 
title('Mean-AttnEn of Plate2 & Plate4, RSP');

xticks(DATE_TO_DAY_TICK);
xticklabels(DATE_TO_DAY);
xlim([0 16]); %run1
% xlim([0 17]);  % run2
xlabel('Days');ylabel('mean AttnEn');
legend({'Autism','Control'});
grid on;

% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plate1, Plate3: Control & Autism
% figure;plot(((sum(attnEnAutism1,1))./8)./48,'ro-');
% hold on;
% plot(((sum(attnEnControl1,1))./8)./48,'bs-');
% title('Mean-AttnEn of Plate1');
% legend({'Autism','Control'})
% xticks(DATE_TO_DAY_TICK);
% xticklabels(DATE_TO_DAY);
% % xlim([0 16]); %run1
% xlim([0 17]);  % run2
% xlabel('Days');ylabel('mean AttnEn')

% % Plate3: Control & Autism
% figure;plot(((sum(attnEnAutism3,1))./8)./24,'ro-');
% hold on;
% plot(((sum(attnEnControl3,1))./8)./24,'bo-');
% title('Mean-AttnEn of Plate3');
% legend({'Autism','Control'})
% xticks(DATE_TO_DAY_TICK);
% xticklabels(DATE_TO_DAY);
% % xlim([0 16]); %run1
% xlim([0 17]);  % run2
% xlabel('Days');ylabel('mean AttnEn')
% 
% 
% % Plate1 + Plate3: Control & Autism
% figure;plot(((sum(attnEnAutism1+attnEnAutism3,1))./8)./48,'ro-');
% hold on;
% plot(((sum(attnEnAutism1+attnEnControl3,1))./8)./48,'bo-');
% title('Mean-AttnEn of Plate1 & Plate3');
% legend({'Autism','Control'})
% xticks(DATE_TO_DAY_TICK);
% xticklabels(DATE_TO_DAY);
% % xlim([0 16]); %run1
% xlim([0 17]);  % run2
% xlabel('Days');ylabel('mean AttnEn')