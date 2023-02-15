% loading spike data file(*.spk)
clear 

% wellname = 'A-1, B-2, C-3, D-4, E-5, F-6, G-7, H-8';
COL_WELLNAME = 1:12;
ROW_WELLNAME = {'A','B','C','D','E','F','G','H'};

% file selection
[files,path] = uigetfile({'*.spk'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk\run2_spk\','MultiSelect','On');

if ~iscell(files)
    file = files;
    files=cell(1,1);
    files{1,1} = file;
end


for nloop=1:length(files) % file loop

AllData = AxisFile([path files{1, nloop}]).DataSets.LoadData;
[nwr, nwc, nec, ner]=size(AllData);
fprintf('%s.................................................................Starting\n',files{1, nloop});
% 
% avg value, one of Attention Entropy(aveg, max-max, min-min, max-min, min-max)
% attnEntAvgValue=zeros(9, 8, 12); % 8 - the number of row well, 12 - the number of column well, 9 - the number of electrodes
% attnEntAvgWell=zeros(9, 1); % 9-number of electode, 1 - AttnEn(avg)
%
attnEn = [];
for m = 1:nwr
    for n = 1:nwc
%         figure('Position',[100, 200, 900, 500]);
        fprintf('Calculating the Attendtion Entropy of Well(%d,%2d)...............................',m,n);
        attnEntAvgWell=zeros(9, 1); % 9-number of electode, 1 - AttnEn(avg)
        for i = 1:nec
            for j = 1:ner
                %Select the spike times from each electrode in the well\

                if ~isempty(eval(sprintf('AllData{%d,%d,%d,%d}',m, n, i, j)))
                    ts = eval(sprintf('[AllData{%d,%d,%d,%d}(:).Start]',m, n, i, j));
                    %         if ~isempty(AllData{2,2,i,j}) % In case of having spike(s)
                    %             ts=[AllData{2,2,i,j}(:).Start];
                    % Calculating Attend Entropy
                    
%                     fprintf('Calculating Attendtion Entropy nec = %d, ner = %d ...........................', i,j)
                    if size(ts,2) > 20
                        attnEntAvgWell((i-1)*ner+j,1)=AttnEn(diff(ts(1,:)));
%                         attnEntAvgValue((i-1)*ner+j,m,n) = Attn;
%                         fprintf('Calculating the Attendtion Entropy of nwr = %d, nwc = %d, nec = %d, ner = %d, # Avg_AttnEn  = %g\n', m,n,i,j, attnEntAvgValue((i-1)*ner+j,m,n));
                    end
%                     fprintf('end\n');

%                     hold on;
%                     %Plot a vertical line at each
%                     plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k');
%                     fprintf('nec = %d, ner = %d, # spikes = %d\n', i,j, size(ts,2));
%                     text(605, -(i-1) * ner - j + 0.5, sprintf('E%d%d=%d',i,j,size(ts,2)));
%                     %timepoint corresponding to a spike
%                     hold off;

                else
                    %continue;
%                     hold on;
%                     ts=0;
%                     fprintf('nec = %d, ner = %d, # spikes = %d, \n', i,j, size(ts,2)-1);
%                     plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k');
%                     text(605, -(i-1) * ner - j + 0.5, sprintf('E%d%d=%d',i,j,0));
%                     hold off;
                end
            end % ner
        end % nec
        fprintf('Saving...');
        eval(sprintf('attnEntAvgValue.well%s%02d=attnEntAvgWell;',ROW_WELLNAME{1,m},n));
        fprintf('End\n');
    end % for nwc
end % for nwr

% save([path strrep(strrep(files{1, nloop},'.spk','.AttnEn.mat'),'_','-')], 'attnEntAvgValue');
end % for nloop, file loop


% title(sprintf('%s(Well - %s%s)',strrep(file,'_','-'), ROW_WELLNAME{1, str2double(wrow)} ,wcol),'FontSize',13);
% xlabel('time(sec)');ylabel('electrode');
% x1=[200 200]; y1=[0 -9];
% x2=[400 400]; y2=[0 -9];
% line(x1,y1,'Color','red','LineWidth',2);line(x2,y2,'Color','red','LineWidth',2);
% grid on;box on;
% 
% T=array2table(attnEntValue,'VariableNames',{'Attn', 'Hxx', 'Hnn', 'Hxn', 'Hnx'});

